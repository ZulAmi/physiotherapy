import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart';
import '../../../core/theme/app_theme.dart';

class PatientInfoCard extends StatelessWidget {
  final Patient patient;

  const PatientInfoCard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientHeader(context),
          Divider(height: 1, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Date of Birth',
                    _formatDate(patient.dateOfBirth), Icons.cake),
                const SizedBox(height: 12),
                _buildInfoRow(context, 'Email', patient.email, Icons.email),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  'Phone',
                  patient.phoneNumber ?? 'Not provided',
                  Icons.phone,
                  textColor: patient.phoneNumber != null ? null : Colors.grey,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  'Emergency Contact',
                  patient.emergencyContact ?? 'Not provided',
                  Icons.emergency,
                  textColor:
                      patient.emergencyContact != null ? null : Colors.grey,
                ),
              ],
            ),
          ),
          _buildContactActions(context),
        ],
      ),
    );
  }

  Widget _buildPatientHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              patient.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    _buildStatusChip(context),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Patient ID: ${patient.id.substring(0, 8)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Last visit: ${_formatDate(patient.lastVisit)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (patient.status) {
      case PatientStatus.active:
        statusColor = AppTheme.successColor;
        statusText = 'Active';
        break;
      case PatientStatus.inactive:
        statusColor = Colors.grey;
        statusText = 'Inactive';
        break;
      case PatientStatus.discharged:
        statusColor = AppTheme.accentColor;
        statusText = 'Discharged';
        break;
      case PatientStatus.onHold:
        statusColor = AppTheme.warningColor;
        statusText = 'On Hold';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            context,
            'Call',
            Icons.call,
            onPressed: patient.phoneNumber != null
                ? () {
                    // Handle call
                  }
                : null,
          ),
          _buildActionButton(
            context,
            'Message',
            Icons.message,
            onPressed: () {
              // Handle message
            },
          ),
          _buildActionButton(
            context,
            'Email',
            Icons.email,
            onPressed: () {
              // Handle email
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon, {
    VoidCallback? onPressed,
  }) {
    final color = onPressed == null
        ? Colors.grey.shade400
        : Theme.of(context).primaryColor;

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 18),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
