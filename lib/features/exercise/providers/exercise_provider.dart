import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Exercise> _prescribedExercises = [];

  List<Exercise> get prescribedExercises => _prescribedExercises;

  Future<void> fetchPrescribedExercises(String patientId) async {
    try {
      final snapshot =
          await _firestore
              .collection('patients')
              .doc(patientId)
              .collection('prescribed_exercises')
              .get();

      _prescribedExercises =
          snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }

  Future<void> prescribeExercise(String patientId, Exercise exercise) async {
    try {
      await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('prescribed_exercises')
          .doc(exercise.id)
          .set(exercise.toJson());

      _prescribedExercises.add(exercise);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to prescribe exercise: $e');
    }
  }
}
