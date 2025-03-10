import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class PatientListCard extends StatelessWidget {
  final List<Patient> patients;

  const PatientListCard({
    super.key,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Recent Patients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: patients.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    patient.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(patient.name),
                subtitle: Text(patient.condition ?? 'No condition specified'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () => _viewPatient(context, patient),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editPatient(context, patient),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _viewPatient(BuildContext context, Patient patient) {
    // Implementation for viewing patient details
  }

  void _editPatient(BuildContext context, Patient patient) {
    // Implementation for editing patient
  }
}
