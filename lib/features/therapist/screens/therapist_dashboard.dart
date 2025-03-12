import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/components/styled_card.dart';
import '../../../core/routes/app_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/extensions/user_extensions.dart';
import '../widgets/therapist_drawer.dart';

class TherapistDashboard extends StatelessWidget {
  const TherapistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Handle loading and error states properly
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Safety check for user
    if (user == null) {
      // This should be unlikely since route guards should prevent this
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Session expired'),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/login'),
                child: const Text('Return to Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 36),
            const SizedBox(width: 8),
            const Text('PhysioFlow'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(AppRouter.login);
              }
            },
          ),
        ],
      ),
      drawer: const TherapistDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user?.displayNameSafe ?? "Therapist"}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Dashboard',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildDashboardTile(
                  context,
                  title: 'Patients',
                  icon: Icons.people,
                  color: AppTheme.primaryColor,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.patientManagement),
                ),
                _buildDashboardTile(
                  context,
                  title: 'Appointments',
                  icon: Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  onTap: () {/* Navigate to appointments */},
                ),
                _buildDashboardTile(
                  context,
                  title: 'Exercise Library',
                  icon: Icons.fitness_center,
                  color: AppTheme.primaryColor,
                  onTap: () {/* Navigate to exercise library */},
                ),
                _buildDashboardTile(
                  context,
                  title: 'Reports',
                  icon: Icons.bar_chart,
                  color: AppTheme.primaryColor,
                  onTap: () {/* Navigate to reports */},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Today\'s Schedule',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            StyledCard(
              child: Column(
                children: [
                  // Placeholder for schedule items
                  _buildAppointmentItem(
                    time: '09:00 AM',
                    patient: 'John Doe',
                    purpose: 'Follow-up',
                    context: context,
                  ),
                  const Divider(),
                  _buildAppointmentItem(
                    time: '11:30 AM',
                    patient: 'Sarah Smith',
                    purpose: 'Initial Assessment',
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new appointment
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentItem({
    required String time,
    required String patient,
    required String purpose,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLightColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  purpose,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              // Navigate to appointment details
            },
          ),
        ],
      ),
    );
  }
}
