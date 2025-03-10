import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_filter_bar.dart';
import '../widgets/add_patient_fab.dart';

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() =>
      _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final _searchController = TextEditingController();
  PatientStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final therapistId = context.read<AuthProvider>().user!.id;
    await context.read<PatientProvider>().loadPatients(therapistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportPatientData,
          ),
        ],
      ),
      body: Column(
        children: [
          PatientFilterBar(
            searchController: _searchController,
            statusFilter: _statusFilter,
            onStatusChanged: (status) {
              setState(() => _statusFilter = status);
            },
            onSearch: (query) {
              // Implement search functionality
            },
          ),
          Expanded(
            child: Consumer<PatientProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final patients = provider.patients;
                if (patients.isEmpty) {
                  return const Center(
                    child: Text('No patients found'),
                  );
                }

                return PatientListView(
                  patients: patients,
                  onPatientTap: _navigateToPatientDetails,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const AddPatientFAB(),
    );
  }

  void _navigateToPatientDetails(Patient patient) {
    Navigator.pushNamed(
      context,
      '/patient-details',
      arguments: patient,
    );
  }

  Future<void> _exportPatientData() async {
    // Implement export functionality
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
