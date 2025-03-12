import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/enums/user_role.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Only redirect if this screen was shown as the initial route
    // This allows us to navigate to the SplashScreen from other screens without redirection
    if (ModalRoute.of(context)?.settings.name == AppRouter.splash) {
      await Future.delayed(const Duration(seconds: 2)); // Splash delay

      if (!mounted) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // If user is already authenticated, redirect to appropriate dashboard
      // Otherwise, go to landing page (not login directly)
      if (authProvider.isAuthenticated) {
        final user = authProvider.user!;
        switch (user.role) {
          case UserRole.therapist:
            Navigator.of(context)
                .pushReplacementNamed(AppRouter.therapistDashboard);
            break;
          case UserRole.patient:
            Navigator.of(context)
                .pushReplacementNamed(AppRouter.patientDashboard);
            break;
          case UserRole.admin:
            Navigator.of(context)
                .pushReplacementNamed(AppRouter.adminDashboard);
            break;
          default:
            Navigator.of(context).pushReplacementNamed(AppRouter.landingPage);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(AppRouter.landingPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo or splash animation
            Image.asset('assets/images/logo.png', height: 120),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
