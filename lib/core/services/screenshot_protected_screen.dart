import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/security_provider.dart';

/// Wraps a child widget with screenshot prevention.
/// Enables FLAG_SECURE on Android when mounted, disables when disposed.
/// Uses reference counting so nested protected screens work correctly.
class ScreenshotProtectedScreen extends ConsumerStatefulWidget {
  final Widget child;

  const ScreenshotProtectedScreen({super.key, required this.child});

  @override
  ConsumerState<ScreenshotProtectedScreen> createState() =>
      _ScreenshotProtectedScreenState();
}

class _ScreenshotProtectedScreenState
    extends ConsumerState<ScreenshotProtectedScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(securityServiceProvider).enableScreenshotPrevention();
  }

  @override
  void dispose() {
    ref.read(securityServiceProvider).disableScreenshotPrevention();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
