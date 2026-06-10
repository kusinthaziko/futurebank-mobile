import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/data/cloudinary_service.dart';
import '../../domain/providers.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/captured_photo_preview.dart';
import '../widgets/camera_action_bar.dart';

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
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _controller = CameraController(front, ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Camera not available')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to take photo')));
      }
    }
  }

  Future<void> _upload() async {
    if (_captured == null) return;
    setState(() => _uploading = true);

    try {
      final imageUrl = await CloudinaryService.uploadImageAndGetUrl(
        _captured!.path,
      );
      if (imageUrl == null) throw Exception('Upload failed');

      if (!mounted) return;
      await ref.read(updateAvatarProvider(imageUrl).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo updated!'),
            duration: Duration(seconds: 2),
          ),
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
    final isPreview = _captured != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isPreview ? 'Preview' : 'Take Photo',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: isPreview
          ? CapturedPhotoPreview(
              imagePath: _captured!.path,
              uploading: _uploading,
              onRetake: () => setState(() => _captured = null),
              onConfirm: _upload,
            )
          : CameraViewfinder(controller: _controller),
      bottomNavigationBar: isPreview
          ? null
          : CameraActionBar(onCapture: _capture),
    );
  }
}
