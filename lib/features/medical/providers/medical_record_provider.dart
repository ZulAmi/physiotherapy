import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medical_record_model.dart';

class MedicalRecordProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MedicalRecord> _records = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<MedicalRecord> get records => _records;

  Future<void> loadPatientRecords(String patientId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('medical_records')
          .where('patientId', isEqualTo: patientId)
          .orderBy('date', descending: true)
          .get();

      _records = snapshot.docs
          .map((doc) => MedicalRecord.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load medical records: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<MedicalRecord> createMedicalRecord(MedicalRecord record) async {
    try {
      final docRef =
          await _firestore.collection('medical_records').add(record.toJson());

      final newRecord = record.copyWith(id: docRef.id);
      _records.add(newRecord);
      _records.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
      return newRecord;
    } catch (e) {
      _setError('Failed to create medical record: $e');
      throw Exception('Failed to create medical record: $e');
    }
  }

  Future<void> updateMedicalRecord(MedicalRecord record) async {
    try {
      await _firestore
          .collection('medical_records')
          .doc(record.id)
          .update(record.toJson());

      final index = _records.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _records[index] = record;
        _records.sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update medical record: $e');
      throw Exception('Failed to update medical record: $e');
    }
  }

  Future<void> deleteMedicalRecord(String recordId) async {
    try {
      await _firestore.collection('medical_records').doc(recordId).delete();

      _records.removeWhere((record) => record.id == recordId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete medical record: $e');
      throw Exception('Failed to delete medical record: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
