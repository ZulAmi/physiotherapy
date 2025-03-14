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
import '../../features/exercise/models/exercise_model.dart';
import '../../features/exercise/screens/exercise_monitoring_screen.dart';

// Import the new website pages
import '../../features/website/screens/home_page.dart';
import '../../features/website/screens/features_page.dart';
import '../../features/website/screens/pricing_page.dart';
import '../../features/website/screens/about_page.dart';
import '../../features/website/screens/contact_page.dart';

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
  static const String exerciseMonitoring = '/exercise/monitoring';

  // Patient management routes
  static const String patientManagement = '/patient-management';
  static const String addPatient = '/add-patient';
  static const String patientDetails = '/patient-details';
  static const String editPatient = '/edit-patient';

  // Appointment routes
  static const String appointmentBooking = '/appointment-booking';
  static const String appointmentList = '/appointment-list';

  // Website pages routes
  static const String homePage = '/home';
  static const String featuresPage = '/features';
  static const String pricingPage = '/pricing';
  static const String aboutPage = '/about';
  static const String contactPage = '/contact';

  // Resource routes
  static const String blogPage = '/blog';
  static const String knowledgeBasePage = '/knowledge-base';
  static const String researchPage = '/research';
  static const String caseStudiesPage = '/case-studies';
  static const String documentationPage = '/docs';

  // Legal routes
  static const String privacyPolicyPage = '/privacy';
  static const String termsOfServicePage = '/terms';
  static const String cookiePolicyPage = '/cookies';

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

      // Website pages
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case featuresPage:
        return MaterialPageRoute(builder: (_) => const FeaturesPage());

      case pricingPage:
        return MaterialPageRoute(builder: (_) => const PricingPage());

      case aboutPage:
        return MaterialPageRoute(builder: (_) => const AboutPage());

      case contactPage:
        return MaterialPageRoute(builder: (_) => const ContactPage());

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

      case exerciseMonitoring:
        final args = settings.arguments as Map<String, dynamic>;
        final exercise = args['exercise'] as Exercise;
        return MaterialPageRoute(
          builder: (_) => ExerciseMonitoringScreen(exercise: exercise),
        );

      case blogPage:
      case knowledgeBasePage:
      case researchPage:
      case caseStudiesPage:
      case documentationPage:
      case privacyPolicyPage:
      case termsOfServicePage:
      case cookiePolicyPage:
        // For now, return a simple placeholder page
        return MaterialPageRoute(
          builder: (_) => _buildPlaceholderPage(settings.name!.substring(1)),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => _buildNotFoundPage(),
        );
    }
  }

  // Helper method for placeholder pages
  static Widget _buildPlaceholderPage(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.toUpperCase()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNotFoundPage() {
    return Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
