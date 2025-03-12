import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Patient> _patients = [];
  Patient? _selectedPatient;
  bool _isLoading = false;

  List<Patient> get patients => _patients;
  Patient? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;

  Future<void> loadPatients(String therapistId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('patients')
          .where('therapistId', isEqualTo: therapistId)
          .orderBy('name')
          .get();

      _patients = snapshot.docs
          .map((doc) => Patient.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error loading patients: $e');
      _patients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      _isLoading = true;
      notifyListeners();

      final docRef =
          await _firestore.collection('patients').add(patient.toJson());

      final newPatient = patient.copyWith(id: docRef.id);
      _patients.add(newPatient);
      _patients.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      debugPrint('Error adding patient: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePatient(Patient patient) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('patients')
          .doc(patient.id)
          .update(patient.toJson());

      final index = _patients.indexWhere((p) => p.id == patient.id);
      if (index != -1) {
        _patients[index] = patient;
        if (_selectedPatient?.id == patient.id) {
          _selectedPatient = patient;
        }
      }
    } catch (e) {
      debugPrint('Error updating patient: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('patients').doc(patientId).delete();

      _patients.removeWhere((patient) => patient.id == patientId);
      if (_selectedPatient?.id == patientId) {
        _selectedPatient = null;
      }
    } catch (e) {
      debugPrint('Error deleting patient: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectPatient(String patientId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final doc = await _firestore.collection('patients').doc(patientId).get();

      if (doc.exists) {
        _selectedPatient = Patient.fromJson({...doc.data()!, 'id': doc.id});
      } else {
        _selectedPatient = null;
      }
    } catch (e) {
      debugPrint('Error selecting patient: $e');
      _selectedPatient = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Patient>> watchPatients(String therapistId) {
    return _firestore
        .collection('patients')
        .where('therapistId', isEqualTo: therapistId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Patient.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<List<Patient>> searchPatients(String query) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return snapshot.docs
          .map((doc) => Patient.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error searching patients: $e');
      return [];
    }
  }
}
