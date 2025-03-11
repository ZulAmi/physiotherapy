import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to authentication state changes
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      // Fetch additional user data from Firestore
      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        _user = AppUser.fromJson({
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName,
          ...userDoc.data()!,
        });
      } else {
        // Handle case where user auth exists but profile doesn't
        _user = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          role: UserRole.therapist, // Default role
        );
      }
    } catch (e) {
      _setError('Error retrieving user profile: $e');
    } finally {
      _setLoading(false);
    }

    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User will be set by the authStateChanges listener
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String displayName,
    UserRole role,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // Create Firebase auth user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(displayName);

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'displayName': displayName,
        'email': email,
        'role': role.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // User will be set by the authStateChanges listener
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _firebaseAuth.signOut();
      // User will be cleared by the authStateChanges listener
    } catch (e) {
      _setError('Error signing out: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _handleAuthError(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found with this email address.');
          break;
        case 'wrong-password':
          _setError('Incorrect password.');
          break;
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
      _setError('Authentication error: $e');
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

  // Add this getter to determine the initial route
  String get initialRoute {
    // If still loading auth state, return splash screen
    if (_isLoading) {
      return '/splash';
    }

    // If not authenticated, go to login
    if (_user == null) {
      return '/login';
    }

    // Determine route based on user role
    switch (_user!.role) {
      case UserRole.therapist:
      case UserRole.admin:
        return '/therapist/dashboard';
      case UserRole.patient:
        return '/patient/dashboard';
      case UserRole.assistant:
        return '/assistant/dashboard';
      default:
        return '/login';
    }
  }
}
