import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';

/// Bottom bar that shows either a capture button or retake/confirm buttons.
class CameraActionBar extends StatelessWidget {
  final bool isPreview;
  final bool uploading;
  final VoidCallback? onCapture;
  final VoidCallback? onRetake;
  final VoidCallback? onConfirm;

  const CameraActionBar({
    super.key,
    this.isPreview = false,
    this.uploading = false,
    this.onCapture,
    this.onRetake,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isPreview) _buildPreviewActions() else _buildCaptureButton(),
        ],
      ),
    );
  }

  Widget _buildPreviewActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white, size: 32),
          onPressed: onRetake,
          tooltip: 'Retake',
        ),
        const SizedBox(width: sp32),
        uploading
            ? const SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : GestureDetector(
                onTap: onConfirm,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: primary500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 28),
                ),
              ),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: onCapture,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.camera_alt, color: Colors.black, size: 32),
      ),
    );
  }
}
