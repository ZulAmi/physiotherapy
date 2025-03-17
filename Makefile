# GCP Training commands
GCP_PROJECT_ID=your-project-id
GCP_BUCKET=your-bucket-name
GCP_REGION=us-central1

setup-gcp:
    gcloud auth login
    gcloud config set project $(GCP_PROJECT_ID)
    gsutil mb -l $(GCP_REGION) gs://$(GCP_BUCKET)

upload-data:
    gsutil -m cp -r ml/data/landmarks gs://$(GCP_BUCKET)/data/

train-vertex:
    python ml/training/train_vertex.py --project-id=$(GCP_PROJECT_ID) --region=$(GCP_REGION) --bucket=$(GCP_BUCKET)

download-model:
    mkdir -p ml/models
    gsutil cp gs://$(GCP_BUCKET)/models/*.tflite ml/models/