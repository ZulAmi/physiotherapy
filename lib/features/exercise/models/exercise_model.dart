import 'package:cloud_firestore/cloud_firestore.dart';

enum ExerciseCategory {
  strength,
  flexibility,
  balance,
  endurance,
  coordination,
  mobility,
  rehabilitation
}

enum ExerciseComplexity { beginner, intermediate, advanced }

class Exercise {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final List<String> targetMuscles;
  final ExerciseComplexity complexity;
  final Map<String, dynamic>? aiReferenceData;
  final ExercisePrescription? defaultPrescription;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.videoUrl = '',
    required this.targetMuscles,
    required this.complexity,
    this.aiReferenceData,
    this.defaultPrescription,
  });

  // Add methods to access AI reference data
  Map<String, double> getReferenceAngles() {
    final Map<String, double> angles = {};

    if (aiReferenceData != null && aiReferenceData!['jointAngles'] != null) {
      final jointAngles =
          aiReferenceData!['jointAngles'] as Map<String, dynamic>;
      jointAngles.forEach((key, value) {
        angles[key] = (value as num).toDouble();
      });
    }

    return angles;
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      videoUrl: json['videoUrl'] as String? ?? '',
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      complexity: ExerciseComplexity.values.firstWhere(
        (e) => e.toString().split('.').last == json['complexity'],
        orElse: () => ExerciseComplexity.beginner,
      ),
      aiReferenceData: json['aiReferenceData'] as Map<String, dynamic>?,
      defaultPrescription: json['defaultPrescription'] != null
          ? ExercisePrescription.fromJson(
              json['defaultPrescription'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'targetMuscles': targetMuscles,
      'complexity': complexity.toString().split('.').last,
      'aiReferenceData': aiReferenceData,
      'defaultPrescription': defaultPrescription?.toJson(),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? videoUrl,
    List<String>? targetMuscles,
    ExerciseComplexity? complexity,
    Map<String, dynamic>? aiReferenceData,
    ExercisePrescription? defaultPrescription,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      complexity: complexity ?? this.complexity,
      aiReferenceData: aiReferenceData ?? this.aiReferenceData,
      defaultPrescription: defaultPrescription ?? this.defaultPrescription,
    );
  }
}

class ExercisePrescription {
  final int sets;
  final int reps;
  final Duration duration;
  final String notes;

  ExercisePrescription({
    this.sets = 3,
    this.reps = 10,
    this.duration = const Duration(seconds: 0),
    this.notes = '',
  });

  factory ExercisePrescription.fromJson(Map<String, dynamic> json) {
    return ExercisePrescription(
      sets: json['sets'] as int? ?? 3,
      reps: json['reps'] as int? ?? 10,
      duration: Duration(seconds: json['duration'] as int? ?? 0),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sets': sets,
      'reps': reps,
      'duration': duration.inSeconds,
      'notes': notes,
    };
  }
}

final List<Exercise> dummyExercises = [
  Exercise(
    id: '1',
    name: 'Shoulder Flexion',
    description: 'Raise your arm forward and upward',
    imageUrl: '',
    videoUrl: '',
    targetMuscles: ['shoulder'],
    complexity: ExerciseComplexity.beginner,
    aiReferenceData: null,
    defaultPrescription: ExercisePrescription(sets: 3, reps: 10),
  ),
  Exercise(
    id: '2',
    name: 'Knee Extension',
    description: 'Straighten your knee while sitting',
    imageUrl: '',
    videoUrl: '',
    targetMuscles: ['knee'],
    complexity: ExerciseComplexity.beginner,
    aiReferenceData: null,
    defaultPrescription: ExercisePrescription(sets: 3, reps: 10),
  ),
];
