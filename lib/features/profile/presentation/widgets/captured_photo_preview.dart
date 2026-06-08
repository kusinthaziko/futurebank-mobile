import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import 'camera_action_bar.dart';

/// Shows the captured photo preview with retake and confirm buttons below.
class CapturedPhotoPreview extends StatelessWidget {
  final String imagePath;
  final bool uploading;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;

  const CapturedPhotoPreview({
    super.key,
    required this.imagePath,
    required this.uploading,
    required this.onRetake,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(sp24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        CameraActionBar(
          isPreview: true,
          uploading: uploading,
          onCapture: null,
          onRetake: onRetake,
          onConfirm: onConfirm,
        ),
      ],
    );
  }
}
