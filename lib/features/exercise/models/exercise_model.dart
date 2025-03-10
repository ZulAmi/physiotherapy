class Exercise {
  final String id;
  final String name;
  final String description;
  final List<String> steps;
  final String targetPose;
  final int setsPerDay;
  final int repetitionsPerSet;
  final DateTime prescribedDate;
  final DateTime? endDate;
  final String prescribedBy;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.targetPose,
    required this.setsPerDay,
    required this.repetitionsPerSet,
    required this.prescribedDate,
    this.endDate,
    required this.prescribedBy,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      steps: List<String>.from(json['steps']),
      targetPose: json['targetPose'],
      setsPerDay: json['setsPerDay'],
      repetitionsPerSet: json['repetitionsPerSet'],
      prescribedDate: DateTime.parse(json['prescribedDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      prescribedBy: json['prescribedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'steps': steps,
      'targetPose': targetPose,
      'setsPerDay': setsPerDay,
      'repetitionsPerSet': repetitionsPerSet,
      'prescribedDate': prescribedDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'prescribedBy': prescribedBy,
    };
  }
}

final List<Exercise> dummyExercises = [
  Exercise(
    id: '1',
    name: 'Shoulder Flexion',
    description: 'Raise your arm forward and upward',
    steps: [
      'Stand straight with your arms at your sides',
      'Slowly raise your arm forward and up',
      'Hold for 5 seconds',
      'Lower your arm back down',
    ],
    targetPose: 'shoulder_flexion',
    setsPerDay: 3,
    repetitionsPerSet: 10,
    prescribedDate: DateTime.now(),
    endDate: null,
    prescribedBy: 'Dr. Smith',
  ),
  Exercise(
    id: '2',
    name: 'Knee Extension',
    description: 'Straighten your knee while sitting',
    steps: [
      'Sit on a chair with feet flat on the ground',
      'Slowly straighten one knee',
      'Hold for 5 seconds',
      'Lower your leg back down',
    ],
    targetPose: 'knee_extension',
    setsPerDay: 3,
    repetitionsPerSet: 10,
    prescribedDate: DateTime.now(),
    endDate: null,
    prescribedBy: 'Dr. Smith',
  ),
];
