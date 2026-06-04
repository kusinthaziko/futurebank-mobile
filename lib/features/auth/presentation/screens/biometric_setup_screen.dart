import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class BiometricSetupScreen extends ConsumerStatefulWidget {
  const BiometricSetupScreen({super.key});
  @override
  ConsumerState<BiometricSetupScreen> createState() =>
      _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends ConsumerState<BiometricSetupScreen> {
  final _auth = LocalAuthentication();
  bool _loading = false;
  bool _available = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await _auth.canCheckBiometrics;
    if (mounted) setState(() => _available = available);
  }

  Future<void> _enable() async {
    setState(() => _loading = true);
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Enable faster login with your fingerprint or face',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated && mounted) {
        await const FlutterSecureStorage()
            .write(key: 'biometric_enabled', value: 'true');
        if (mounted) context.go('/home');
      }
    } catch (_) {
      // biometric not available or failed
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _skip() => context.go('/home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(sp24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: primary100,
                  borderRadius: radius24,
                ),
                child: const Icon(
                  Icons.fingerprint, size: 56, color: primary500),
              ),
              const SizedBox(height: sp32),
              const Text('Secure your account',
                  style: AppTextStyles.displayMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: sp12),
              Text(
                'Enable fingerprint or face login for faster, '
                'more secure access to your account.',
                style: AppTextStyles.bodyLarge.copyWith(color: gray500),
                textAlign: TextAlign.center),
              const SizedBox(height: sp48),
              FBButton(
                label: 'Enable Biometric Login',
                icon: const Icon(Icons.fingerprint, size: 20),
                onPressed: _available ? _enable : null,
                loading: _loading,
              ),
              const SizedBox(height: sp16),
              TextButton(
                onPressed: _skip,
                child: Text('Skip for now',
                    style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
