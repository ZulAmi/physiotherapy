import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/progress_service.dart';
import '../widgets/progress_summary_card.dart';

class ProgressReportScreen extends StatelessWidget {
  final String patientId;
  final String exerciseId;

  const ProgressReportScreen({
    super.key,
    required this.patientId,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context) {
    final progressService = ProgressService();

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Progress')),
      body: StreamBuilder<QuerySnapshot>(
        stream: progressService.getExerciseProgress(patientId, exerciseId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading progress'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final progressData = snapshot.data!.docs;
          final accuracyPoints = progressData
              .map(
                (doc) => FlSpot(
                  doc['timestamp'].toDate().millisecondsSinceEpoch.toDouble(),
                  doc['accuracy'].toDouble(),
                ),
              )
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [LineChartBarData(spots: accuracyPoints)],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt(),
                              );
                              return Text(
                                '${date.day}/${date.month}',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProgressSummaryCard(progressData: progressData),
              ],
            ),
          );
        },
      ),
    );
  }
}
