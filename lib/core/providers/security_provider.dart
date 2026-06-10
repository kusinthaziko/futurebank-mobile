import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/biometric_service.dart';
import '../services/security_service.dart';

enum LockState { unlocked, locked, authenticating }

class AutoLockNotifier extends StateNotifier<LockState> {
  final SecurityService _security;
  final BiometricService _biometric;

  AutoLockNotifier(this._security, this._biometric) : super(LockState.unlocked);

  void onAppLifecycleChange(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _security.markActive();
    } else if (state == AppLifecycleState.resumed) {
      if (_security.isAutoLockDue) {
        _lock();
      }
    }
  }

  Future<void> _lock() async {
    state = LockState.locked;
    final ok = await _biometric.authenticate('Unlock futureBank');
    state = ok ? LockState.unlocked : LockState.locked;
  }

  Future<void> lockNow() => _lock();

  void unlock() => state = LockState.unlocked;
}

final autoLockProvider = StateNotifierProvider<AutoLockNotifier, LockState>((
  ref,
) {
  final security = SecurityService();
  final biometric = BiometricService();
  return AutoLockNotifier(security, biometric);
});

final securityServiceProvider = Provider<SecurityService>(
  (_) => SecurityService(),
);

final biometricServiceProvider = Provider<BiometricService>(
  (_) => BiometricService(),
);
