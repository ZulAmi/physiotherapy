import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProgressSummaryCard extends StatelessWidget {
  final List<QueryDocumentSnapshot> progressData;

  const ProgressSummaryCard({
    super.key,
    required this.progressData,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = _calculateMetrics();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricBox(
                  icon: Icons.trending_up,
                  color: Colors.green,
                  title: 'Best Accuracy',
                  value: '${metrics['bestAccuracy'].toStringAsFixed(1)}%',
                ),
                _MetricBox(
                  icon: Icons.show_chart,
                  color: Colors.blue,
                  title: 'Average Accuracy',
                  value: '${metrics['avgAccuracy'].toStringAsFixed(1)}%',
                ),
                _MetricBox(
                  icon: Icons.calendar_today,
                  color: Colors.orange,
                  title: 'Sessions',
                  value: metrics['totalSessions'].toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimelineProgress(context, metrics['lastSessionDate']),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateMetrics() {
    if (progressData.isEmpty) {
      return {
        'bestAccuracy': 0.0,
        'avgAccuracy': 0.0,
        'totalSessions': 0,
        'lastSessionDate': DateTime.now(),
      };
    }

    double totalAccuracy = 0;
    double bestAccuracy = 0;

    for (var doc in progressData) {
      final accuracy = doc['accuracy'] as double;
      totalAccuracy += accuracy;
      if (accuracy > bestAccuracy) bestAccuracy = accuracy;
    }

    return {
      'bestAccuracy': bestAccuracy,
      'avgAccuracy': totalAccuracy / progressData.length,
      'totalSessions': progressData.length,
      'lastSessionDate': progressData.first['timestamp'].toDate(),
    };
  }

  Widget _buildTimelineProgress(BuildContext context, DateTime lastSession) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Last session: ${DateFormat('EEEE, MMMM d').format(lastSession)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _MetricBox({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
