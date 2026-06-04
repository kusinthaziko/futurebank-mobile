import 'dart:io';
import 'package:flutter/services.dart';

class SecurityService {
  static const _autoLockDuration = Duration(minutes: 5);

  DateTime? _lastActiveTime;
  bool _screenshotPreventionEnabled = false;

  bool get isAutoLockDue {
    if (_lastActiveTime == null) return false;
    return DateTime.now().difference(_lastActiveTime!) >= _autoLockDuration;
  }

  void markActive() {
    _lastActiveTime = DateTime.now();
  }

  Future<void> enableScreenshotPrevention() async {
    if (_screenshotPreventionEnabled) return;
    if (!Platform.isAndroid) return;

    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      _screenshotPreventionEnabled = true;
    } catch (_) {}
  }

  Future<void> disableScreenshotPrevention() async {
    if (!_screenshotPreventionEnabled) return;
    if (!Platform.isAndroid) return;

    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      _screenshotPreventionEnabled = false;
    } catch (_) {}
  }
}
