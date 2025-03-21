import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../core/utils/vector_math.dart';

enum KneeExerciseType {
  squat,
  lunge,
  generic,
  // Add other exercise types as needed
}

class BiomechanicsService {
  // Calculate knee flexion angle using hip, knee and ankle landmarks
  double calculateKneeFlexionAngle(Pose pose, bool isRightLeg) {
    final hip = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightHip]
        : pose.landmarks[PoseLandmarkType.leftHip];

    final knee = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightKnee]
        : pose.landmarks[PoseLandmarkType.leftKnee];

    final ankle = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightAnkle]
        : pose.landmarks[PoseLandmarkType.leftAnkle];

    if (hip == null || knee == null || ankle == null) {
      return 0.0;
    }

    // Convert landmarks to 3D vectors
    final hipVector = Vector3D(hip.x, hip.y, hip.z);
    final kneeVector = Vector3D(knee.x, knee.y, knee.z);
    final ankleVector = Vector3D(ankle.x, ankle.y, ankle.z);

    // Calculate vectors from knee to hip and knee to ankle
    final kneeToHip = hipVector - kneeVector;
    final kneeToAnkle = ankleVector - kneeVector;

    // Calculate angle between these vectors
    final angle = kneeToHip.angleBetween(kneeToAnkle);

    // Convert to degrees and return 180 - angle to get the flexion angle
    return 180 - (angle * (180 / pi));
  }

  // Calculate knee valgus/varus angle
  double calculateKneeValgusAngle(Pose pose, bool isRightLeg) {
    final hip = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightHip]
        : pose.landmarks[PoseLandmarkType.leftHip];

    final knee = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightKnee]
        : pose.landmarks[PoseLandmarkType.leftKnee];

    final ankle = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightAnkle]
        : pose.landmarks[PoseLandmarkType.leftAnkle];

    if (hip == null || knee == null || ankle == null) {
      return 0.0;
    }

    // Create vectors in the frontal plane (ignoring depth)
    final Vector2D hipProjection = Vector2D(hip.x, hip.y);
    final Vector2D kneeProjection = Vector2D(knee.x, knee.y);
    final Vector2D ankleProjection = Vector2D(ankle.x, ankle.y);

    // Calculate direction vectors
    final hipToKnee = kneeProjection - hipProjection;
    final kneeToAnkle = ankleProjection - kneeProjection;

    // Calculate frontal plane angle
    final frontPlaneAngle = hipToKnee.angleBetween(kneeToAnkle);

    // Determine valgus (positive) or varus (negative)
    // This is simplified - a more accurate method would account for anatomical alignment
    final isValgus = isRightLeg
        ? kneeProjection.x > hipProjection.x
        : kneeProjection.x < hipProjection.x;

    return isValgus ? frontPlaneAngle : -frontPlaneAngle;
  }

  // Calculate Q-angle (quadriceps angle)
  double calculateQAngle(Pose pose, bool isRightLeg) {
    final asis = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightHip]
        : pose.landmarks[PoseLandmarkType.leftHip];

    final patella = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightKnee]
        : pose.landmarks[PoseLandmarkType.leftKnee];

    final tibialTuberosity = isRightLeg
        ? pose.landmarks[PoseLandmarkType.rightAnkle] // Approximation
        : pose.landmarks[PoseLandmarkType.leftAnkle]; // Approximation

    if (asis == null || patella == null || tibialTuberosity == null) {
      return 0.0;
    }

    // Calculate vectors
    final Vector2D asisToPatella =
        Vector2D(patella.x - asis.x, patella.y - asis.y);

    final Vector2D tibialToPatella = Vector2D(
        patella.x - tibialTuberosity.x, patella.y - tibialTuberosity.y);

    // Q-angle is the angle between these vectors
    return asisToPatella.angleBetween(tibialToPatella) * (180 / pi);
  }

  // Calculate exercise quality based on biomechanical parameters
  int calculateExerciseQuality(KneeExerciseType exerciseType,
      double flexionAngle, double valgusAngle, double qAngle) {
    // Base score
    int score = 100;

    // Penalize based on exercise-specific criteria
    switch (exerciseType) {
      case KneeExerciseType.squat:
        // Penalize for insufficient depth
        if (flexionAngle < 90) {
          score -= ((90 - flexionAngle) / 90 * 30).round();
        }

        // Penalize for excessive valgus
        final valgusAbsolute = valgusAngle.abs();
        if (valgusAbsolute > 10) {
          score -= ((valgusAbsolute - 10) * 3).round();
        }

        // Penalize for abnormal Q-angle
        if (qAngle < 12 || qAngle > 20) {
          score -= ((qAngle < 12 ? 12 - qAngle : qAngle - 20) * 2).round();
        }
        break;

      case KneeExerciseType.lunge:
        // Penalize for insufficient flexion
        if (flexionAngle < 85) {
          score -= ((85 - flexionAngle) / 85 * 30).round();
        }

        // Penalize for excessive valgus/varus
        score -= (valgusAngle.abs() * 3).round();
        break;

      // Add criteria for other exercise types
      default:
        // Generic criteria for other exercises
        if (flexionAngle < 45) {
          score -= ((45 - flexionAngle) / 45 * 20).round();
        }
        score -= (valgusAngle.abs() * 2).round();
    }

    // Ensure score is between 0 and 100
    return score.clamp(0, 100);
  }
}
