import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _QuickActionButton(
                  icon: Icons.video_call,
                  label: 'Start Video Session',
                  color: AppTheme.primaryColor,
                  onTap: () {},
                ),
                _QuickActionButton(
                  icon: Icons.assignment,
                  label: 'Assign Exercise',
                  color: Colors
                      .orange, // Replace with appropriate color from AppTheme if available
                  onTap: () {},
                ),
                _QuickActionButton(
                  icon: Icons.assessment,
                  label: 'Progress Report',
                  color: AppTheme.accentColor,
                  onTap: () {},
                ),
                _QuickActionButton(
                  icon: Icons.message,
                  label: 'Send Message',
                  color: Colors.blue,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
