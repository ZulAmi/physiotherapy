import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProgress {
  final String id;
  final String patientId;
  final String exerciseId;
  final DateTime timestamp;
  final double accuracy;
  final int duration;
  final int repetitions;
  final int sets;

  ExerciseProgress({
    required this.id,
    required this.patientId,
    required this.exerciseId,
    required this.timestamp,
    required this.accuracy,
    required this.duration,
    required this.repetitions,
    required this.sets,
  });

  factory ExerciseProgress.fromJson(Map<String, dynamic> json) {
    return ExerciseProgress(
      id: json['id'],
      patientId: json['patientId'],
      exerciseId: json['exerciseId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      accuracy: json['accuracy'],
      duration: json['duration'],
      repetitions: json['repetitions'],
      sets: json['sets'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'exerciseId': exerciseId,
      'timestamp': Timestamp.fromDate(timestamp),
      'accuracy': accuracy,
      'duration': duration,
      'repetitions': repetitions,
      'sets': sets,
    };
  }
}
