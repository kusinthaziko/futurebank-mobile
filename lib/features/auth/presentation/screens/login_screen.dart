import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/graphql/auth_mutations.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/error_view.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final enabled = await const FlutterSecureStorage()
        .read(key: 'biometric_enabled');
    if (enabled == 'true' && mounted) {
      final avail = await LocalAuthentication().canCheckBiometrics;
      if (mounted) setState(() => _biometricAvailable = avail);
    }
  }

  Future<void> _doLogin() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await AuthMutations.login(
        ref, email: _email.text, password: _password.text);
      if (result != null) {
        await ref.read(authProvider.notifier).login(
          result['accessToken'],
          result['refreshToken'],
          result['user']['id'],
          institutionId: result['user']['institution_id'],
        );
        if (mounted) context.go('/home');
      }
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _biometricLogin() async {
    final auth = LocalAuthentication();
    final authenticated = await auth.authenticate(
      localizedReason: 'Sign in to futureBank',
    );
    if (authenticated && mounted) {
      final token = await const FlutterSecureStorage()
          .read(key: 'access_token');
      if (token != null && mounted) {
        context.go('/home');
      } else if (mounted) {
        setState(() => _error = 'Biometric data not found. Please sign in with password.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(sp24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text('Welcome back', style: AppTextStyles.displayMedium),
              const SizedBox(height: sp8),
              Text('Sign in to your account',
                  style: AppTextStyles.bodyLarge.copyWith(color: gray500)),
              const SizedBox(height: sp32),
              FBInput(label: 'Email', hint: 'your@university.ac.mw',
                  controller: _email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: sp16),
              FBInput(label: 'Password', hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                  controller: _password, obscure: true),
              if (_error != null) ...[
                const SizedBox(height: sp8),
                Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
              ],
              const SizedBox(height: sp8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/auth/forgot-password'),
                  child: Text('Forgot password?',
                      style: AppTextStyles.labelMedium.copyWith(color: primary500)),
                ),
              ),
              const SizedBox(height: sp16),
              FBButton(label: 'Sign In', onPressed: _doLogin, loading: _loading),
              if (_biometricAvailable) ...[
                const SizedBox(height: sp12),
                FBButton(
                  label: 'Sign in with Biometrics',
                  variant: FBButtonVariant.secondary,
                  icon: const Icon(Icons.fingerprint, size: 20),
                  onPressed: _biometricLogin,
                ),
              ],
              const SizedBox(height: sp16),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/auth/register'),
                  child: Text("Don't have an account? Register",
                      style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
