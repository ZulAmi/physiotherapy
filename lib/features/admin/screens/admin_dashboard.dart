import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/auth/extensions/user_extensions.dart'; // Add this import
import '../../../core/routes/app_router.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.displayNameSafe ?? "Admin"}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text('Admin Control Panel'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Manage',
              style: Theme.of(context).textTheme.titleLarge,
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
                _buildAdminTile(
                  context,
                  title: 'Therapist Management',
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () => Navigator.of(context)
                      .pushNamed(AppRouter.therapistRegistration),
                ),
                _buildAdminTile(
                  context,
                  title: 'Patient Management',
                  icon: Icons.personal_injury,
                  color: Colors.green,
                  onTap: () => Navigator.of(context)
                      .pushNamed(AppRouter.patientManagement),
                ),
                _buildAdminTile(
                  context,
                  title: 'Reports & Analytics',
                  icon: Icons.bar_chart,
                  color: Colors.orange,
                  onTap: () {/* Navigate to reports */},
                ),
                _buildAdminTile(
                  context,
                  title: 'Settings',
                  icon: Icons.settings,
                  color: Colors.purple,
                  onTap: () {/* Navigate to settings */},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
}
