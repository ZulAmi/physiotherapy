import 'dart:async';
import 'dart:math' as math; // Use dart:math instead
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/exercise_model.dart';

enum ExerciseFormQuality { good, needsImprovement, poor, unknown }

class ExerciseFeedback {
  final ExerciseFormQuality quality;
  final String message;
  final List<String> corrections;
  final double confidenceScore;
  final Map<String, double> jointAngles;

  ExerciseFeedback({
    required this.quality,
    required this.message,
    required this.corrections,
    required this.confidenceScore,
    required this.jointAngles,
  });
}

class ExerciseAssistantAI {
  CameraController? _cameraController;
  PoseDetector? _poseDetector;
  bool _isProcessing = false;
  bool _isInitialized = false;
  Exercise? _referenceExercise;
  final FlutterTts _flutterTts = FlutterTts();

  // Add getters to access private fields
  CameraController? get cameraController => _cameraController;

  Timer? _feedbackTimer;
  final StreamController<ExerciseFeedback> _feedbackStreamController =
      StreamController<ExerciseFeedback>.broadcast();

  Stream<ExerciseFeedback> get feedbackStream =>
      _feedbackStreamController.stream;
  bool get isInitialized => _isInitialized;

  // Initialize the AI assistant
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Fix the pose detector initialization
      final options = PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.base,
        // enableClassification is not available in the latest API
      );
      _poseDetector = PoseDetector(options: options);

      // Initialize text to speech
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing Exercise Assistant AI: $e');
      rethrow;
    }
  }

  // Start camera and begin monitoring
  Future<void> startMonitoring(Exercise referenceExercise) async {
    if (!_isInitialized) await initialize();

    _referenceExercise = referenceExercise;

    // Initialize camera
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    // Start camera stream processing
    _cameraController!.startImageStream(_processImage);

    // Start periodic feedback
    _feedbackTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _provideFeedback();
    });
  }

  // Process camera image frames
  Future<void> _processImage(CameraImage image) async {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: imageMetadata,
      );

      final poses = await _poseDetector!.processImage(inputImage);
      if (poses.isNotEmpty) {
        // Process the detected pose
        _analyzePose(poses.first);
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // Analyze the detected pose and compare with reference
  void _analyzePose(Pose detectedPose) {
    if (_referenceExercise == null) return;

    // Extract key joint positions and angles
    final Map<String, double> jointAngles = _calculateJointAngles(detectedPose);

    // Compare with reference exercise
    final analysisResult = _compareWithReference(jointAngles);

    // Add result to stream for UI updates
    _feedbackStreamController.add(analysisResult);
  }

  // Calculate joint angles from pose landmarks
  Map<String, double> _calculateJointAngles(Pose pose) {
    final Map<String, double> angles = {};

    try {
      final landmarks = pose.landmarks;

      // Fix the PoseLandmarkType reference by using the ML Kit version
      final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
      final leftElbow = landmarks[PoseLandmarkType.leftElbow];
      final leftWrist = landmarks[PoseLandmarkType.leftWrist];

      if (leftShoulder != null && leftElbow != null && leftWrist != null) {
        final angle = _calculateAngle(
          leftShoulder.x,
          leftShoulder.y,
          leftElbow.x,
          leftElbow.y,
          leftWrist.x,
          leftWrist.y,
        );
        angles['leftElbow'] = angle;
      }

      // Calculate other joint angles...
    } catch (e) {
      debugPrint('Error calculating joint angles: $e');
    }

    return angles;
  }

  // Calculate angle between three points
  double _calculateAngle(
    double p1x,
    double p1y,
    double p2x,
    double p2y,
    double p3x,
    double p3y,
  ) {
    // Fix Math references with dart:math
    final radians =
        math.atan2(p3y - p2y, p3x - p2x) - math.atan2(p1y - p2y, p1x - p2x);
    var angle = radians * 180 / math.pi;

    if (angle < 0) {
      angle += 360;
    }

    return angle;
  }

  // Compare detected pose with reference exercise
  ExerciseFeedback _compareWithReference(Map<String, double> jointAngles) {
    // This would contain sophisticated comparison logic
    // For this example, we'll use a simplified version

    double totalDeviation = 0;
    int comparedAngles = 0;
    List<String> corrections = [];

    // Compare each measured angle with reference values
    jointAngles.forEach((joint, angle) {
      // Get reference angle (would come from exercise model)
      final referenceAngle = _getReferenceAngle(joint);

      if (referenceAngle != null) {
        final deviation = (angle - referenceAngle).abs();
        totalDeviation += deviation;
        comparedAngles++;

        // Add correction advice if deviation is significant
        if (deviation > 15) {
          corrections.add(_getCorrectionMessage(joint, angle, referenceAngle));
        }
      }
    });

    // Calculate overall score
    double confidenceScore = 0;
    if (comparedAngles > 0) {
      final avgDeviation = totalDeviation / comparedAngles;
      confidenceScore = math.max(0, 100 - avgDeviation);
    }

    // Determine quality based on confidence
    ExerciseFormQuality quality;
    String message;

    if (confidenceScore >= 85) {
      quality = ExerciseFormQuality.good;
      message = "Great form! Keep it up.";
    } else if (confidenceScore >= 70) {
      quality = ExerciseFormQuality.needsImprovement;
      message = "Your form needs some adjustment.";
    } else {
      quality = ExerciseFormQuality.poor;
      message = "Please correct your form.";
    }

    return ExerciseFeedback(
      quality: quality,
      message: message,
      corrections: corrections,
      confidenceScore: confidenceScore,
      jointAngles: jointAngles,
    );
  }

  // Get reference angle for a specific joint
  double? _getReferenceAngle(String joint) {
    // In a real implementation, this would use the reference exercise data
    // For now, return some example values
    switch (joint) {
      case 'leftElbow':
        return 90.0; // Example: elbow should be at 90 degrees
      case 'rightElbow':
        return 90.0;
      case 'leftKnee':
        return 120.0;
      case 'rightKnee':
        return 120.0;
      default:
        return null;
    }
  }

  // Generate correction message
  String _getCorrectionMessage(String joint, double actual, double reference) {
    final bool shouldIncrease = actual < reference;

    switch (joint) {
      case 'leftElbow':
        return shouldIncrease
            ? "Bend your left arm more"
            : "Straighten your left arm a bit";
      case 'rightElbow':
        return shouldIncrease
            ? "Bend your right arm more"
            : "Straighten your right arm a bit";
      case 'leftKnee':
        return shouldIncrease
            ? "Bend your left knee more"
            : "Straighten your left leg a bit";
      case 'rightKnee':
        return shouldIncrease
            ? "Bend your right knee more"
            : "Straighten your right leg a bit";
      default:
        return "Adjust your $joint position";
    }
  }

  // Provide verbal feedback
  void _provideFeedback() {
    final corrections = _latestCorrections;
    if (corrections.isNotEmpty) {
      // Speak the first correction
      _flutterTts.speak(corrections.first);
    }
  }

  // Keep track of the latest corrections
  List<String> _latestCorrections = [];

  // Stop monitoring
  Future<void> stopMonitoring() async {
    _feedbackTimer?.cancel();

    if (_cameraController != null) {
      await _cameraController!.stopImageStream();
      await _cameraController!.dispose();
      _cameraController = null;
    }
  }

  // Dispose resources
  Future<void> dispose() async {
    await stopMonitoring();
    _poseDetector?.close();
    _feedbackStreamController.close();
    _isInitialized = false;
  }
}
