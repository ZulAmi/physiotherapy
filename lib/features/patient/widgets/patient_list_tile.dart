import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart';

class PatientListTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientListTile({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildPatientAvatar(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        _buildStatusChip(context),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildPatientInfo(context),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: _getAvatarColor(),
      child: Text(
        patient.name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        patient.status.name.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPatientInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final age = DateTime.now().year - patient.dateOfBirth.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              'Last visit: ${DateFormat('MMM d, yyyy').format(patient.lastVisit)}',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '$age years old${patient.condition != null ? ' • ${patient.condition}' : ''}',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.message_outlined),
          onPressed: () {
            // Handle messaging
          },
          tooltip: 'Send message',
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showPatientOptions(context),
          tooltip: 'More options',
        ),
      ],
    );
  }

  void _showPatientOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Patient'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to edit screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Assign Exercise'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to exercise assignment
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Schedule Appointment'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to appointment scheduling
            },
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    final index = patient.name.hashCode % colors.length;
    return colors[index];
  }

  Color _getStatusColor() {
    switch (patient.status) {
      case PatientStatus.active:
        return Colors.green;
      case PatientStatus.inactive:
        return Colors.grey;
      case PatientStatus.discharged:
        return Colors.blue;
      case PatientStatus.onHold:
        return Colors.orange;
    }
  }
}
