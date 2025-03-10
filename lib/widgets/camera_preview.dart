import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CustomCameraPreview extends StatelessWidget {
  final CameraController controller;

  const CustomCameraPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraPreview(controller),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
            ),
          ),
        ),
        const Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Align yourself within the frame',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
