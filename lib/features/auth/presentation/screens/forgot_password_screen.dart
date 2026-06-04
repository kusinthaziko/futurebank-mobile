import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/graphql/auth_mutations.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  Future<void> _submit() async {
    if (!_email.text.contains('@')) {
      setState(() => _error = 'Enter a valid email address');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await AuthMutations.forgotPassword(ref, email: _email.text);
      setState(() => _sent = true);
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(sp24),
          child: _sent ? _buildSuccess() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: sp32),
      const Text('Forgot your password?', style: AppTextStyles.displayMedium),
      const SizedBox(height: sp8),
      Text("Enter your email and we'll send you a reset link.",
          style: AppTextStyles.bodyLarge.copyWith(color: gray500)),
      const SizedBox(height: sp32),
      FBInput(label: 'Email', hint: 'your@university.ac.mw',
          controller: _email, keyboardType: TextInputType.emailAddress),
      if (_error != null) ...[
        const SizedBox(height: sp8),
        Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
      ],
      const SizedBox(height: sp24),
      FBButton(label: 'Send Reset Link', onPressed: _submit, loading: _loading),
      const SizedBox(height: sp16),
      Center(
        child: TextButton(
          onPressed: () => context.go('/auth/login'),
          child: Text('Back to Sign In',
              style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
        ),
      ),
    ],
  );

  Widget _buildSuccess() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.check_circle, color: success500, size: 64),
      const SizedBox(height: sp16),
      const Text('Check your email', style: AppTextStyles.titleLarge),
      const SizedBox(height: sp8),
      Text("We've sent a password reset link to\n${_email.text}",
          style: AppTextStyles.bodyMedium.copyWith(color: gray500),
          textAlign: TextAlign.center),
      const SizedBox(height: sp32),
      FBButton(
        label: 'Back to Sign In',
        onPressed: () => context.go('/auth/login'),
      ),
    ],
  );
}
