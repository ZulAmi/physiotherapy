import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionService {
  final _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      modelType: PoseDetectionModel.accurate,
    ),
  );

  bool _isBusy = false;

  Future<PoseDetectionResult?> processCameraImage(CameraImage image) async {
    if (_isBusy) return null;
    _isBusy = true;

    try {
      final poses = await _detectPose(image);
      if (poses.isEmpty) return null;

      return PoseDetectionResult(
        pose: poses.first,
        confidence: _calculateConfidence(poses.first),
      );
    } finally {
      _isBusy = false;
    }
  }

  Future<List<Pose>> _detectPose(CameraImage image) async {
    final inputImage = InputImage.fromBytes(
      bytes: _concatenatePlanes(image.planes),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.bgra8888,
        planeData: image.planes.map((plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: image.height,
            width: image.width,
          );
        }).toList(),
      ),
    );

    return await _poseDetector.processImage(inputImage);
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  double _calculateConfidence(Pose pose) {
    int visibleLandmarks = 0;
    double totalConfidence = 0;

    for (final landmark in pose.landmarks.values) {
      if (landmark.likelihood > 0.5) {
        visibleLandmarks++;
        totalConfidence += landmark.likelihood;
      }
    }

    return visibleLandmarks > 0
        ? (totalConfidence / visibleLandmarks) * 100
        : 0;
  }

  void dispose() {
    _poseDetector.close();
  }
}

class PoseDetectionResult {
  final Pose pose;
  final double confidence;

  PoseDetectionResult({
    required this.pose,
    required this.confidence,
  });
}
