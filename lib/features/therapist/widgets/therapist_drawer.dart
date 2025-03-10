import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/drawer_list_tile.dart';

class TherapistDrawer extends StatelessWidget {
  const TherapistDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.name ?? 'Doctor'),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (user.name?[0] ?? 'D').toUpperCase(),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerListTile(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () => Navigator.pop(context),
                ),
                DrawerListTile(
                  icon: Icons.people,
                  title: 'Patients',
                  onTap: () => _navigateTo(context, '/patients'),
                ),
                DrawerListTile(
                  icon: Icons.calendar_today,
                  title: 'Appointments',
                  onTap: () => _navigateTo(context, '/appointments'),
                ),
                DrawerListTile(
                  icon: Icons.fitness_center,
                  title: 'Exercise Library',
                  onTap: () => _navigateTo(context, '/exercises'),
                ),
                DrawerListTile(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  onTap: () => _navigateTo(context, '/analytics'),
                ),
                const Divider(),
                DrawerListTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => _navigateTo(context, '/settings'),
                ),
                DrawerListTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () => _navigateTo(context, '/support'),
                ),
                const Divider(),
                DrawerListTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
