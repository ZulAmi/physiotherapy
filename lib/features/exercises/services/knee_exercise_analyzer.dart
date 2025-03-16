import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/knee_biomechanics.dart';
import '../models/knee_exercise_type.dart';
import '../../../core/services/biomechanics_service.dart';

class KneeExerciseAnalyzer {
  final BiomechanicsService _biomechanicsService = BiomechanicsService();

  // Analyze a single frame of exercise
  KneeBiomechanics analyzeFrame(
      Pose pose, KneeExerciseType exerciseType, bool isRightLeg) {
    // Calculate key biomechanical parameters
    final flexionAngle =
        _biomechanicsService.calculateKneeFlexionAngle(pose, isRightLeg);
    final valgusAngle =
        _biomechanicsService.calculateKneeValgusAngle(pose, isRightLeg);
    final qAngle = _biomechanicsService.calculateQAngle(pose, isRightLeg);

    // Estimate weight distribution (simplified)
    // For a more accurate measure, would need force plates or pressure sensors
    double weightDistribution = 0.5; // Default to even distribution

    // Simplified patellar tracking estimate based on Q-angle
    // In practice, this would require more sophisticated tracking
    double patellarTracking = qAngle >= 10 && qAngle <= 20 ? 1.0 : 0.7;

    // Angular velocity would require comparing with previous frames
    // Here we're using a placeholder value
    const double angularVelocity = 0.0;

    // Calculate overall quality score
    final qualityScore = _biomechanicsService.calculateExerciseQuality(
        exerciseType, flexionAngle, valgusAngle, qAngle);

    return KneeBiomechanics(
      flexionAngle: flexionAngle,
      valgusAngle: valgusAngle,
      weightDistribution: weightDistribution,
      qAngle: qAngle,
      patellarTracking: patellarTracking,
      angularVelocity: angularVelocity,
      qualityScore: qualityScore,
    );
  }

  // Analyze a sequence of frames to track motion
  List<KneeBiomechanics> analyzeSequence(
      List<Pose> poseSequence, KneeExerciseType exerciseType, bool isRightLeg) {
    List<KneeBiomechanics> results = [];

    for (int i = 0; i < poseSequence.length; i++) {
      // Analyze current frame
      final biomechanics =
          analyzeFrame(poseSequence[i], exerciseType, isRightLeg);

      // If not the first frame, calculate angular velocity
      if (i > 0) {
        final prevBiomechanics = results[i - 1];
        final timeDelta = 1 / 30; // Assuming 30 FPS

        // Update angular velocity based on change in flexion angle
        final angularVelocity =
            (biomechanics.flexionAngle - prevBiomechanics.flexionAngle) /
                timeDelta;

        // Create updated biomechanics with angular velocity
        results.add(KneeBiomechanics(
          flexionAngle: biomechanics.flexionAngle,
          valgusAngle: biomechanics.valgusAngle,
          weightDistribution: biomechanics.weightDistribution,
          qAngle: biomechanics.qAngle,
          patellarTracking: biomechanics.patellarTracking,
          angularVelocity: angularVelocity,
          qualityScore: biomechanics.qualityScore,
        ));
      } else {
        results.add(biomechanics);
      }
    }

    return results;
  }

  // Provide feedback based on biomechanical analysis
  List<String> generateFeedback(List<KneeBiomechanics> biomechanicsSequence,
      KneeExerciseType exerciseType) {
    List<String> feedback = [];

    // Only analyze if we have data
    if (biomechanicsSequence.isEmpty) {
      return ['No data available for analysis'];
    }

    // Calculate averages
    double avgFlexionAngle = 0;
    double avgValgusAngle = 0;
    double avgQAngle = 0;
    int avgQualityScore = 0;

    for (var b in biomechanicsSequence) {
      avgFlexionAngle += b.flexionAngle;
      avgValgusAngle += b.valgusAngle.abs(); // Use absolute value for valgus
      avgQAngle += b.qAngle;
      avgQualityScore += b.qualityScore;
    }

    avgFlexionAngle /= biomechanicsSequence.length;
    avgValgusAngle /= biomechanicsSequence.length;
    avgQAngle /= biomechanicsSequence.length;
    avgQualityScore = (avgQualityScore / biomechanicsSequence.length).round();

    // Generate exercise-specific feedback
    switch (exerciseType) {
      case KneeExerciseType.squat:
        if (avgFlexionAngle < 90) {
          feedback.add(
              'Try to squat deeper, aiming for at least 90 degrees of knee flexion');
        }

        if (avgValgusAngle > 10) {
          feedback.add(
              'Keep your knees aligned with your toes to prevent knee valgus (knees caving inward)');
        }

        if (avgQualityScore < 70) {
          feedback
              .add('Focus on maintaining proper form throughout the exercise');
        }
        break;

      case KneeExerciseType.lunge:
        if (avgFlexionAngle < 85) {
          feedback.add('Bend your knee more deeply in the lunge position');
        }

        if (avgValgusAngle > 5) {
          feedback.add('Keep your front knee tracking over your second toe');
        }

        if (avgQualityScore < 70) {
          feedback.add(
              'Maintain proper balance and control throughout the movement');
        }
        break;

      // Add more exercise-specific feedback
      default:
        if (avgQualityScore < 70) {
          feedback
              .add('Focus on maintaining proper form throughout the exercise');
        }
    }

    // Add general feedback
    if (biomechanicsSequence.any((b) => b.angularVelocity > 100)) {
      feedback.add('Move more slowly and controlled through the exercise');
    }

    // If everything looks good
    if (feedback.isEmpty) {
      feedback.add('Great job! Your form looks excellent.');
    }

    return feedback;
  }
}
