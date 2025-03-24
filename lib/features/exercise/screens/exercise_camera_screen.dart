import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:typed_data';
import 'dart:io';
import '../models/exercise_model.dart';
import '../services/pose_analyzer.dart';

class ExerciseCameraScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCameraScreen({Key? key, required this.exercise})
      : super(key: key);

  @override
  _ExerciseCameraScreenState createState() => _ExerciseCameraScreenState();
}

class _ExerciseCameraScreenState extends State<ExerciseCameraScreen> {
  CameraController? _cameraController;
  PoseDetector? _poseDetector;
  PoseAnalyzer _poseAnalyzer = PoseAnalyzer();

  bool _isProcessing = false;
  List<Pose>? _poses;
  ExerciseAnalysisResult? _analysisResult;

  @override
  void initState() {
    super.initState();
    _initializeDetector();
    _initializeCamera();
  }

  Future<void> _initializeDetector() async {
    _poseDetector = GoogleMlKit.vision.poseDetector(
      poseDetectorOptions: PoseDetectorOptions(
        model: PoseDetectionModel.base,
        mode: PoseDetectionMode.stream,
      ),
    );
  }

  Future<void> _initializeCamera() async {
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

    if (mounted) {
      setState(() {});
      _cameraController!.startImageStream(_processImage);
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      // Get camera rotation
      final camera = _cameraController?.description;
      final sensorOrientation = camera?.sensorOrientation ?? 0;

      // Create InputImage using the newer ML Kit API
      InputImage? inputImage;

      // Different method based on platform (Android vs iOS)
      if (Platform.isAndroid) {
        inputImage = InputImage.fromBytes(
          bytes: _concatenatePlanes(image.planes),
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: _getInputImageRotation(sensorOrientation),
            format: InputImageFormat.nv21,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      } else {
        // For iOS
        inputImage = InputImage.fromBytes(
          bytes: image.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: _getInputImageRotation(sensorOrientation),
            format: InputImageFormat.bgra8888,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      }

      if (inputImage == null) return;

      // Process the image with ML Kit
      final poses = await _poseDetector!.processImage(inputImage);

      if (poses.isNotEmpty) {
        final result = _poseAnalyzer.analyzeExercise(widget.exercise, poses);

        if (mounted) {
          setState(() {
            _poses = poses;
            _analysisResult = result;
          });
        }
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  // Helper method to concatenate image planes
  Uint8List _concatenatePlanes(List<Plane> planes) {
    // Calculate total bytes needed
    int totalSize = 0;
    for (final plane in planes) {
      totalSize += plane.bytes.length;
    }

    // Create a new Uint8List with the combined size
    final allBytes = Uint8List(totalSize);

    // Copy all bytes from each plane
    int offset = 0;
    for (final plane in planes) {
      allBytes.setRange(offset, offset + plane.bytes.length, plane.bytes);
      offset += plane.bytes.length;
    }

    return allBytes;
  }

  // Helper to get correct rotation
  InputImageRotation _getInputImageRotation(int sensorOrientation) {
    // Convert from device orientation to image rotation
    switch (sensorOrientation) {
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

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: Stack(
        children: [
          // Camera preview
          CameraPreview(_cameraController!),

          // Pose overlay (optional)
          if (_poses != null) _buildPoseOverlay(),

          // Feedback display
          if (_analysisResult != null) _buildFeedbackOverlay(),

          // Exercise info
          _buildExerciseInfoOverlay(),
        ],
      ),
    );
  }

  Widget _buildPoseOverlay() {
    return CustomPaint(
      painter: PosePainter(
        poses: _poses!,
        imageSize: Size(
          _cameraController!.value.previewSize!.height,
          _cameraController!.value.previewSize!.width,
        ),
      ),
    );
  }

  Widget _buildFeedbackOverlay() {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: _analysisResult!.isCorrectForm
              ? Colors.green.withOpacity(0.8)
              : Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _analysisResult!.feedback,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _getAngleText(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfoOverlay() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.exercise.description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getAngleText() {
    final angles = _analysisResult!.jointAngles;
    if (angles.isEmpty) return "No angles detected";

    return angles.entries
        .map((e) =>
            "${e.key.toString().split('.').last}: ${e.value.toStringAsFixed(1)}°")
        .join(" | ");
  }
}

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;

  PosePainter({required this.poses, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.blue;

    for (final pose in poses) {
      // Draw the pose landmarks
      pose.landmarks.forEach((type, landmark) {
        final position = _scalePosition(
          Offset(landmark.x, landmark.y),
          size,
        );
        canvas.drawCircle(position, 5, paint);
      });

      // Draw connections between landmarks
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftShoulder,
          PoseLandmarkType.leftElbow);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftElbow,
          PoseLandmarkType.leftWrist);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftShoulder,
          PoseLandmarkType.leftHip);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftHip,
          PoseLandmarkType.leftKnee);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftKnee,
          PoseLandmarkType.leftAnkle);

      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.rightShoulder,
          PoseLandmarkType.rightElbow);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.rightElbow,
          PoseLandmarkType.rightWrist);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.rightShoulder,
          PoseLandmarkType.rightHip);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.rightHip,
          PoseLandmarkType.rightKnee);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.rightKnee,
          PoseLandmarkType.rightAnkle);

      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftShoulder,
          PoseLandmarkType.rightShoulder);
      _drawConnection(canvas, pose, size, paint, PoseLandmarkType.leftHip,
          PoseLandmarkType.rightHip);
    }
  }

  void _drawConnection(Canvas canvas, Pose pose, Size size, Paint paint,
      PoseLandmarkType from, PoseLandmarkType to) {
    final landmarks = pose.landmarks;
    if (landmarks.containsKey(from) && landmarks.containsKey(to)) {
      final fromPosition = _scalePosition(
        Offset(landmarks[from]!.x, landmarks[from]!.y),
        size,
      );
      final toPosition = _scalePosition(
        Offset(landmarks[to]!.x, landmarks[to]!.y),
        size,
      );
      canvas.drawLine(fromPosition, toPosition, paint);
    }
  }

  Offset _scalePosition(Offset position, Size size) {
    return Offset(
      position.dx * size.width / imageSize.width,
      position.dy * size.height / imageSize.height,
    );
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => true;
}
