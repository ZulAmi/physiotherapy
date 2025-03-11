import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/patient_provider.dart';
import '../providers/medical_record_provider.dart';
import '../models/medical_record_model.dart';
import '../models/patient_model.dart';

class PatientHistoryScreen extends StatefulWidget {
  final String patientId;

  const PatientHistoryScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        context.read<PatientProvider>().selectPatient(widget.patientId),
        context
            .read<MedicalRecordProvider>()
            .loadMedicalRecords(widget.patientId),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading medical history: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Appointments'),
            Tab(text: 'Treatments'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer2<PatientProvider, MedicalRecordProvider>(
              builder: (context, patientProvider, recordProvider, _) {
                final patient = patientProvider.selectedPatient;
                if (patient == null) {
                  return const Center(child: Text('Patient not found'));
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(patient, recordProvider.records),
                    _buildAppointmentsTab(recordProvider.appointments),
                    _buildTreatmentsTab(recordProvider.treatments),
                    _buildProgressTab(recordProvider.progress),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedicalRecord,
        child: const Icon(Icons.add),
        tooltip: 'Add Record',
      ),
    );
  }

  Widget _buildOverviewTab(Patient patient, List<MedicalRecord> records) {
    final latestRecords = records.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientSummaryCard(patient),
          const SizedBox(height: 16),
          _buildMedicalConditionsCard(patient),
          const SizedBox(height: 16),
          _buildRecentActivityCard(latestRecords),
        ],
      ),
    );
  }

  Widget _buildPatientSummaryCard(Patient patient) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildInfoRow('Patient Name', patient.name),
            _buildInfoRow(
              'Age',
              '${DateTime.now().year - patient.dateOfBirth.year} years',
            ),
            _buildInfoRow('Started Treatment', _formatDate(patient.lastVisit)),
            _buildInfoRow('Total Sessions', '${patient.totalSessions}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalConditionsCard(Patient patient) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Conditions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            if (patient.condition != null)
              _buildInfoRow('Primary Condition', patient.condition!),
            if (patient.diagnosis != null)
              _buildInfoRow('Diagnosis', patient.diagnosis!),
            if (patient.allergies != null)
              _buildInfoRow('Allergies', patient.allergies!),
            if (patient.medications.isNotEmpty)
              _buildInfoRow('Medications', patient.medications.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(List<MedicalRecord> records) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            if (records.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('No recent activity')),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    leading: _getRecordTypeIcon(record.type),
                    title: Text(record.title),
                    subtitle: Text(_formatDate(record.date)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showRecordDetail(record),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab(List<dynamic> appointments) {
    return appointments.isEmpty
        ? const Center(child: Text('No appointment history'))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                leading: const Icon(Icons.event),
                title: Text(appointment.title),
                subtitle: Text(_formatDate(appointment.date)),
                trailing: Chip(
                  label: Text(appointment.status),
                  backgroundColor: _getStatusColor(appointment.status),
                ),
              );
            },
          );
  }

  Widget _buildTreatmentsTab(List<dynamic> treatments) {
    return treatments.isEmpty
        ? const Center(child: Text('No treatment history'))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: treatments.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final treatment = treatments[index];
              return ListTile(
                leading: const Icon(Icons.healing),
                title: Text(treatment.name),
                subtitle: Text(_formatDate(treatment.date)),
                trailing: Text('by ${treatment.therapist}'),
              );
            },
          );
  }

  Widget _buildProgressTab(List<dynamic> progressItems) {
    return progressItems.isEmpty
        ? const Center(child: Text('No progress data'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress Overview',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('Progress Chart Placeholder'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: progressItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final progress = progressItems[index];
                      return ListTile(
                        title: Text(progress.metric),
                        subtitle: Text(_formatDate(progress.date)),
                        trailing: Text(
                          progress.value.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Icon _getRecordTypeIcon(MedicalRecordType type) {
    switch (type) {
      case MedicalRecordType.note:
        return Icon(Icons.note, color: Colors.blue.shade700);
      case MedicalRecordType.assessment:
        return Icon(Icons.assessment, color: Colors.green.shade700);
      case MedicalRecordType.prescription:
        return Icon(Icons.medication, color: Colors.red.shade700);
      case MedicalRecordType.test:
        return Icon(Icons.science, color: Colors.purple.shade700);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade100;
      case 'scheduled':
        return Colors.blue.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _showRecordDetail(MedicalRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_formatDate(record.date)}'),
            Text('Provider: ${record.provider}'),
            const Divider(),
            Text(record.content),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addMedicalRecord() {
    // Navigate to add record screen
    Navigator.pushNamed(
      context,
      '/add-medical-record',
      arguments: {'patientId': widget.patientId},
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
