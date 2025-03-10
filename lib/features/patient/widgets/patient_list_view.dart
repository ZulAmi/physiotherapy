import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import 'patient_list_tile.dart';

class PatientListView extends StatelessWidget {
  final List<Patient> patients;
  final Function(Patient) onPatientTap;

  const PatientListView({
    super.key,
    required this.patients,
    required this.onPatientTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return PatientListTile(
          patient: patient,
          onTap: () => onPatientTap(patient),
        );
      },
    );
  }
}
