import 'dart:io';
import 'package:flutter/services.dart';

class SecurityService {
  static const _channel = MethodChannel('com.futurebank.app/window');
  static const _autoLockDuration = Duration(minutes: 5);

  DateTime? _lastActiveTime;
  int _secureFlagCount = 0;

  bool get isAutoLockDue {
    if (_lastActiveTime == null) return false;
    return DateTime.now().difference(_lastActiveTime!) >= _autoLockDuration;
  }

  void markActive() => _lastActiveTime = DateTime.now();

  Future<void> enableScreenshotPrevention() async {
    _secureFlagCount++;
    if (_secureFlagCount > 1 || !Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('addFlagSecure');
    } catch (_) {}
  }

  Future<void> disableScreenshotPrevention() async {
    _secureFlagCount--;
    if (_secureFlagCount > 0 || !Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('clearFlagSecure');
    } catch (_) {}
  }

  Future<void> resetScreenshotPrevention() async {
    _secureFlagCount = 0;
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('clearFlagSecure');
    } catch (_) {}
  }
}
