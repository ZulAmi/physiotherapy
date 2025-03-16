enum KneeExerciseType {
  squat,
  lunge,
  legExtension,
  legCurl,
  stepUp,
  straightLegRaise,
  wallSlide,
  terminialKneeExtension,
  balanceBoard,
  kneeFlexion,
}

extension KneeExerciseTypeExtension on KneeExerciseType {
  String get displayName {
    switch (this) {
      case KneeExerciseType.squat:
        return 'Squat';
      case KneeExerciseType.lunge:
        return 'Lunge';
      case KneeExerciseType.legExtension:
        return 'Leg Extension';
      case KneeExerciseType.legCurl:
        return 'Leg Curl';
      case KneeExerciseType.stepUp:
        return 'Step Up';
      case KneeExerciseType.straightLegRaise:
        return 'Straight Leg Raise';
      case KneeExerciseType.wallSlide:
        return 'Wall Slide';
      case KneeExerciseType.terminialKneeExtension:
        return 'Terminal Knee Extension';
      case KneeExerciseType.balanceBoard:
        return 'Balance Board';
      case KneeExerciseType.kneeFlexion:
        return 'Knee Flexion';
    }
  }

  String get description {
    switch (this) {
      case KneeExerciseType.squat:
        return 'Builds quadriceps and overall knee stability';
      case KneeExerciseType.lunge:
        return 'Strengthens quadriceps and improves knee tracking';
      case KneeExerciseType.legExtension:
        return 'Isolates and strengthens the quadriceps';
      // Add descriptions for other exercises
      default:
        return 'Knee rehabilitation exercise';
    }
  }

  List<String> get keyPoints {
    switch (this) {
      case KneeExerciseType.squat:
        return [
          'Keep knees aligned with toes',
          'Don\'t let knees go past toes',
          'Maintain neutral spine',
          'Distribute weight through heels',
        ];
      // Add key points for other exercises
      default:
        return ['Maintain proper form', 'Move slowly and controlled'];
    }
  }
}
