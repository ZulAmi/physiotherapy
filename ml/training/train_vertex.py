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
from pathlib import Path
from google.cloud import storage, aiplatform
from google.cloud.storage import Blob

# Import from local modules
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from data_collection.video_collector import download_videos
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
        aiplatform.init(project=project_id, location=region)
    
    def collect_videos(self, search_term="knee physiotherapy exercises", max_videos=10):
        """Collect videos using video_collector module"""
        print(f"Collecting videos for: {search_term}")
        
        # Create subdirectory for videos
        video_dir = os.path.join(self.local_data_dir, "videos")
        os.makedirs(video_dir, exist_ok=True)
        
        # Use the downloaded module to get videos
        try:
            print(f"Downloading {max_videos} videos to {video_dir}")
            download_videos(search_term, max_videos, output_dir=video_dir)
            return video_dir
        except Exception as e:
            print(f"Error downloading videos: {str(e)}")
            # Provide a fallback if the import fails
            self._download_videos_fallback(search_term, max_videos, video_dir)
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
        
        # Create custom container for training
        custom_container_image = "gcr.io/cloud-aiplatform/training/tf-gpu.2-12:latest"
        
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
    
    def run_pipeline(self, search_term="knee physiotherapy exercises", max_videos=10, output_dir="ml/models"):
        """Run the entire pipeline"""
        try:
            # Step 1: Collect videos
            video_dir = self.collect_videos(search_term, max_videos)
            
            # Step 2: Process frames and extract landmarks
            landmarks_dir = self.process_video_frames(video_dir)
            
            # Step 3: Upload landmarks to GCS
            landmarks_gcs_path = self.upload_to_gcs(landmarks_dir, "data/landmarks")
            
            # Step 4: Upload config
            config_gcs_path = self.upload_config()
            
            # Step 5: Train on Vertex AI
            model_gcs_path = self.train_on_vertex(landmarks_gcs_path, config_gcs_path)
            
            # Step 6: Download model
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
    
    args = parser.parse_args()
    
    # Create and run the pipeline
    pipeline = PhysioFlowMLPipeline(
        args.project_id, 
        args.region, 
        args.bucket, 
        args.config
    )
    
    pipeline.run_pipeline(args.search, args.max_videos, args.output_dir)

if __name__ == "__main__":
    main()