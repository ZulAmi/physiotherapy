"""
Processes video frames to extract pose landmarks
"""
import cv2
import mediapipe as mp
import pandas as pd
import numpy as np
import os
import glob
from pathlib import Path
import argparse
import json

# Initialize MediaPipe Pose
mp_pose = mp.solutions.pose

def process_frames(folder_path, output_dir='ml/data/landmarks'):
    """Process all frames in a folder and extract pose landmarks"""
    print(f"Processing frames in {folder_path}...")
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Get folder name for output
    folder_name = os.path.basename(folder_path)
    output_file = os.path.join(output_dir, f"{folder_name}_landmarks.parquet")
    
    # Skip if already processed
    if os.path.exists(output_file):
        print(f"Output file {output_file} already exists. Skipping...")
        return
    
    # Initialize pose detector
    pose = mp_pose.Pose(static_image_mode=True, model_complexity=2)
    all_data = []
    
    # Get all jpg files in the folder
    image_files = sorted(glob.glob(os.path.join(folder_path, "*.jpg")))
    total_files = len(image_files)
    
    for i, img_path in enumerate(image_files):
        if i % 20 == 0:
            print(f"Processing frame {i+1}/{total_files}...")
            
        # Read image and process
        img = cv2.imread(img_path)
        if img is None:
            print(f"Failed to read image: {img_path}")
            continue
            
        # Convert to RGB and process
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        results = pose.process(img_rgb)
        
        if results.pose_landmarks:
            # Extract landmarks (x, y, z, visibility)
            landmarks = []
            for lm in results.pose_landmarks.landmark:
                landmarks.append([lm.x, lm.y, lm.z, lm.visibility])
            
            # Create entry with frame info and landmarks
            all_data.append({
                'frame': os.path.basename(img_path),
                'landmarks': landmarks,
                'frame_index': i
            })
    
    # Save as parquet if we have data
    if all_data:
        print(f"Saving landmarks data for {len(all_data)} frames...")
        df = pd.DataFrame(all_data)
        df.to_parquet(output_file)
        print(f"Saved to {output_file}")
    else:
        print("No landmarks detected in any frames")

def process_all_videos(input_dir='ml/data/frames', output_dir='ml/data/landmarks'):
    """Process all video folders"""
    # Get all directories in the input folder
    video_folders = [f for f in os.listdir(input_dir) if os.path.isdir(os.path.join(input_dir, f))]
    print(f"Found {len(video_folders)} video folders")
    
    for folder in video_folders:
        folder_path = os.path.join(input_dir, folder)
        process_frames(folder_path, output_dir)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Extract pose landmarks from video frames')
    parser.add_argument('--input-dir', type=str, default='ml/data/frames', 
                        help='Directory containing frame folders')
    parser.add_argument('--output-dir', type=str, default='ml/data/landmarks', 
                        help='Directory to save landmark data')
    args = parser.parse_args()
    
    process_all_videos(args.input_dir, args.output_dir)
    print("Pose processing complete!")