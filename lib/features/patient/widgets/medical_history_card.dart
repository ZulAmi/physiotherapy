import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class MedicalHistoryCard extends StatefulWidget {
  final Patient patient;

  const MedicalHistoryCard({
    super.key,
    required this.patient,
  });

  @override
  State<MedicalHistoryCard> createState() => _MedicalHistoryCardState();
}

class _MedicalHistoryCardState extends State<MedicalHistoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCardHeader(context),
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMedicalInfoSection(context),
                  const SizedBox(height: 16),
                  _buildMedicationsSection(context),
                  const SizedBox(height: 16),
                  _buildNotesSection(context),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.medical_information, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (!_isExpanded && widget.patient.condition != null)
                    Text(
                      widget.patient.condition!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Condition & Diagnosis'),
        const SizedBox(height: 8),
        _buildInfoCard(
          context,
          'Medical Condition',
          widget.patient.condition ?? 'Not specified',
          Icons.health_and_safety,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          'Diagnosis',
          widget.patient.diagnosis ?? 'Not specified',
          Icons.article,
        ),
      ],
    );
  }

  Widget _buildMedicationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Medications'),
        const SizedBox(height: 8),
        widget.patient.medications.isEmpty
            ? _buildEmptyPlaceholder('No medications recorded')
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.patient.medications
                    .map(
                      (medication) => Chip(
                        label: Text(medication),
                        avatar: const Icon(Icons.medication, size: 16),
                        backgroundColor: Colors.blue.shade50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Clinical Notes'),
        const SizedBox(height: 8),
        widget.patient.notes == null || widget.patient.notes!.isEmpty
            ? _buildEmptyPlaceholder('No notes recorded')
            : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  widget.patient.notes!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isNotSpecified = value == 'Not specified';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 20, color: isNotSpecified ? Colors.grey : Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: isNotSpecified ? Colors.grey : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholder(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
