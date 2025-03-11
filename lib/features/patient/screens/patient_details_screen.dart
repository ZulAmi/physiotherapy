import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../widgets/patient_info_card.dart';
import '../widgets/medical_history_card.dart';
import '../widgets/exercise_plan_card.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String patientId;

  const PatientDetailsScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    setState(() => _isLoading = true);
    try {
      await context.read<PatientProvider>().selectPatient(widget.patientId);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditPatient(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'assign_exercise',
                child: Text('Assign Exercise'),
              ),
              const PopupMenuItem(
                value: 'schedule_appointment',
                child: Text('Schedule Appointment'),
              ),
              const PopupMenuItem(
                value: 'patient_history',
                child: Text('View Medical History'),
              ),
              const PopupMenuItem(
                value: 'download_report',
                child: Text('Download Report'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<PatientProvider>(
              builder: (context, provider, child) {
                final patient = provider.selectedPatient;
                if (patient == null) {
                  return const Center(
                    child: Text('Patient not found'),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PatientInfoCard(patient: patient),
                      const SizedBox(height: 16),
                      MedicalHistoryCard(patient: patient),
                      const SizedBox(height: 16),
                      ExercisePlanCard(patient: patient),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _navigateToEditPatient(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/edit-patient',
      arguments: {'patientId': widget.patientId},
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'assign_exercise':
        Navigator.pushNamed(
          context,
          '/assign-exercise',
          arguments: {
            'patientId': widget.patientId,
          },
        );
        break;
      case 'schedule_appointment':
        Navigator.pushNamed(
          context,
          '/appointment-booking',
          arguments: {
            'patientId': widget.patientId,
          },
        );
        break;
      case 'patient_history':
        Navigator.pushNamed(
          context,
          '/patient-history',
          arguments: {
            'patientId': widget.patientId,
          },
        );
        break;
      case 'download_report':
        _generateAndDownloadReport();
        break;
    }
  }

  Future<void> _generateAndDownloadReport() async {
    try {
      setState(() => _isLoading = true);
      final patient = context.read<PatientProvider>().selectedPatient;

      if (patient == null) {
        throw Exception('Patient data not available');
      }

      // Show generating dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            title: Text('Generating Report'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Please wait while we generate your report...'),
              ],
            ),
          ),
        );
      }

      // Call report service
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      final reportUrl = await context
          .read<ReportProvider>()
          .generatePatientReport(patient.id);

      // Dismiss dialog
      if (mounted) Navigator.of(context).pop();

      // Show success dialog with options
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Report Generated'),
            content: const Text(
                'Your patient report has been successfully generated.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _viewReport(reportUrl);
                },
                child: const Text('View'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _downloadReport(reportUrl);
                },
                child: const Text('Download'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _viewReport(String reportUrl) {
    Navigator.pushNamed(
      context,
      '/report-viewer',
      arguments: {
        'reportUrl': reportUrl,
        'patientId': widget.patientId,
      },
    );
  }

  void _downloadReport(String reportUrl) {
    context.read<ReportProvider>().downloadReport(reportUrl).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report downloaded successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading report: $error')),
      );
    });
  }
}
