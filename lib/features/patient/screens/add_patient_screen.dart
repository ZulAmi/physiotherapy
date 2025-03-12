import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../models/patient_model.dart';
import '../../shared/widgets/email_field.dart';
import '../../shared/widgets/phone_field.dart';
import '../../shared/widgets/numeric_field.dart';
import '../../shared/widgets/date_picker_field.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/utils/validation_utils.dart';
import '../../auth/providers/auth_provider.dart';

class AddPatientScreen extends StatefulWidget {
  final bool isQuickAdd;

  const AddPatientScreen({
    super.key,
    this.isQuickAdd = false,
  });

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _conditionController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime? _dateOfBirth;
  final List<String> _medications = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isQuickAdd ? 'Quick Add Patient' : 'Add New Patient'),
        actions: [
          if (!widget.isQuickAdd)
            TextButton.icon(
              onPressed: _scanDocuments,
              icon: const Icon(Icons.document_scanner),
              label: const Text('Scan'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoSection(),
              if (!widget.isQuickAdd) ...[
                const SizedBox(height: 24),
                _buildMedicalInfoSection(),
              ],
              const SizedBox(height: 32),
              _buildSubmitButton(),
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
            DatePickerField(
              label: 'Date of Birth',
              selectedDate: _dateOfBirth,
              onDateSelected: (date) => setState(() => _dateOfBirth = date),
              isRequired: true,
              validator: ValidationUtils.validateDateOfBirth,
            ),
            const SizedBox(height: 16),
            EmailField(
              controller: _emailController,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            PhoneField(
              controller: _phoneController,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            NumericField(
              controller: _ageController,
              label: 'Age',
              isRequired: true,
              minValue: 0,
              maxValue: 120,
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
            _buildMedicationsList(),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emergencyContactController,
              label: 'Emergency Contact',
              icon: Icons.emergency,
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

  Widget _buildMedicationsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.medication, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Medications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton(
              onPressed: _addMedication,
              child: const Text('Add'),
            ),
          ],
        ),
        if (_medications.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _medications
                .map(
                  (med) => Chip(
                    label: Text(med),
                    onDeleted: () => _removeMedication(med),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Add Patient'),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _addMedication() {
    showDialog(
      context: context,
      builder: (context) => _AddMedicationDialog(
        onAdd: (medication) {
          setState(() => _medications.add(medication));
        },
      ),
    );
  }

  void _removeMedication(String medication) {
    setState(() => _medications.remove(medication));
  }

  void _scanDocuments() {
    // Implement document scanning functionality
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final therapistId = context.read<AuthProvider>().user!.id;
      final patient = Patient(
        id: '', // Will be set by Firestore
        name: _nameController.text,
        email: _emailController.text,
        therapistId: therapistId,
        dateOfBirth: _dateOfBirth!,
        phoneNumber: _phoneController.text,
        emergencyContact: _emergencyContactController.text,
        condition: _conditionController.text,
        diagnosis: _diagnosisController.text,
        medications: _medications,
        notes: _notesController.text,
        lastVisit: DateTime.now(),
      );

      await context.read<PatientProvider>().addPatient(patient);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient added successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding patient: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
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
    _ageController.dispose();
    super.dispose();
  }
}

class _AddMedicationDialog extends StatelessWidget {
  final void Function(String) onAdd;
  final _medicationController = TextEditingController();

  _AddMedicationDialog({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Medication'),
      content: TextField(
        controller: _medicationController,
        decoration: const InputDecoration(
          labelText: 'Medication Name',
          hintText: 'Enter medication name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_medicationController.text.isNotEmpty) {
              onAdd(_medicationController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
