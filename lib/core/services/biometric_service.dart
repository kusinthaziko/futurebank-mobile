import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _enabledKey = 'biometric_enabled';

  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final available = await isAvailable();
    if (!available) return false;
    final value = await _storage.read(key: _enabledKey);
    return value == 'true';
  }

  Future<void> setEnabled(bool value) async {
    await _storage.write(key: _enabledKey, value: value.toString());
  }

  Future<bool> authenticate(String reason) async {
    final enabled = await isEnabled();
    if (!enabled) return true;

    try {
      final result = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      return result;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }
}
