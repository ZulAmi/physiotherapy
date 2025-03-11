import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/therapist/screens/therapist_dashboard.dart';
import '../../features/therapist/screens/therapist_registration_screen.dart';
import '../../features/patient/screens/patient_dashboard.dart';
import '../enums/user_role.dart';
import './route_guard.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String therapistDashboard = '/therapist-dashboard';
  static const String patientDashboard = '/patient-dashboard';
  static const String therapistRegistration = '/therapist-registration';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case therapistDashboard:
        return MaterialPageRoute(builder: (_) => const TherapistDashboard());

      case patientDashboard:
        return MaterialPageRoute(builder: (_) => const PatientDashboard());

      case therapistRegistration:
        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRole: UserRole.admin,
            routeName: settings.name!,
            child: const TherapistRegistrationScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
