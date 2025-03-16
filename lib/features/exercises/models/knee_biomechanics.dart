import 'package:flutter/foundation.dart';

class KneeBiomechanics {
  // Knee flexion angle (degrees)
  final double flexionAngle;

  // Knee valgus/varus angle (+ for valgus, - for varus)
  final double valgusAngle;

  // Weight distribution (percentage on affected leg)
  final double weightDistribution;

  // Q-angle (alignment of hip-knee-ankle)
  final double qAngle;

  // Patellar tracking (normalized value 0-1, 1 is optimal)
  final double patellarTracking;

  // Movement speed (degrees per second)
  final double angularVelocity;

  // Exercise quality score (0-100)
  final int qualityScore;

  const KneeBiomechanics({
    required this.flexionAngle,
    required this.valgusAngle,
    required this.weightDistribution,
    required this.qAngle,
    required this.patellarTracking,
    required this.angularVelocity,
    required this.qualityScore,
  });

  factory KneeBiomechanics.fromMap(Map<String, dynamic> map) {
    return KneeBiomechanics(
      flexionAngle: map['flexionAngle']?.toDouble() ?? 0.0,
      valgusAngle: map['valgusAngle']?.toDouble() ?? 0.0,
      weightDistribution: map['weightDistribution']?.toDouble() ?? 0.0,
      qAngle: map['qAngle']?.toDouble() ?? 0.0,
      patellarTracking: map['patellarTracking']?.toDouble() ?? 0.0,
      angularVelocity: map['angularVelocity']?.toDouble() ?? 0.0,
      qualityScore: map['qualityScore']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'flexionAngle': flexionAngle,
      'valgusAngle': valgusAngle,
      'weightDistribution': weightDistribution,
      'qAngle': qAngle,
      'patellarTracking': patellarTracking,
      'angularVelocity': angularVelocity,
      'qualityScore': qualityScore,
    };
  }
}
