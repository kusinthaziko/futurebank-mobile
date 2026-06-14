import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Renders the live camera preview or a loading spinner while initializing.
class CameraViewfinder extends StatelessWidget {
  final CameraController? controller;

  const CameraViewfinder({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Center(
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      ),
    );
  }
}
