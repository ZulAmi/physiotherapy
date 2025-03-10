import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../core/enums/user_role.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      _user = UserModel.fromJson({
        'id': userCredential.user!.uid,
        'email': userCredential.user!.email!,
        ...userData.data() ?? {},
      });

      notifyListeners();
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: name,
        role: UserRole.patient, // Default role for new users
      );
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  String get initialRoute {
    if (_user == null) return '/login';
    switch (_user!.role) {
      case UserRole.therapist:
        return '/therapist-dashboard';
      case UserRole.patient:
        return '/patient-dashboard';
      case UserRole.admin:
        return '/admin-dashboard';
      default:
        return '/login';
    }
  }

  String getInitialRoute() {
    if (_user == null) return '/login';

    switch (_user!.role) {
      case UserRole.patient:
        return '/patient-home';
      case UserRole.therapist:
        return '/therapist-dashboard';
      case UserRole.admin:
        return '/admin-dashboard';
      default:
        return '/login';
    }
  }

  bool canAccessRoute(String route) {
    if (_user == null) return false;

    final protectedRoutes = {
      '/therapist-dashboard': [UserRole.therapist, UserRole.admin],
      '/patient-management': [UserRole.therapist, UserRole.admin],
      '/exercise-prescription': [UserRole.therapist],
      '/analytics': [UserRole.therapist, UserRole.admin],
      '/admin-dashboard': [UserRole.admin],
    };

    final requiredRoles = protectedRoutes[route];
    if (requiredRoles == null) return true;

    return requiredRoles.contains(_user!.role);
  }
}
