"""
Comprehensive ML pipeline for PhysioFlow on Vertex AI
Handles data collection, processing, and model training
"""
import os
import argparse
import tempfile
import subprocess
import shutil
import time
import json
from pathlib import Path
from google.cloud import storage, aiplatform
from google.cloud.storage import Blob
from google.cloud import videointelligence_v1 as videointelligence 

# Import from local modules
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from data_collection.video_collector import download_videos, use_local_videos
from preprocessing.pose_processor import process_frames, process_all_videos
try:
    from training.train_local import load_config, build_model, load_and_prepare_data, train_model
except ImportError:
    print("Warning: train_local.py not fully imported. Make sure it exists with required functions.")

class PhysioFlowMLPipeline:
    """End-to-end ML pipeline for PhysioFlow knee exercise analysis"""
    
    def __init__(self, project_id, region, bucket_name, config_path='ml/training/config.yaml'):
        """Initialize the pipeline"""
        self.project_id = project_id
        self.region = region
        self.bucket_name = bucket_name
        self.config_path = config_path
        self.local_data_dir = tempfile.mkdtemp(prefix="physioflow_")
        self.storage_client = storage.Client(project=project_id)
        
        # Landmark indices for knee and torso targeting
        # These indices correspond to MediaPipe pose landmarks
        self.knee_landmarks = {
            23, 24,  # Left and right hip
            25, 26,  # Left and right knee
            27, 28,  # Left and right ankle
            29, 30, 31, 32  # Foot landmarks
        }
        
        self.torso_landmarks = {
            11, 12,  # Shoulders
            23, 24,  # Hips
            33,      # Spine (mid)
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10  # Face and upper body landmarks
        }
        
        # Combined set for knee-focused physiotherapy
        self.target_landmarks = self.knee_landmarks.union(self.torso_landmarks)
        
        # Create bucket if it doesn't exist
        try:
            self.bucket = self.storage_client.get_bucket(bucket_name)
        except Exception:
            print(f"Creating new bucket: {bucket_name}")
            self.bucket = self.storage_client.create_bucket(
                bucket_name, 
                location=region
            )
        
        # Initialize Vertex AI
        aiplatform.init(
            project=project_id, 
            location=region,
            staging_bucket=f"gs://{self.bucket_name}"  # Add staging bucket
)
    
    def collect_videos(self, search_term=None, max_videos=10, local_video_dir=None):
        """Collect videos for training - either from YouTube or local directory"""
        print("Step 1: Collecting videos...")
        
        if local_video_dir:
            # Use local videos if directory is provided
            video_dir = use_local_videos(local_video_dir, 
                                         os.path.join(self.local_data_dir, "videos"))
        else:
            # Fall back to YouTube download if no local directory provided
            video_dir = download_videos(search_term, max_videos, 
                                        os.path.join(self.local_data_dir, "videos"))
        
        return video_dir
    
    def _download_videos_fallback(self, search_term, max_videos, output_dir):
        """Fallback implementation for video downloading"""
        print("Using fallback video downloader")
        # Basic implementation in case the import fails
        subprocess.run([
            "python", "-m", "pytube", 
            f"ytsearch:{search_term}", 
            "--output", output_dir,
            "--limit", str(max_videos)
        ])
    
    def process_video_frames(self, video_dir):
        """Process videos to extract frames and landmarks"""
        print("Processing video frames")
        
        # Create directories
        frames_dir = os.path.join(self.local_data_dir, "frames")
        os.makedirs(frames_dir, exist_ok=True)
        
        landmarks_dir = os.path.join(self.local_data_dir, "landmarks")
        os.makedirs(landmarks_dir, exist_ok=True)
        
        # Extract frames from videos
        self._extract_frames(video_dir, frames_dir)
        
        # Process frames to extract landmarks
        try:
            process_all_videos(frames_dir, landmarks_dir)
        except Exception as e:
            print(f"Error processing videos: {str(e)}")
            # If import fails, try using the subprocess approach
            print("Using subprocess to process videos")
            subprocess.run([
                "python", "-m", "ml.preprocessing.pose_processor",
                "--input-dir", frames_dir,
                "--output-dir", landmarks_dir
            ])
        
        return landmarks_dir
    
    def _extract_frames(self, video_dir, frames_dir):
        """Extract frames from videos using ffmpeg"""
        print("Extracting frames from videos")
        
        # Check if ffmpeg is available
        try:
            subprocess.run(["ffmpeg", "-version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        except FileNotFoundError:
            print("Error: ffmpeg not found. Please install ffmpeg.")
            return
        
        # Process each video
        for video_file in os.listdir(video_dir):
            if not video_file.endswith('.mp4'):
                continue
                
            video_path = os.path.join(video_dir, video_file)
            video_name = os.path.splitext(video_file)[0]
            frames_output_dir = os.path.join(frames_dir, video_name)
            os.makedirs(frames_output_dir, exist_ok=True)
            
            print(f"Extracting frames from {video_file}")
            subprocess.run([
                "ffmpeg", 
                "-i", video_path,
                "-vf", "fps=2",
                f"{frames_output_dir}/%04d.jpg",
                "-hide_banner",
                "-loglevel", "error"
            ])
    
    def process_video_landmarks(self, video_gcs_path, target_specific_landmarks=True):
        """Process videos with Video Intelligence API focusing on knee and torso landmarks"""
        print(f"Processing video with Video Intelligence API: {video_gcs_path}")
        if target_specific_landmarks:
            print("Targeting knee and torso landmarks for physiotherapy analysis")
        
        # Create Video Intelligence client
        video_client = videointelligence.VideoIntelligenceServiceClient()
        
        # Configure the request
        features = [videointelligence.Feature.PERSON_DETECTION]
        
        # Set up processing - adjust based on your needs
        person_config = videointelligence.PersonDetectionConfig(
            include_pose_landmarks=True,
            include_bounding_boxes=False
        )
        
        config = videointelligence.VideoContext(
            person_detection_config=person_config
        )
        
        # Launch the asynchronous request
        operation = video_client.annotate_video(
            request={
                "features": features,
                "input_uri": video_gcs_path,
                "video_context": config,
            }
        )
        
        print("Processing video. This may take some time.")
        result = operation.result(timeout=300)
        
        # Process and save the landmarks
        landmarks_dir = os.path.join(self.local_data_dir, "landmarks")
        os.makedirs(landmarks_dir, exist_ok=True)
        
        # Get video filename for naming the output files
        video_filename = video_gcs_path.split('/')[-1].split('.')[0]
        
        # Extract landmarks from the response
        for annotation in result.annotation_results:
            for person_detection in annotation.person_detection_annotations:
                for track in person_detection.tracks:
                    # Process each frame that has pose landmarks
                    for timestamp in track.timestamps:
                        if timestamp.pose_landmarks:
                            frame_time = timestamp.time_offset.seconds + timestamp.time_offset.nanos / 1e9
                            frame_id = f"{video_filename}_frame_{int(frame_time * 1000)}"
                            
                            # Save landmarks to file
                            landmarks_data = {}
                            
                            # For knee emphasis, we track the bounding box of knee area
                            knee_min_x, knee_min_y = float('inf'), float('inf')
                            knee_max_x, knee_max_y = float('-inf'), float('-inf')
                            
                            # First pass: find knee bounding box if targeting specific landmarks
                            if target_specific_landmarks:
                                for i, landmark in enumerate(timestamp.pose_landmarks):
                                    if i in self.knee_landmarks:
                                        knee_min_x = min(knee_min_x, landmark.x)
                                        knee_min_y = min(knee_min_y, landmark.y)
                                        knee_max_x = max(knee_max_x, landmark.x)
                                        knee_max_y = max(knee_max_y, landmark.y)
                            
                            # Second pass: save landmarks
                            for i, landmark in enumerate(timestamp.pose_landmarks):
                                # If targeting specific landmarks, only save those in our target set
                                if not target_specific_landmarks or i in self.target_landmarks:
                                    # Additional metadata for knee landmarks to emphasize their importance
                                    is_knee_landmark = i in self.knee_landmarks
                                    
                                    # For knee landmarks, calculate normalized position within knee region
                                    if is_knee_landmark and knee_max_x > knee_min_x and knee_max_y > knee_min_y:
                                        norm_x = (landmark.x - knee_min_x) / (knee_max_x - knee_min_x)
                                        norm_y = (landmark.y - knee_min_y) / (knee_max_y - knee_min_y)
                                    else:
                                        norm_x = landmark.x
                                        norm_y = landmark.y
                                    
                                    # Store more detailed data for knee landmarks
                                    landmarks_data[str(i)] = {
                                        "x": landmark.x,
                                        "y": landmark.y,
                                        "z": landmark.z if hasattr(landmark, 'z') else 0.0,
                                        "visibility": landmark.visibility,
                                        "normalized_x": norm_x,
                                        "normalized_y": norm_y,
                                        "landmark_type": "knee" if is_knee_landmark else "torso" if i in self.torso_landmarks else "other"
                                    }
                            
                            # Add metadata
                            landmarks_data["metadata"] = {
                                "target_area": "knee_and_torso" if target_specific_landmarks else "full_body",
                                "emphasis": "knee",
                                "frame_time": frame_time,
                                "video_path": video_gcs_path
                            }
                            
                            # Save to file
                            output_path = os.path.join(landmarks_dir, f"{frame_id}.json")
                            with open(output_path, 'w') as f:
                                json.dump(landmarks_data, f)
        
        return landmarks_dir

    def process_video_from_gcs(self, videos_gcs_path, target_specific_landmarks=True):
        """Process all videos from GCS using Video Intelligence API"""
        print(f"Processing videos from {videos_gcs_path}")
        if target_specific_landmarks:
            print("Focusing on knee and torso landmarks for physiotherapy analysis")
        
        # Strip the gs:// prefix and bucket name
        gcs_prefix = videos_gcs_path.replace(f"gs://{self.bucket_name}/", "")
        
        # List all video files in the GCS path
        blobs = self.storage_client.list_blobs(
            self.bucket_name, 
            prefix=gcs_prefix
        )
        
        # Initialize empty landmarks directory
        landmarks_dir = os.path.join(self.local_data_dir, "landmarks")
        os.makedirs(landmarks_dir, exist_ok=True)
        
        # Process each video file
        for blob in blobs:
            if blob.name.endswith('.mp4'):
                video_gcs_path = f"gs://{self.bucket_name}/{blob.name}"
                print(f"Processing video: {video_gcs_path}")
                
                # Use Video Intelligence API to process this video with landmark targeting
                self.process_video_landmarks(video_gcs_path, target_specific_landmarks)
        
        return landmarks_dir

    def upload_to_gcs(self, local_dir, gcs_prefix):
        """Upload local directory to GCS bucket"""
        print(f"Uploading {local_dir} to gs://{self.bucket_name}/{gcs_prefix}")
        
        for root, _, files in os.walk(local_dir):
            for file in files:
                local_path = os.path.join(root, file)
                # Get the relative path from the local_dir
                rel_path = os.path.relpath(local_path, local_dir)
                gcs_path = f"{gcs_prefix}/{rel_path}"
                
                blob = self.bucket.blob(gcs_path)
                blob.upload_from_filename(local_path)
        
        print(f"Upload to gs://{self.bucket_name}/{gcs_prefix} complete")
        return f"gs://{self.bucket_name}/{gcs_prefix}"
    
    def upload_config(self):
        """Upload config file to GCS"""
        if not os.path.exists(self.config_path):
            print(f"Config file not found: {self.config_path}")
            self._create_default_config()
            
        gcs_config_path = f"config_{int(time.time())}.yaml"
        blob = self.bucket.blob(gcs_config_path)
        blob.upload_from_filename(self.config_path)
        return f"gs://{self.bucket_name}/{gcs_config_path}"
    
    def _create_default_config(self):
        """Create a default config file if none exists"""
        print("Creating default config file")
        default_config = """
training:
  epochs: 50
  batch_size: 32
  learning_rate: 0.001
  validation_split: 0.2
  sequence_length: 30
  num_landmarks: 33
  landmark_dims: 4
  model:
    lstm_units: [128, 64]
    dense_units: [32]
  classes:
    - squat
    - leg_raise
    - step_up
  metrics:
    - accuracy
    - precision
    - recall
    - f1
"""
        os.makedirs(os.path.dirname(self.config_path), exist_ok=True)
        with open(self.config_path, 'w') as f:
            f.write(default_config)
    
    def train_on_vertex(self, landmarks_gcs_path, config_gcs_path):
        """Train model on Vertex AI"""
        print("Setting up Vertex AI training job")
        
        # Create a unique job name
        job_name = f"physioflow_training_{int(time.time())}"
        
        # Define container args
        container_args = [
            f"--config={config_gcs_path}",
            f"--data-dir={landmarks_gcs_path}",
            f"--output-dir=gs://{self.bucket_name}/models"
        ]
        
        # Use correct Vertex AI container image
        custom_container_image = "us-docker.pkg.dev/vertex-ai/training/tf-gpu.2-12:latest"
        
        # Create Python package
        package_path = self._package_training_code()
        
        # Upload package to GCS
        package_gcs_path = self.upload_to_gcs(
            package_path, 
            f"code/physioflow_training_{int(time.time())}"
        )
        
        # Create and run the custom training job
        worker_pool_specs = [
            {
                "machine_spec": {
                    "machine_type": "n1-standard-8",
                    "accelerator_type": "NVIDIA_TESLA_T4",
                    "accelerator_count": 1,
                },
                "replica_count": 1,
                "python_package_spec": {
                    "executor_image_uri": custom_container_image,
                    "package_uris": [package_gcs_path],
                    "python_module": "trainer.task",
                    "args": container_args,
                },
            }
        ]
        
        try:
            job = aiplatform.CustomJob(
                display_name=job_name,
                worker_pool_specs=worker_pool_specs,
                staging_bucket=f"gs://{self.bucket_name}"
            )
            
            print(f"Starting Vertex AI training job: {job_name}")
            job.run()
            print("Training job completed successfully")
            
            # Get model artifacts
            model_dir = f"gs://{self.bucket_name}/models"
            print(f"Model artifacts available at: {model_dir}")
            return model_dir
            
        except Exception as e:
            print(f"Error training on Vertex AI: {str(e)}")
            # Try local training as fallback
            print("Attempting local training as fallback")
            return self._local_training_fallback(landmarks_gcs_path)
    
    def _package_training_code(self):
        """Package training code for Vertex AI"""
        print("Packaging training code")
        package_dir = os.path.join(self.local_data_dir, "trainer_package")
        os.makedirs(package_dir, exist_ok=True)
        
        # Create trainer module
        trainer_dir = os.path.join(package_dir, "trainer")
        os.makedirs(trainer_dir, exist_ok=True)
        
        # Create __init__.py
        with open(os.path.join(trainer_dir, "__init__.py"), "w") as f:
            f.write("# Trainer package\n")
        
        # Create setup.py
        with open(os.path.join(package_dir, "setup.py"), "w") as f:
            f.write("""
from setuptools import find_packages, setup

setup(
    name="trainer",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        "tensorflow==2.12.0",
        "pandas",
        "numpy",
        "pyyaml",
        "scikit-learn",
        "matplotlib"
    ]
)
""")
        
        # Copy task.py (main training script)
        shutil.copy2(
            os.path.join(os.path.dirname(__file__), "train_local.py"),
            os.path.join(trainer_dir, "task.py")
        )
        
        return package_dir
    
    def _local_training_fallback(self, landmarks_gcs_path):
        """Train model locally if Vertex AI fails"""
        print("Training model locally")
        
        # Download landmarks data from GCS
        local_landmarks_dir = os.path.join(self.local_data_dir, "landmarks_from_gcs")
        os.makedirs(local_landmarks_dir, exist_ok=True)
        
        # Strip the gs:// prefix and bucket name
        gcs_path = landmarks_gcs_path.replace(f"gs://{self.bucket_name}/", "")
        
        # Download files
        blobs = self.storage_client.list_blobs(self.bucket_name, prefix=gcs_path)
        for blob in blobs:
            # Get relative path
            rel_path = blob.name.replace(gcs_path, "").lstrip("/")
            if not rel_path:
                continue
                
            local_file = os.path.join(local_landmarks_dir, rel_path)
            os.makedirs(os.path.dirname(local_file), exist_ok=True)
            blob.download_to_filename(local_file)
        
        # Train model locally
        config = load_config(self.config_path)
        local_model_dir = os.path.join(self.local_data_dir, "models")
        os.makedirs(local_model_dir, exist_ok=True)
        
        tflite_path = train_model(config, local_model_dir)
        
        # Upload model back to GCS
        gcs_model_path = self.upload_to_gcs(local_model_dir, "models")
        return gcs_model_path
    
    def download_model(self, output_dir):
        """Download trained model from GCS"""
        print(f"Downloading trained model to {output_dir}")
        os.makedirs(output_dir, exist_ok=True)
        
        # List model files in GCS
        blobs = self.storage_client.list_blobs(self.bucket_name, prefix="models/")
        
        # Download TFLite model file
        for blob in blobs:
            if blob.name.endswith('.tflite'):
                local_path = os.path.join(output_dir, os.path.basename(blob.name))
                blob.download_to_filename(local_path)
                print(f"Downloaded model to {local_path}")
                return local_path
        
        print("No .tflite model file found in GCS bucket")
        return None
    
    def cleanup(self):
        """Clean up temporary files"""
        print("Cleaning up temporary files")
        shutil.rmtree(self.local_data_dir)
    
    def run_pipeline(self, search_term=None, max_videos=10, output_dir="ml/models", 
                target_specific_landmarks=True, local_video_dir=None):
        """Run the entire pipeline with optional local video source"""
        try:
            # Step 1: Collect videos (local or YouTube)
            video_dir = self.collect_videos(search_term, max_videos, local_video_dir)
            
            # Step 2: Upload videos to GCS
            videos_gcs_path = self.upload_to_gcs(video_dir, "data/videos")
            
            # Step 3: Process videos with Video Intelligence API, targeting knee and torso
            landmarks_dir = self.process_video_from_gcs(videos_gcs_path, target_specific_landmarks)
            
            # Step 4: Upload landmarks to GCS
            landmarks_gcs_path = self.upload_to_gcs(landmarks_dir, "data/landmarks")
            
            # Step 5: Upload config
            config_gcs_path = self.upload_config()
            
            # Step 6: Train on Vertex AI
            model_gcs_path = self.train_on_vertex(landmarks_gcs_path, config_gcs_path)
            
            # Step 7: Download model
            local_model_path = self.download_model(output_dir)
            
            print("\n" + "="*80)
            print(f"Pipeline completed successfully!")
            print(f"Model saved to: {local_model_path}")
            print("="*80 + "\n")
            
            return local_model_path
        except Exception as e:
            print(f"Error in pipeline: {str(e)}")
        finally:
            self.cleanup()

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description='PhysioFlow ML Pipeline on Vertex AI')
    parser.add_argument('--project-id', required=True, help='GCP Project ID')
    parser.add_argument('--region', default='us-central1', help='GCP Region')
    parser.add_argument('--bucket', required=True, help='GCS Bucket name')
    parser.add_argument('--config', default='ml/training/config.yaml', help='Config file path')
    parser.add_argument('--search', default='knee physiotherapy exercises', 
                       help='YouTube search term for training data')
    parser.add_argument('--max-videos', type=int, default=10, 
                       help='Maximum number of videos to download')
    parser.add_argument('--output-dir', default='ml/models', 
                       help='Local directory to save the model')
    parser.add_argument('--target-landmarks', action='store_true', default=True,
                      help='Target knee and torso landmarks for physiotherapy analysis')
    parser.add_argument('--local-videos', type=str, default=None,
                      help='Path to directory containing local video files (skips YouTube download)')
    
    args = parser.parse_args()
    
    # Create and run the pipeline
    pipeline = PhysioFlowMLPipeline(
        args.project_id, 
        args.region, 
        args.bucket, 
        args.config
    )
    
    pipeline.run_pipeline(
        args.search, 
        args.max_videos, 
        args.output_dir, 
        args.target_landmarks,
        args.local_videos
    )

if __name__ == "__main__":
    main()