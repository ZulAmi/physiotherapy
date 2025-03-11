import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../../../core/theme/app_theme.dart';

class ExercisePlanCard extends StatefulWidget {
  final Patient patient;

  const ExercisePlanCard({
    super.key,
    required this.patient,
  });

  @override
  State<ExercisePlanCard> createState() => _ExercisePlanCardState();
}

class _ExercisePlanCardState extends State<ExercisePlanCard> {
  bool _isExpanded = false;

  // Mock data for the exercise plan
  final List<Map<String, dynamic>> _exercisePlan = [
    {
      'id': 'ex1',
      'name': 'Shoulder Rotation',
      'frequency': '3x per week',
      'sets': 3,
      'reps': 10,
      'compliance': 0.85,
      'image': 'shoulder_rotation.jpg',
    },
    {
      'id': 'ex2',
      'name': 'Knee Flexion',
      'frequency': 'Daily',
      'sets': 2,
      'reps': 15,
      'compliance': 0.72,
      'image': 'knee_flexion.jpg',
    },
    {
      'id': 'ex3',
      'name': 'Back Extension',
      'frequency': '2x per week',
      'sets': 2,
      'reps': 8,
      'compliance': 0.93,
      'image': 'back_extension.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCardHeader(context),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: _exercisePlan.isEmpty
                  ? _buildEmptyPlaceholder()
                  : _buildExerciseList(context),
            ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.fitness_center, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercise Plan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (!_isExpanded)
                    Text(
                      '${_exercisePlan.length} exercises assigned',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            if (!_isExpanded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '83% Adherence',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    return Column(
      children: _exercisePlan
          .map((exercise) => _buildExerciseItem(context, exercise))
          .toList(),
    );
  }

  Widget _buildExerciseItem(
      BuildContext context, Map<String, dynamic> exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          exercise['name'],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Frequency: ${exercise['frequency']}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 40,
            height: 40,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.image,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        trailing: _buildComplianceIndicator(context, exercise['compliance']),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildExerciseDetailRow(
                  context,
                  'Sets',
                  exercise['sets'].toString(),
                  Icons.repeat,
                ),
                const SizedBox(height: 8),
                _buildExerciseDetailRow(
                  context,
                  'Repetitions',
                  exercise['reps'].toString(),
                  Icons.loop,
                ),
                const SizedBox(height: 16),
                _buildExerciseProgress(context, exercise['compliance']),
                const SizedBox(height: 16),
                _buildExerciseActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseProgress(BuildContext context, double compliance) {
    Color progressColor;
    if (compliance >= 0.8) {
      progressColor = AppTheme.successColor;
    } else if (compliance >= 0.6) {
      progressColor = AppTheme.warningColor;
    } else {
      progressColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compliance Rate',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: compliance,
                  backgroundColor: Colors.grey.shade200,
                  color: progressColor,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(compliance * 100).toInt()}%',
              style: TextStyle(
                color: progressColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComplianceIndicator(BuildContext context, double compliance) {
    Color color;
    IconData icon;

    if (compliance >= 0.8) {
      color = AppTheme.successColor;
      icon = Icons.check_circle;
    } else if (compliance >= 0.6) {
      color = AppTheme.warningColor;
      icon = Icons.warning;
    } else {
      color = Colors.red;
      icon = Icons.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '${(compliance * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            // View exercise details
          },
          icon: const Icon(Icons.visibility, size: 18),
          label: const Text('View Details'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            // Modify exercise
          },
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Modify'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises assigned',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Assign exercises to create a treatment plan',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Handle assign exercise
            },
            icon: const Icon(Icons.add),
            label: const Text('Assign Exercise'),
          ),
        ],
      ),
    );
  }
}
