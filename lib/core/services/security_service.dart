import 'dart:io';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SecurityService {
  static const _autoLockDuration = Duration(minutes: 5);

  DateTime? _lastActiveTime;
  int _secureFlagCount = 0;

  bool get isAutoLockDue {
    if (_lastActiveTime == null) return false;
    return DateTime.now().difference(_lastActiveTime!) >= _autoLockDuration;
  }

  void markActive() {
    _lastActiveTime = DateTime.now();
  }

  /// Enables screenshot prevention. Uses reference counting so multiple
  /// screens can independently enable/disable without conflicts.
  Future<void> enableScreenshotPrevention() async {
    _secureFlagCount++;
    if (_secureFlagCount > 1 || !Platform.isAndroid) return;

    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (_) {}
  }

  /// Disables screenshot prevention when the last screen releases it.
  Future<void> disableScreenshotPrevention() async {
    _secureFlagCount--;
    if (_secureFlagCount > 0 || !Platform.isAndroid) return;

    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (_) {}
  }

  /// Forces screenshot prevention off (for logout).
  Future<void> resetScreenshotPrevention() async {
    _secureFlagCount = 0;
    if (!Platform.isAndroid) return;
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (_) {}
  }
}
