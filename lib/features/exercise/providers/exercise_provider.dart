import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Exercise> _prescribedExercises = [];
  List<Exercise> _exercises = [];
  Map<String, List<Exercise>> _patientExercises = {};
  bool _isLoading = false;
  String? _error;

  List<Exercise> get prescribedExercises => _prescribedExercises;
  List<Exercise> get exercises => _exercises;
  Map<String, List<Exercise>> get patientExercises => _patientExercises;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> fetchPrescribedExercises(String patientId) async {
    try {
      final snapshot = await _firestore
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

  Future<void> loadExercises() async {
    _setLoading(true);
    try {
      final snapshot =
          await _firestore.collection('exercises').orderBy('name').get();

      _exercises = snapshot.docs
          .map((doc) => Exercise.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPatientExercises(String patientId) async {
    _setLoading(true);
    try {
      // First check if we have the base exercise library loaded
      if (_exercises.isEmpty) {
        await loadExercises();
      }

      // Get exercise assignments from the patient document
      final snapshot = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('assigned_exercises')
          .get();

      if (snapshot.docs.isEmpty) {
        // No exercises assigned yet
        _patientExercises[patientId] = [];
        notifyListeners();
        return;
      }

      // Convert assignment documents to a map of exercise IDs to prescription details
      final exerciseAssignments = <String, Map<String, dynamic>>{};
      for (var doc in snapshot.docs) {
        exerciseAssignments[doc.id] = doc.data();
      }

      // Find matching exercises from our main exercise library
      final assignedExercises = _exercises
          .where((exercise) => exerciseAssignments.containsKey(exercise.id))
          .map((exercise) {
        // You could enrich the exercise with assignment details here if needed
        return exercise;
      }).toList();

      // Store the patient's exercises
      _patientExercises[patientId] = assignedExercises;

      notifyListeners();
    } catch (e) {
      print('Error loading patient exercises: $e');
      _setError('Failed to load patient exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<Exercise> getPatientExercises(String patientId) {
    // Return the cached exercises for this patient, or an empty list if none found
    return _patientExercises[patientId] ?? [];
  }

  Future<void> assignExercisesToPatient(
      String patientId, List<Exercise> exercises) async {
    _setLoading(true);
    try {
      // Get reference to the patient document
      final patientDocRef = _firestore.collection('patients').doc(patientId);

      // Get reference to the patient's assigned_exercises subcollection
      final exercisesCollectionRef =
          patientDocRef.collection('assigned_exercises');

      // Get current assignments to determine what to add/remove
      final currentAssignments = await exercisesCollectionRef.get();

      // Create a batch to handle multiple operations efficiently
      final batch = _firestore.batch();

      // Step 1: Remove exercises that are no longer assigned
      for (final doc in currentAssignments.docs) {
        // Check if this exercise is not in the new list
        final exerciseId = doc.id;
        final stillAssigned = exercises.any((e) => e.id == exerciseId);

        if (!stillAssigned) {
          // This exercise is no longer assigned, delete it
          batch.delete(exercisesCollectionRef.doc(exerciseId));
        }
      }

      // Step 2: Add or update exercises
      for (final exercise in exercises) {
        // Default prescription values if not specified
        final prescription = exercise.defaultPrescription ??
            {
              'sets': 3,
              'reps': 10,
              'frequency': 'Daily',
            };

        // Add or update this exercise assignment
        batch.set(
          exercisesCollectionRef.doc(exercise.id),
          {
            'assignedAt': FieldValue.serverTimestamp(),
            ...prescription,
            'notes': '', // Optional notes for this patient's exercise
          },
          SetOptions(merge: true), // Update existing fields without overwriting
        );
      }

      // Execute all operations as a single transaction
      await batch.commit();

      // Update local cache of patient exercises
      _patientExercises[patientId] = List.from(exercises);

      notifyListeners();
    } catch (e) {
      print('Error assigning exercises: $e');
      _setError('Failed to assign exercises: $e');
      throw Exception('Failed to assign exercises: $e');
    } finally {
      _setLoading(false);
    }
  }
}
