enum ExerciseCategory {
  rehabilitation,
  lowerBody,
  upperBody,
  core,
  strength,
  flexibility,
  balance,
  endurance,
  coordination,
  mobility,
}

enum ExerciseComplexity { beginner, intermediate, advanced }

// Added for MediaPipe analysis
enum PoseJoint {
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
}

// Added for MediaPipe analysis
class JointAngleReference {
  final PoseJoint joint;
  final double minAngle;
  final double maxAngle;
  final String feedbackTooLow;
  final String feedbackTooHigh;
  final String feedbackCorrect;

  JointAngleReference({
    required this.joint,
    required this.minAngle,
    required this.maxAngle,
    this.feedbackTooLow = "Increase angle",
    this.feedbackTooHigh = "Decrease angle",
    this.feedbackCorrect = "Good form",
  });

  Map<String, dynamic> toJson() {
    return {
      'joint': joint.toString().split('.').last,
      'minAngle': minAngle,
      'maxAngle': maxAngle,
      'feedbackTooLow': feedbackTooLow,
      'feedbackTooHigh': feedbackTooHigh,
      'feedbackCorrect': feedbackCorrect,
    };
  }

  factory JointAngleReference.fromJson(Map<String, dynamic> json) {
    return JointAngleReference(
      joint: PoseJoint.values.firstWhere(
        (e) => e.toString().split('.').last == json['joint'],
        orElse: () => PoseJoint.leftKnee,
      ),
      minAngle: (json['minAngle'] as num).toDouble(),
      maxAngle: (json['maxAngle'] as num).toDouble(),
      feedbackTooLow: json['feedbackTooLow'] ?? "Increase angle",
      feedbackTooHigh: json['feedbackTooHigh'] ?? "Decrease angle",
      feedbackCorrect: json['feedbackCorrect'] ?? "Good form",
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final int difficulty;
  final ExerciseCategory category;
  final List<String> targetMuscles;
  final ExerciseComplexity complexity;

  // Updated to use MediaPipe reference data instead of AI
  final List<JointAngleReference>? jointAngles;

  final ExercisePrescription? defaultPrescription;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.videoUrl = '',
    required this.difficulty,
    required this.category,
    required this.targetMuscles,
    required this.complexity,
    this.jointAngles,
    this.defaultPrescription,
  });

  // Get feedback for a specific joint based on its current angle
  String getFeedbackForJoint(PoseJoint joint, double currentAngle) {
    if (jointAngles == null) return "No reference data available";

    final reference = jointAngles!.firstWhere(
      (ref) => ref.joint == joint,
      orElse: () => JointAngleReference(
        joint: joint,
        minAngle: 0,
        maxAngle: 180,
      ),
    );

    if (currentAngle < reference.minAngle) {
      return reference.feedbackTooLow;
    } else if (currentAngle > reference.maxAngle) {
      return reference.feedbackTooHigh;
    } else {
      return reference.feedbackCorrect;
    }
  }

  // Check if the current pose meets all angle requirements
  bool isCorrectPose(Map<PoseJoint, double> currentAngles) {
    if (jointAngles == null) return false;

    for (var reference in jointAngles!) {
      final currentAngle = currentAngles[reference.joint];
      if (currentAngle == null) continue;

      if (currentAngle < reference.minAngle ||
          currentAngle > reference.maxAngle) {
        return false;
      }
    }

    return true;
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<JointAngleReference>? jointAngles;
    if (json['jointAngles'] != null) {
      final List<dynamic> anglesList = json['jointAngles'] as List;
      jointAngles = anglesList
          .map((angle) =>
              JointAngleReference.fromJson(angle as Map<String, dynamic>))
          .toList();
    }

    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      videoUrl: json['videoUrl'] as String? ?? '',
      difficulty: json['difficulty'] as int? ?? 1,
      category: ExerciseCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => ExerciseCategory.rehabilitation,
      ),
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      complexity: ExerciseComplexity.values.firstWhere(
        (e) => e.toString().split('.').last == json['complexity'],
        orElse: () => ExerciseComplexity.beginner,
      ),
      jointAngles: jointAngles,
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
      'difficulty': difficulty,
      'category': category.toString().split('.').last,
      'targetMuscles': targetMuscles,
      'complexity': complexity.toString().split('.').last,
      'jointAngles': jointAngles?.map((angle) => angle.toJson()).toList(),
      'defaultPrescription': defaultPrescription?.toJson(),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? videoUrl,
    int? difficulty,
    ExerciseCategory? category,
    List<String>? targetMuscles,
    ExerciseComplexity? complexity,
    List<JointAngleReference>? jointAngles,
    ExercisePrescription? defaultPrescription,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      complexity: complexity ?? this.complexity,
      jointAngles: jointAngles ?? this.jointAngles,
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
    difficulty: 1,
    category: ExerciseCategory.rehabilitation,
    targetMuscles: ['shoulder'],
    complexity: ExerciseComplexity.beginner,
    jointAngles: [
      JointAngleReference(
        joint: PoseJoint.rightShoulder,
        minAngle: 150,
        maxAngle: 170,
        feedbackTooLow: "Raise your arm higher",
        feedbackTooHigh: "Lower your arm slightly",
        feedbackCorrect: "Good shoulder position",
      ),
    ],
    defaultPrescription: ExercisePrescription(sets: 3, reps: 10),
  ),
  Exercise(
    id: '2',
    name: 'Knee Extension',
    description: 'Straighten your knee while sitting',
    imageUrl: '',
    videoUrl: '',
    difficulty: 1,
    category: ExerciseCategory.rehabilitation,
    targetMuscles: ['knee'],
    complexity: ExerciseComplexity.beginner,
    jointAngles: [
      JointAngleReference(
        joint: PoseJoint.rightKnee,
        minAngle: 165,
        maxAngle: 175,
        feedbackTooLow: "Extend your knee more",
        feedbackTooHigh: "Don't hyperextend your knee",
        feedbackCorrect: "Good knee extension",
      ),
      JointAngleReference(
        joint: PoseJoint.rightHip,
        minAngle: 85,
        maxAngle: 95,
        feedbackTooLow: "Keep your back straighter",
        feedbackTooHigh: "Don't lean too far back",
        feedbackCorrect: "Good sitting posture",
      ),
    ],
    defaultPrescription: ExercisePrescription(sets: 3, reps: 10),
  ),
];
