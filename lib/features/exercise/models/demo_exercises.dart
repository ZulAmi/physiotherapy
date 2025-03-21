import 'package:physioflow/features/exercise/models/exercise_model.dart';

class DemoExercise {
  static Exercise shoulderFlexion() {
    return Exercise(
      id: 'demo-shoulder-flexion',
      name: 'Shoulder Flexion',
      description:
          'Raise your arm forward and up until it points to the ceiling. Lower slowly.',
      imageUrl: 'assets/images/exercises/shoulder_flexion.png',
      videoUrl: 'assets/videos/shoulder_flexion.mp4',
      difficulty: 2, // Added required difficulty parameter
      category: ExerciseCategory.upper,
      targetMuscles: ['Deltoid', 'Rotator Cuff'],
      complexity: ExerciseComplexity.beginner,
      aiReferenceData: {
        'jointAngles': {
          'shoulderFlexion': 180.0,
          'shoulderAbduction': 0.0,
          'elbowFlexion': 0.0,
        },
        'keyFrames': [
          {
            'position': 'start',
            'jointAngles': {
              'shoulderFlexion': 0.0,
            }
          },
          {
            'position': 'top',
            'jointAngles': {
              'shoulderFlexion': 180.0,
            }
          }
        ],
      },
      defaultPrescription: ExercisePrescription(
        sets: 3,
        reps: 10,
        duration: const Duration(seconds: 0),
        notes: 'Perform slowly and with control',
      ),
    );
  }

  static Exercise kneeExtension() {
    return Exercise(
      id: 'demo-knee-extension',
      name: 'Seated Knee Extension',
      description:
          'Sit on a chair and extend your knee until your leg is straight, then lower slowly.',
      imageUrl: 'assets/images/exercises/knee_extension.png',
      videoUrl: '', // Empty string for missing video
      difficulty: 1, // Added required difficulty parameter
      category: ExerciseCategory.lowerBody, // Added required category parameter
      targetMuscles: ['Quadriceps'],
      complexity: ExerciseComplexity.beginner,
      aiReferenceData: null, // No AI data available
      defaultPrescription: ExercisePrescription(
        sets: 2,
        reps: 15,
        notes: 'Keep back straight against chair',
      ),
    );
  }
}
