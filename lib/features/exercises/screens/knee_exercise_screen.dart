import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import '../providers/exercise_provider.dart';
import '../models/knee_exercise_type.dart';
import '../models/knee_biomechanics.dart';
import '../services/knee_exercise_analyzer.dart';
import '../widgets/knee_angle_visualizer.dart';
import '../widgets/biomechanics_data_display.dart';
import '../../llm/services/llama_service.dart';

class KneeExerciseScreen extends StatefulWidget {
  final KneeExerciseType exerciseType;

  const KneeExerciseScreen({
    super.key,
    required this.exerciseType,
  });

  @override
  State<KneeExerciseScreen> createState() => _KneeExerciseScreenState();
}

class _KneeExerciseScreenState extends State<KneeExerciseScreen> {
  final PoseDetector _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
    mode: PoseDetectionMode.stream,
    detectorType: PoseDetectorType.pose3d,
  ));

  final KneeExerciseAnalyzer _exerciseAnalyzer = KneeExerciseAnalyzer();
  final LlamaService _llamaService = LlamaService(
    baseUrl: 'http://your-server-ip:8000', // Update with your server address
  );

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessingFrame = false;
  bool _isExerciseActive = false;
  bool _isLegSelectorVisible = true;
  bool _isRightLeg = true;

  KneeBiomechanics? _currentBiomechanics;
  List<KneeBiomechanics> _biomechanicsSequence = [];
  List<String> _feedbackMessages = [];
  int _repCount = 0;
  int _setCount = 0;
  int _targetReps = 10;
  int _targetSets = 3;

  String _aiGeneratedFeedback = '';
  bool _isGeneratingFeedback = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _poseDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });

        _cameraController!.startImageStream(_processCameraImage);
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessingFrame) return;

    _isProcessingFrame = true;

    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) {
        _isProcessingFrame = false;
        return;
      }

      final poses = await _poseDetector.processImage(inputImage);

      if (poses.isNotEmpty && _isExerciseActive) {
        // Analyze the first detected pose
        final biomechanics = _exerciseAnalyzer.analyzeFrame(
          poses.first,
          widget.exerciseType,
          _isRightLeg,
        );

        // Save biomechanics data
        _biomechanicsSequence.add(biomechanics);

        // Track repetitions
        if (_biomechanicsSequence.length > 1) {
          bool isNewRep = _exerciseAnalyzer.detectRepetition(
              _biomechanicsSequence[_biomechanicsSequence.length - 2],
              biomechanics,
              widget.exerciseType);

          if (isNewRep) {
            setState(() {
              _repCount++;

              // Check if set is complete
              if (_repCount >= _targetReps) {
                _setCount++;
                _repCount = 0;

                if (_setCount >= _targetSets) {
                  _stopExercise();
                }
              }
            });
          }
        }

        if (mounted) {
          setState(() {
            _currentBiomechanics = biomechanics;
          });
        }
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  // Fixed camera image conversion to handle both Android and iOS
  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    try {
      // Get camera rotation
      final camera = _cameraController!.description;
      final sensorOrientation = camera.sensorOrientation;

      // Based on platform, create the appropriate InputImage
      if (Platform.isAndroid) {
        return InputImage.fromBytes(
          bytes: _concatenatePlanes(image.planes),
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: _rotationIntToImageRotation(sensorOrientation),
            format: InputImageFormat.yuv420,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      } else if (Platform.isIOS) {
        return InputImage.fromBytes(
          bytes: image.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: _rotationIntToImageRotation(sensorOrientation),
            format: InputImageFormat.bgra8888,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      }
    } catch (e) {
      print('Error converting camera image: $e');
    }
    return null;
  }

  // Helper methods for image conversion
  Uint8List _concatenatePlanes(List<CameraImagePlane> planes) {
    final allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  void _startExercise() {
    setState(() {
      _isExerciseActive = true;
      _isLegSelectorVisible = false;
      _biomechanicsSequence = [];
      _feedbackMessages = [];
      _repCount = 0;
      _setCount = 0;
    });
  }

  void _stopExercise() {
    setState(() {
      _isExerciseActive = false;

      // Generate feedback based on the collected sequence
      _feedbackMessages = _exerciseAnalyzer.generateFeedback(
        _biomechanicsSequence,
        widget.exerciseType,
      );

      // Add summary feedback
      _feedbackMessages
          .add('Completed $_setCount sets of $_repCount repetitions.');
    });
  }

  Future<void> _generateAIFeedback() async {
    if (_currentBiomechanics == null) return;

    setState(() {
      _isGeneratingFeedback = true;
    });

    // Get current joint angles
    final kneeAngle = _currentBiomechanics!.kneeAngle;
    final hipAngle = _currentBiomechanics!.hipAngle;
    final ankleAngle = _currentBiomechanics!.ankleAngle;

    final angles = {
      'knee': kneeAngle,
      'hip': hipAngle,
      'ankle': ankleAngle,
    };

    try {
      final feedback = await _llamaService.generateFeedback(
        widget.exerciseType.name,
        angles,
      );

      setState(() {
        _aiGeneratedFeedback = feedback;
        _isGeneratingFeedback = false;
      });
    } catch (e) {
      setState(() {
        _aiGeneratedFeedback = 'Failed to generate feedback.';
        _isGeneratingFeedback = false;
      });
    }
  }

  Widget _buildAIFeedback() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purple),
              const SizedBox(width: 8),
              const Text(
                'AI Feedback',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _isGeneratingFeedback ? null : _generateAIFeedback,
              ),
            ],
          ),
          const Divider(),
          if (_isGeneratingFeedback)
            const Center(child: CircularProgressIndicator())
          else if (_aiGeneratedFeedback.isEmpty)
            const Text('Tap refresh to generate AI feedback on your form.')
          else
            Text(_aiGeneratedFeedback),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseType.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showExerciseInstructions(context);
            },
          ),
        ],
      ),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      // Camera preview
                      Center(
                        child: CameraPreview(_cameraController!),
                      ),

                      // Overlay for knee angle visualization
                      if (_currentBiomechanics != null && _isExerciseActive)
                        KneeAngleVisualizer(
                          flexionAngle: _currentBiomechanics!.flexionAngle,
                          valgusAngle: _currentBiomechanics!.valgusAngle,
                          isRightLeg: _isRightLeg,
                        ),

                      // Leg selector overlay
                      if (_isLegSelectorVisible)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Which leg are you exercising?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isRightLeg = true;
                                          _isLegSelectorVisible = false;
                                        });
                                      },
                                      child: const Text('Right Leg'),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isRightLeg = false;
                                          _isLegSelectorVisible = false;
                                        });
                                      },
                                      child: const Text('Left Leg'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Exercise counters
                      if (_isExerciseActive)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Set: ${_setCount + 1}/$_targetSets',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rep: $_repCount/$_targetReps',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Biomechanics data display
                Expanded(
                  flex: 2,
                  child: _currentBiomechanics != null
                      ? BiomechanicsDataDisplay(
                          biomechanics: _currentBiomechanics!,
                          exerciseType: widget.exerciseType,
                        )
                      : const Center(
                          child: Text('No biomechanics data available yet'),
                        ),
                ),

                // Feedback section
                if (_feedbackMessages.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Exercise Feedback:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          _feedbackMessages.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(fontSize: 18)),
                                Expanded(
                                  child: Text(
                                    _feedbackMessages[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // AI Feedback section
                _buildAIFeedback(),

                // Control buttons
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!_isLegSelectorVisible && !_isExerciseActive)
                        ElevatedButton.icon(
                          onPressed: _startExercise,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Exercise'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      if (_isExerciseActive)
                        ElevatedButton.icon(
                          onPressed: _stopExercise,
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop Exercise'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      if (_feedbackMessages.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {
                            // Save exercise data to the provider
                            final exerciseProvider =
                                Provider.of<ExerciseProvider>(context,
                                    listen: false);
                            exerciseProvider.saveExerciseSession(
                              widget.exerciseType,
                              _isRightLeg,
                              _biomechanicsSequence,
                              _feedbackMessages,
                            );

                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save & Exit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _showExerciseInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.exerciseType.displayName} Instructions'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getExerciseInstructions(widget.exerciseType),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tips for Success:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _getExerciseTips(widget.exerciseType),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getExerciseInstructions(KneeExerciseType exerciseType) {
    switch (exerciseType) {
      case KneeExerciseType.squat:
        return 'Stand with feet shoulder-width apart. Bend your knees and lower your body as if sitting in a chair. Keep your back straight and knees behind your toes. Return to starting position.';
      case KneeExerciseType.legRaise:
        return 'Lie on your back with one leg straight and the other bent with foot flat on the floor. Slowly raise the straight leg to about 45 degrees, hold for 3 seconds, then lower it back down.';
      case KneeExerciseType.stepUp:
        return 'Stand in front of a step or stable platform. Step up with one foot, then the other. Step down with the first foot, then the second. Repeat, leading with the same foot for the set.';
      default:
        return 'Follow the on-screen guidance and ensure your form is correct throughout the exercise.';
    }
  }

  String _getExerciseTips(KneeExerciseType exerciseType) {
    switch (exerciseType) {
      case KneeExerciseType.squat:
        return '• Keep your weight in your heels\n• Keep your chest up and shoulders back\n• Don\'t let your knees collapse inward\n• Breathe out as you rise up';
      case KneeExerciseType.legRaise:
        return '• Keep your core engaged\n• Don\'t arch your back\n• Move slowly and controlled\n• Keep the working leg straight but not locked';
      case KneeExerciseType.stepUp:
        return '• Use a height appropriate for your ability\n• Keep your core engaged\n• Push through your heel, not your toes\n• Keep your knee aligned with your second toe';
      default:
        return '• Focus on proper form over speed\n• Stop if you feel sharp pain\n• Breathe naturally throughout the exercise';
    }
  }
}
