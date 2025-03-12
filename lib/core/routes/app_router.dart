import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/therapist/screens/therapist_dashboard.dart';
import '../../features/therapist/screens/therapist_registration_screen.dart';
import '../../features/patient/screens/patient_dashboard.dart';
import '../../features/patient/screens/patient_management_screen.dart';
import '../../features/patient/screens/add_patient_screen.dart';
import '../../features/patient/screens/patient_details_screen.dart';
import '../../features/patient/screens/edit_patient_screen.dart';
import '../../features/appointment/screens/appointment_booking_screen.dart';
import '../../features/auth/screens/admin_registration_screen.dart';
import '../../features/website/screens/landing_page.dart';
import '../../features/admin/screens/admin_dashboard.dart';
import '../enums/user_role.dart';
import './route_guard.dart';

class AppRouter {
  // Route constants
  static const String splash = '/splash';
  static const String login = '/login';
  static const String therapistDashboard = '/therapist/dashboard';
  static const String patientDashboard = '/patient/dashboard';
  static const String assistantDashboard = '/assistant/dashboard';
  static const String therapistRegistration = '/therapist/registration';
  static const String adminRegistration = '/admin/registration';
  static const String landingPage = '/';
  static const String adminDashboard = '/admin/dashboard';

  // Patient management routes
  static const String patientManagement = '/patient-management';
  static const String addPatient = '/add-patient';
  static const String patientDetails = '/patient-details';
  static const String editPatient = '/edit-patient';

  // Appointment routes
  static const String appointmentBooking = '/appointment-booking';
  static const String appointmentList = '/appointment-list';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case therapistDashboard:
        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRole: UserRole.therapist,
            routeName: settings.name!,
            child: const TherapistDashboard(),
          ),
        );

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

      case adminRegistration:
        return MaterialPageRoute(
            builder: (_) => const AdminRegistrationScreen());

      case landingPage:
        return MaterialPageRoute(builder: (_) => const LandingPage());

      // Patient management routes
      case patientManagement:
        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRoles: [UserRole.therapist, UserRole.admin],
            routeName: settings.name!,
            child: const PatientManagementScreen(),
          ),
        );

      case addPatient:
        final args = settings.arguments as Map<String, dynamic>?;
        final isQuickAdd = args?['isQuickAdd'] as bool? ?? false;

        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRoles: [UserRole.therapist, UserRole.admin],
            routeName: settings.name!,
            child: AddPatientScreen(isQuickAdd: isQuickAdd),
          ),
        );

      case patientDetails:
        final args = settings.arguments as Map<String, dynamic>;
        final patientId = args['patientId'] as String;

        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRoles: [UserRole.therapist, UserRole.admin],
            routeName: settings.name!,
            child: PatientDetailsScreen(patientId: patientId),
          ),
        );

      case editPatient:
        final args = settings.arguments as Map<String, dynamic>;
        final patientId = args['patientId'] as String;

        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRoles: [UserRole.therapist, UserRole.admin],
            routeName: settings.name!,
            child: EditPatientScreen(patientId: patientId),
          ),
        );

      case appointmentBooking:
        final args = settings.arguments as Map<String, dynamic>;
        final patientId = args['patientId'] as String;
        final existingAppointment = args['appointment'];

        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRoles: [UserRole.therapist, UserRole.admin],
            routeName: settings.name!,
            child: AppointmentBookingScreen(
              patientId: patientId,
              existingAppointment: existingAppointment,
            ),
          ),
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => RouteGuard(
            requiredRole: UserRole.admin,
            routeName: settings.name!,
            child: const AdminDashboard(),
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
