import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/therapist_model.dart';
import '../../auth/models/user_model.dart';

class TherapistProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Therapist> _therapists = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Therapist> get therapists => _therapists;

  // Load all therapists (for admin view)
  Future<void> loadTherapists() async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', whereIn: ['therapist', 'admin'])
          .orderBy('displayName')
          .get();

      _therapists = snapshot.docs
          .map((doc) => Therapist.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load therapists: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Register a new therapist (creates both auth and Firestore entries)
  Future<void> registerTherapist(Therapist therapist, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // 1. Create auth user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: therapist.email,
        password: password,
      );

      // 2. Update display name
      await userCredential.user!.updateDisplayName(therapist.displayName);

      // 3. Create user document with therapist-specific data
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'displayName': therapist.displayName,
        'email': therapist.email,
        'role': UserRole.therapist.toString().split('.').last,
        'specialization': therapist.specialization,
        'phone': therapist.phone,
        'licenseNumber': therapist.licenseNumber,
        if (therapist.biography != null && therapist.biography!.isNotEmpty)
          'biography': therapist.biography,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _setError('Failed to register therapist: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Get a therapist by ID
  Future<Therapist?> getTherapist(String therapistId) async {
    try {
      final doc = await _firestore.collection('users').doc(therapistId).get();

      if (!doc.exists) return null;

      return Therapist.fromJson({'id': doc.id, ...doc.data()!});
    } catch (e) {
      _setError('Failed to get therapist: $e');
      return null;
    }
  }

  // Update a therapist's information
  Future<void> updateTherapist(Therapist therapist) async {
    _setLoading(true);
    try {
      await _firestore
          .collection('users')
          .doc(therapist.id)
          .update(therapist.toJson());

      // Update in local list
      final index = _therapists.indexWhere((t) => t.id == therapist.id);
      if (index != -1) {
        _therapists[index] = therapist;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update therapist: $e');
      throw Exception('Failed to update therapist: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Activate/deactivate a therapist
  Future<void> setTherapistActive(String therapistId, bool active) async {
    _setLoading(true);
    try {
      await _firestore
          .collection('users')
          .doc(therapistId)
          .update({'active': active});

      // Update in local list
      final index = _therapists.indexWhere((t) => t.id == therapistId);
      if (index != -1) {
        _therapists[index] = _therapists[index].copyWith(active: active);
        notifyListeners();
      }
    } catch (e) {
      _setError(
          'Failed to ${active ? 'activate' : 'deactivate'} therapist: $e');
      throw Exception('Failed to update therapist status: $e');
    } finally {
      _setLoading(false);
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

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
