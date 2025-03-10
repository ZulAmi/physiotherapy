import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_progress.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveProgress(ExerciseProgress progress) async {
    await _firestore
        .collection('patients')
        .doc(progress.patientId)
        .collection('progress')
        .add(progress.toJson());
  }

  Stream<List<ExerciseProgress>> getPatientProgress(String patientId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('progress')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExerciseProgress.fromJson(doc.data()))
            .toList());
  }

  Future<Map<String, dynamic>> getProgressSummary(String patientId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('progress')
        .where('timestamp',
            isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
        .get();

    int totalExercises = snapshot.docs.length;
    double averageAccuracy = 0;
    int totalDuration = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      averageAccuracy += data['accuracy'] as double;
      totalDuration += data['duration'] as int;
    }

    return {
      'totalExercises': totalExercises,
      'averageAccuracy':
          totalExercises > 0 ? averageAccuracy / totalExercises : 0,
      'totalDuration': totalDuration,
    };
  }

  Stream<QuerySnapshot> getExerciseProgress(
      String patientId, String exerciseId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('exercises')
        .doc(exerciseId)
        .collection('progress')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> saveExerciseProgress({
    required String patientId,
    required String exerciseId,
    required double accuracy,
    required int duration,
    required int repetitions,
    required int sets,
  }) async {
    final progress = {
      'timestamp': FieldValue.serverTimestamp(),
      'accuracy': accuracy,
      'duration': duration,
      'repetitions': repetitions,
      'sets': sets,
    };

    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('exercises')
        .doc(exerciseId)
        .collection('progress')
        .add(progress);
  }
}
