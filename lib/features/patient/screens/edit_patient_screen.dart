import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../models/patient_model.dart';
import '../../shared/widgets/email_field.dart';
import '../../shared/widgets/phone_field.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/utils/validation_utils.dart';

class EditPatientScreen extends StatefulWidget {
  final String patientId;

  const EditPatientScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emergencyContactController;
  late final TextEditingController _conditionController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _notesController;

  bool _isLoading = true;
  bool _isSaving = false;
  Patient? _patient;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _conditionController = TextEditingController();
    _diagnosisController = TextEditingController();
    _notesController = TextEditingController();

    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    setState(() => _isLoading = true);
    try {
      await context.read<PatientProvider>().selectPatient(widget.patientId);
      _patient = context.read<PatientProvider>().selectedPatient;

      if (_patient != null) {
        _nameController.text = _patient!.name;
        _emailController.text = _patient!.email;
        _phoneController.text = _patient!.phoneNumber ?? '';
        _emergencyContactController.text = _patient!.emergencyContact ?? '';
        _conditionController.text = _patient!.condition ?? '';
        _diagnosisController.text = _patient!.diagnosis ?? '';
        _notesController.text = _patient!.notes ?? '';
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient'),
        actions: [
          TextButton.icon(
            onPressed: _isSaving || _isLoading ? null : _saveChanges,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patient == null
              ? const Center(child: Text('Patient not found'))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPersonalInfoSection(),
                        const SizedBox(height: 16),
                        _buildMedicalInfoSection(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            EmailField(
              controller: _emailController,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            PhoneField(
              controller: _phoneController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emergencyContactController,
              label: 'Emergency Contact',
              icon: Icons.emergency,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _conditionController,
              label: 'Medical Condition',
              icon: Icons.medical_information,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _diagnosisController,
              label: 'Diagnosis',
              icon: Icons.history_edu,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _notesController,
              label: 'Additional Notes',
              icon: Icons.note,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_patient == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedPatient = _patient!.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        emergencyContact: _emergencyContactController.text,
        condition: _conditionController.text,
        diagnosis: _diagnosisController.text,
        notes: _notesController.text,
      );

      await context.read<PatientProvider>().updatePatient(updatedPatient);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating patient: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _conditionController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
