import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/therapist_model.dart';

class TherapistProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  Future<Therapist> registerTherapist(
      Therapist therapist, String password) async {
    _setLoading(true);
    try {
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: therapist.email,
        password: password,
      );

      // Generate user ID from Firebase Auth
      final userId = userCredential.user!.uid;

      // Update display name
      await userCredential.user!.updateDisplayName(therapist.displayName);

      // Prepare therapist data for Firestore
      final therapistData = {
        ...therapist.toJson(),
        'id': userId,
        'role': 'therapist',
        'createdAt': FieldValue.serverTimestamp(),
        'active': true,
      };

      // Create therapist document in Firestore
      await _firestore.collection('users').doc(userId).set(therapistData);

      // Create a new Therapist object with the Firebase user ID
      final newTherapist = Therapist.fromJson({'id': userId, ...therapistData});

      // Add to local list
      _therapists.add(newTherapist);
      // Sort with null safety handling
      _therapists.sort((a, b) {
        // Handle null cases first
        if (a.displayName == null && b.displayName == null) return 0;
        if (a.displayName == null) return -1;
        if (b.displayName == null) return 1;
        // Normal string comparison when both values are non-null
        return a.displayName!.compareTo(b.displayName!);
      });

      notifyListeners();
      return newTherapist;
    } catch (e) {
      _handleAuthError(e);
      throw Exception('Failed to register therapist: $_error');
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

  // Helper method to handle authentication errors
  void _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          _setError('This email is already registered.');
          break;
        case 'weak-password':
          _setError('Password is too weak.');
          break;
        case 'invalid-email':
          _setError('Invalid email address format.');
          break;
        default:
          _setError('Authentication error: ${e.message}');
      }
    } else {
      _setError('Error: $e');
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
