import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/exercise_assistant_ai.dart';
import '../models/exercise_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ExerciseMonitoringScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseMonitoringScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  _ExerciseMonitoringScreenState createState() =>
      _ExerciseMonitoringScreenState();
}

class _ExerciseMonitoringScreenState extends State<ExerciseMonitoringScreen> {
  final ExerciseAssistantAI _exerciseAI = ExerciseAssistantAI();
  bool _isInitializing = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  Future<void> _initializeAI() async {
    setState(() => _isInitializing = true);

    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status.isGranted) {
        await _exerciseAI.initialize();
        await _exerciseAI.startMonitoring(widget.exercise);
      } else {
        setState(() {
          _errorMessage =
              'Camera permission is required for exercise monitoring';
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  @override
  void dispose() {
    _exerciseAI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise: ${widget.exercise.name}'),
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _buildExerciseMonitor(),
    );
  }

  Widget _buildExerciseMonitor() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _buildCameraPreview(),
        ),
        Expanded(
          flex: 2,
          child: _buildFeedbackPanel(),
        ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    if (_exerciseAI._cameraController == null ||
        !_exerciseAI._cameraController!.value.isInitialized) {
      return const Center(child: Text('Initializing camera...'));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_exerciseAI._cameraController!),
        // Overlay to show pose landmarks (in a real implementation)
        StreamBuilder<ExerciseFeedback>(
          stream: _exerciseAI.feedbackStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            // This would be a custom paint to draw the skeleton
            return CustomPaint(
              painter: PosePainter(feedback: snapshot.data!),
              child: const SizedBox.expand(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeedbackPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: StreamBuilder<ExerciseFeedback>(
        stream: _exerciseAI.feedbackStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Waiting for feedback...'));
          }

          final feedback = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildQualityIndicator(feedback.quality),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedback.message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Score: ${feedback.confidenceScore.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            color: _getScoreColor(feedback.confidenceScore),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Suggestions:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: feedback.corrections.isEmpty
                    ? const Text('Keep up the good work!')
                    : ListView.builder(
                        itemCount: feedback.corrections.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.adjust, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(feedback.corrections[index]),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQualityIndicator(ExerciseFormQuality quality) {
    IconData icon;
    Color color;

    switch (quality) {
      case ExerciseFormQuality.good:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case ExerciseFormQuality.needsImprovement:
        icon = Icons.info;
        color = Colors.orange;
        break;
      case ExerciseFormQuality.poor:
        icon = Icons.warning;
        color = Colors.red;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }
}

// Custom painter to show pose skeleton (simplified)
class PosePainter extends CustomPainter {
  final ExerciseFeedback feedback;

  PosePainter({required this.feedback});

  @override
  void paint(Canvas canvas, Size size) {
    // In a real implementation, this would draw lines between
    // the detected joint positions to visualize the pose
    // For simplicity, this is left as a placeholder
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
