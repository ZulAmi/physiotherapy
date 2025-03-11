import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../features/pose_detection/services/pose_detection_service.dart';
import '../../../features/progress/services/progress_service.dart';
import '../models/exercise_model.dart';

class ExerciseCameraScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCameraScreen({super.key, required this.exercise});

  @override
  State<ExerciseCameraScreen> createState() => _ExerciseCameraScreenState();
}

class _ExerciseCameraScreenState extends State<ExerciseCameraScreen> {
  late CameraController _cameraController;
  late PoseDetectionService _poseDetectionService;
  late ProgressService _progressService;
  bool _isDetecting = false;
  double _currentAccuracy = 0.0;
  int _currentRep = 0;
  int _currentSet = 0;
  final Stopwatch _exerciseTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _poseDetectionService = PoseDetectionService();
    _progressService = ProgressService();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
      _startImageStream();
    }
  }

  void _startImageStream() {
    _cameraController.startImageStream((image) async {
      if (_isDetecting) return;

      _isDetecting = true;
      try {
        final poses = await _poseDetectionService.detectPose(image);
        if (poses.isNotEmpty) {
          final accuracy = _poseDetectionService.calculateExerciseAccuracy(
            poses.first,
            widget.exercise.targetPose,
          );

          setState(() {
            _currentAccuracy = accuracy;
            if (accuracy > 85) {
              _currentRep++;
              if (_currentRep >= widget.exercise.repetitionsPerSet) {
                _currentSet++;
                _currentRep = 0;
                if (_currentSet >= widget.exercise.setsPerDay) {
                  _completeExercise();
                }
              }
            }
          });
        }
      } finally {
        _isDetecting = false;
      }
    });
  }

  Future<void> _completeExercise() async {
    _exerciseTimer.stop();
    await _progressService.saveExerciseProgress(
      patientId: context.read<AuthProvider>().user!.id,
      exerciseId: widget.exercise.id,
      accuracy: _currentAccuracy,
      repetitions: _currentRep,
      sets: _currentSet,
      duration: _exerciseTimer.elapsed,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseCompletionScreen(
            exercise: widget.exercise,
            accuracy: _currentAccuracy,
            duration: _exerciseTimer.elapsed,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _poseDetectionService.dispose();
    _exerciseTimer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(_cameraController),
                  CustomPaint(
                    painter: PoseOverlayPainter(
                      accuracy: _currentAccuracy,
                      reps: _currentRep,
                      sets: _currentSet,
                    ),
                  ),
                ],
              ),
            ),
            ExerciseProgressBar(
              accuracy: _currentAccuracy,
              currentRep: _currentRep,
              totalReps: widget.exercise.repetitionsPerSet,
              currentSet: _currentSet,
              totalSets: widget.exercise.setsPerDay,
            ),
          ],
        ),
      ),
    );
  }
}
