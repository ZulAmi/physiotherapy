"""
Trains a model on the preprocessed landmark data
"""
import tensorflow as tf
from tensorflow.keras import layers, models
import numpy as np
import pandas as pd
import os
import glob
import yaml
import json
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from datetime import datetime
import argparse

def load_config(config_path='ml/training/config.yaml'):
    """Load training configuration"""
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    return config['training']

def build_model(config):
    """Build the LSTM model for pose sequence classification"""
    input_shape = (config['sequence_length'], config['num_landmarks'] * config['landmark_dims'])
    num_classes = len(config['classes'])
    
    model = models.Sequential([
        layers.Input(shape=input_shape),
        layers.LSTM(config['model']['lstm_units'][0], return_sequences=True),
        layers.Dropout(0.3),
        layers.LSTM(config['model']['lstm_units'][1]),
        layers.Dropout(0.3)
    ])
    
    # Add dense layers
    for units in config['model']['dense_units']:
        model.add(layers.Dense(units, activation='relu'))
        model.add(layers.Dropout(0.2))
    
    # Output layer
    model.add(layers.Dense(num_classes, activation='softmax'))
    
    # Compile model
    model.compile(
        optimizer=tf.keras.optimizers.Adam(config['learning_rate']),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )
    
    return model

def load_and_prepare_data(config, landmarks_dir='ml/data/landmarks'):
    """Load landmark data and prepare for training"""
    print("Loading landmark data...")
    
    # Get all parquet files
    parquet_files = glob.glob(os.path.join(landmarks_dir, "*.parquet"))
    
    if not parquet_files:
        raise ValueError(f"No parquet files found in {landmarks_dir}")
    
    # Load and process all files
    sequences = []
    labels = []
    
    for parquet_file in parquet_files:
        df = pd.read_parquet(parquet_file)
        
        # Get video metadata to determine class
        video_id = os.path.basename(parquet_file).split('_landmarks')[0]
        meta_file = os.path.join('ml/data/videos', f"video_{video_id}_meta.json")
        
        # Default to squat if metadata not found
        exercise_type = "squat"
        
        if os.path.exists(meta_file):
            with open(meta_file, 'r') as f:
                meta = json.load(f)
                # Analyze title to determine class
                title = meta['title'].lower()
                
                if 'squat' in title:
                    exercise_type = "squat"
                elif 'leg raise' in title or 'straight leg' in title:
                    exercise_type = "leg_raise"
                elif 'step up' in title or 'step-up' in title:
                    exercise_type = "step_up"
        
        # Create sequences from the landmarks
        frames = df.sort_values('frame_index')
        landmark_data = np.array([np.array(x) for x in frames['landmarks']])
        
        # Create sequences with sliding window
        seq_length = config['sequence_length']
        for i in range(0, len(landmark_data) - seq_length + 1, seq_length // 2):  # 50% overlap
            seq = landmark_data[i:i+seq_length]
            if len(seq) == seq_length:
                # Flatten landmarks for each frame in sequence
                flattened_seq = seq.reshape(seq_length, -1)
                sequences.append(flattened_seq)
                labels.append(exercise_type)
    
    # Convert to numpy arrays
    X = np.array(sequences)
    
    # Convert string labels to one-hot
    label_dict = {label: i for i, label in enumerate(config['classes'])}
    y_indices = [label_dict.get(label, 0) for label in labels]
    y = tf.keras.utils.to_categorical(y_indices, num_classes=len(config['classes']))
    
    print(f"Loaded {len(X)} sequences with shape {X.shape}")
    
    # Split data
    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=config['validation_split'], random_state=42
    )
    
    return X_train, X_val, y_train, y_val, label_dict

def train_model(config, output_dir='ml/models'):
    """Train the model and save it"""
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Load and prepare data
    X_train, X_val, y_train, y_val, label_dict = load_and_prepare_data(config)
    
    # Build model
    model = build_model(config)
    model.summary()
    
    # Create timestamp for model versioning
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Create callbacks
    callbacks = [
        tf.keras.callbacks.ModelCheckpoint(
            filepath=os.path.join(output_dir, f"knee_exercise_model_{timestamp}.h5"),
            save_best_only=True,
            monitor='val_accuracy'
        ),
        tf.keras.callbacks.EarlyStopping(
            patience=10,
            monitor='val_accuracy'
        ),
        tf.keras.callbacks.TensorBoard(
            log_dir=os.path.join(output_dir, 'logs', timestamp)
        )
    ]
    
    # Train model
    history = model.fit(
        X_train, y_train,
        validation_data=(X_val, y_val),
        epochs=config['epochs'],
        batch_size=config['batch_size'],
        callbacks=callbacks
    )
    
    # Save final model
    model_path = os.path.join(output_dir, f"knee_exercise_model_{timestamp}.h5")
    model.save(model_path)
    
    # Save label mapping
    label_map = {i: label for label, i in label_dict.items()}
    with open(os.path.join(output_dir, f"label_map_{timestamp}.json"), 'w') as f:
        json.dump(label_map, f, indent=2)
    
    # Convert to TFLite for Flutter
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()
    
    # Save TFLite model
    tflite_path = os.path.join(output_dir, f"knee_exercise_model_{timestamp}.tflite")
    with open(tflite_path, 'wb') as f:
        f.write(tflite_model)
    
    print(f"Model saved to {model_path}")
    print(f"TFLite model saved to {tflite_path}")
    
    # Plot training history
    plt.figure(figsize=(12, 4))
    
    plt.subplot(1, 2, 1)
    plt.plot(history.history['accuracy'])
    plt.plot(history.history['val_accuracy'])
    plt.title('Model accuracy')
    plt.ylabel('Accuracy')
    plt.xlabel('Epoch')
    plt.legend(['Train', 'Validation'], loc='upper left')
    
    plt.subplot(1, 2, 2)
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('Model loss')
    plt.ylabel('Loss')
    plt.xlabel('Epoch')
    plt.legend(['Train', 'Validation'], loc='upper left')
    
    plot_path = os.path.join(output_dir, f"training_history_{timestamp}.png")
    plt.savefig(plot_path)
    plt.close()
    
    print(f"Training plot saved to {plot_path}")
    return tflite_path

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Train knee exercise model')
    parser.add_argument('--config', type=str, default='ml/training/config.yaml',
                        help='Path to configuration YAML file')
    parser.add_argument('--output-dir', type=str, default='ml/models',
                        help='Directory to save trained model')
    args = parser.parse_args()
    
    # Load config
    config = load_config(args.config)
    
    # Train model
    train_model(config, args.output_dir)