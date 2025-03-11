import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/therapist_provider.dart';
import '../../shared/widgets/email_field.dart';
import '../../shared/widgets/phone_field.dart';
import '../../shared/widgets/custom_text_field.dart';

class TherapistRegistrationScreen extends StatefulWidget {
  const TherapistRegistrationScreen({super.key});

  @override
  State<TherapistRegistrationScreen> createState() =>
      _TherapistRegistrationScreenState();
}

class _TherapistRegistrationScreenState
    extends State<TherapistRegistrationScreen> {
  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final user = context.read<AuthProvider>().user;
    if (user?.role != UserRole.admin) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only administrators can access this page'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ... rest of the implementation similar to AddPatientScreen
  // but with therapist-specific fields
}
