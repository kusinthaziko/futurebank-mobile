import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  bool _obscure = true;
  String? _error;

  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Please enter your email and password');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final result = await AuthMutations.login(
          ref, email: _email.text.trim(), password: _password.text);
      if (result != null && mounted) {
        await ref.read(authProvider.notifier).login(
          result['accessToken'], result['refreshToken'],
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
              Text('Welcome back', style: AppTextStyles.displayMedium),
              const SizedBox(height: sp8),
              Text('Sign in to your account',
                  style: AppTextStyles.bodyLarge.copyWith(color: gray500)),
              const SizedBox(height: sp32),
              FBInput(
                label: 'Email',
                hint: 'your@university.ac.mw',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: sp16),
              FBInput(
                label: 'Password',
                controller: _password,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: sp8),
                Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
              ],
              const SizedBox(height: sp8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot password?',
                      style: AppTextStyles.labelMedium.copyWith(color: primary500)),
                ),
              ),
              const SizedBox(height: sp16),
              FBButton(label: 'Sign In', onPressed: _login, loading: _loading),
              const SizedBox(height: sp16),
              Center(child: TextButton(
                onPressed: () => context.go('/auth/register'),
                child: Text("Don't have an account? Register",
                    style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
              )),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
