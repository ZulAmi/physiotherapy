"""
Trains the PhysioFlow model on Vertex AI
"""
import os
import argparse
from google.cloud import aiplatform
from train_local import load_config, build_model, load_and_prepare_data, train_model

def train_on_vertex(project_id, region, bucket_name, config_path='ml/training/config.yaml'):
    """Train model on Vertex AI"""
    # Initialize Vertex AI
    aiplatform.init(project=project_id, location=region)
    
    # Load your config
    config = load_config(config_path)
    
    # Create a unique job name
    job_name = f"physioflow_training_{os.path.basename(config_path).split('.')[0]}"
    
    # Define container args (command line parameters for your training script)
    container_args = [
        f"--config=gs://{bucket_name}/config.yaml",
        f"--output-dir=gs://{bucket_name}/models"
    ]
    
    # Create and run the custom training job
    job = aiplatform.CustomTrainingJob(
        display_name=job_name,
        script_path="ml/training/train_local.py",
        container_uri="gcr.io/cloud-aiplatform/training/tf-gpu.2-9:latest",
        requirements=["tensorflow==2.9.0", "pandas", "numpy", "pyyaml", "scikit-learn", "matplotlib"],
    )
    
    # Run the job and wait for completion
    model = job.run(
        args=container_args,
        replica_count=1,
        machine_type="n1-standard-8",
        accelerator_type="NVIDIA_TESLA_T4",
        accelerator_count=1
    )
    
    print(f"Training completed. Model: {model}")
    return model

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Train model on Vertex AI')
    parser.add_argument('--project-id', required=True, help='GCP Project ID')
    parser.add_argument('--region', default='us-central1', help='GCP Region')
    parser.add_argument('--bucket', required=True, help='GCS Bucket name')
    parser.add_argument('--config', default='ml/training/config.yaml', help='Config file path')
    
    args = parser.parse_args()
    train_on_vertex(args.project_id, args.region, args.bucket, args.config)