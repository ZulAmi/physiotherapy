import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../widgets/patient_stats_card.dart';
import '../widgets/patient_list_card.dart';
import '../../../core/theme/app_theme.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PatientStatsCard(
                              title: 'Active Patients',
                              value: provider.patients.length.toString(),
                              icon: Icons.people,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PatientStatsCard(
                              title: 'Today\'s Sessions',
                              value: '8',
                              icon: Icons.calendar_today,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: PatientStatsCard(
                              title: 'Recovery Rate',
                              value: '85%',
                              icon: Icons.trending_up,
                              color: AppTheme.successColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PatientStatsCard(
                              title: 'Adherence Rate',
                              value: '92%',
                              icon: Icons.check_circle,
                              color: AppTheme.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: PatientListCard(patients: provider.patients),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPatientDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Patient'),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    // Implementation for search dialog
  }

  void _showFilterOptions(BuildContext context) {
    // Implementation for filter options
  }

  void _showAddPatientDialog(BuildContext context) {
    // Implementation for add patient dialog
  }
}
