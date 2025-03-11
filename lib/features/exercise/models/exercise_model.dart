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

class Exercise {
  final String id;
  final String name;
  final String description;
  final ExerciseCategory category;
  final int difficulty; // 1-5 scale
  final String? imageUrl;
  final String? videoUrl;
  final List<String> targetMuscles;
  final List<String> equipment;
  final Map<String, dynamic>? defaultPrescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    this.imageUrl,
    this.videoUrl,
    required this.targetMuscles,
    required this.equipment,
    this.defaultPrescription,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: _parseCategory(json['category'] as String),
      difficulty: json['difficulty'] as int,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
      defaultPrescription: json['defaultPrescription'] as Map<String, dynamic>?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category.toString().split('.').last,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'targetMuscles': targetMuscles,
      'equipment': equipment,
      'defaultPrescription': defaultPrescription,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static ExerciseCategory _parseCategory(String category) {
    return ExerciseCategory.values.firstWhere(
      (e) =>
          e.toString().split('.').last.toLowerCase() == category.toLowerCase(),
      orElse: () => ExerciseCategory.rehabilitation,
    );
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    ExerciseCategory? category,
    int? difficulty,
    String? imageUrl,
    String? videoUrl,
    List<String>? targetMuscles,
    List<String>? equipment,
    Map<String, dynamic>? defaultPrescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      equipment: equipment ?? this.equipment,
      defaultPrescription: defaultPrescription ?? this.defaultPrescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

final List<Exercise> dummyExercises = [
  Exercise(
    id: '1',
    name: 'Shoulder Flexion',
    description: 'Raise your arm forward and upward',
    category: ExerciseCategory.flexibility,
    difficulty: 2,
    imageUrl: null,
    videoUrl: null,
    targetMuscles: ['shoulder'],
    equipment: ['none'],
    defaultPrescription: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Exercise(
    id: '2',
    name: 'Knee Extension',
    description: 'Straighten your knee while sitting',
    category: ExerciseCategory.mobility,
    difficulty: 2,
    imageUrl: null,
    videoUrl: null,
    targetMuscles: ['knee'],
    equipment: ['none'],
    defaultPrescription: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
