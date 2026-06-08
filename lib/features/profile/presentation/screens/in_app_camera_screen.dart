import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../features/auth/data/cloudinary_service.dart';
import '../../domain/providers.dart';

class InAppCameraScreen extends ConsumerStatefulWidget {
  const InAppCameraScreen({super.key});

  @override
  ConsumerState<InAppCameraScreen> createState() => _InAppCameraScreenState();
}

class _InAppCameraScreenState extends ConsumerState<InAppCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  XFile? _captured;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.resumed) {
      _controller?.resumePreview();
    } else if (state == AppLifecycleState.inactive) {
      _controller?.pausePreview();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) Navigator.pop(context);
        return;
      }
      // Prefer front camera for selfies
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _controller = CameraController(front, ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not available')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _capture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final file = await _controller!.takePicture();
      setState(() => _captured = file);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to take photo')),
        );
      }
    }
  }

  Future<void> _upload() async {
    if (_captured == null) return;
    setState(() => _uploading = true);

    try {
      final imageUrl = await CloudinaryService.uploadImageAndGetUrl(_captured!.path);
      if (imageUrl == null) throw Exception('Upload failed');

      if (!mounted) return;
      await ref.read(updateAvatarProvider(imageUrl).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo updated!'), duration: Duration(seconds: 2)),
        );
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload failed. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _captured != null ? 'Preview' : 'Take Photo',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _captured != null ? _buildPreview() : _buildCamera(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCamera() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: CameraPreview(_controller!),
      ),
    );
  }

  Widget _buildPreview() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(sp24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(File(_captured!.path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: const Icon(Icons.refresh, color: Colors.white, size: 32),
        onPressed: () => setState(() => _captured = null),
        tooltip: 'Retake',
      ),
      const SizedBox(width: sp32),
      _uploading
          ? const SizedBox(
              width: 56, height: 56,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : GestureDetector(
              onTap: _upload,
              child: Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(
                  color: primary500, shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 28),
              ),
            ),
    ]);
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _capture,
      child: Container(
        width: 72, height: 72,
        decoration: const BoxDecoration(
          color: Colors.white, shape: BoxShape.circle,
        ),
        child: const Icon(Icons.camera_alt, color: Colors.black, size: 32),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.black,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _captured != null ? _buildButtons() : _buildCaptureButton(),
        ],
      ),
    );
  }
}
