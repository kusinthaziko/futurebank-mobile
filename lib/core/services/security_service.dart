import 'dart:io';
import 'package:flutter/services.dart';

/// Controls Android FLAG_SECURE (screenshot / recents-preview prevention)
/// via the native method channel. Uses reference counting so nested
/// protected screens behave correctly. No-op on non-Android platforms.
class SecurityService {
  static const _channel = MethodChannel('com.futurebank.app/window');

  int _secureFlagCount = 0;

  Future<void> enableScreenshotPrevention() async {
    _secureFlagCount++;
    if (_secureFlagCount > 1 || !Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('addFlagSecure');
    } catch (_) {}
  }

  Future<void> disableScreenshotPrevention() async {
    if (_secureFlagCount > 0) _secureFlagCount--;
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
