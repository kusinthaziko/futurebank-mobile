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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _fullName    = TextEditingController();
  final _studentId   = TextEditingController();
  final _email       = TextEditingController();
  final _password    = TextEditingController();
  final _confirm     = TextEditingController();
  bool _loading = false;
  String? _error;

  bool get _valid =>
      _fullName.text.isNotEmpty &&
      _studentId.text.isNotEmpty &&
      _email.text.contains('@') &&
      _password.text.length >= 8 &&
      _password.text == _confirm.text;

  Future<void> _register() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await AuthMutations.register(ref, {
        'full_name': _fullName.text,
        'student_id': _studentId.text,
        'email': _email.text,
        'password': _password.text,
        'institution_id': 'TODO', // TODO: institution picker
      });
      if (result != null && mounted) {
        await ref.read(authProvider.notifier).login(
          result['accessToken'], result['refreshToken'], result['user']['id']);
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(sp24),
          child: Column(
            children: [
              FBInput(label: 'Full Name', controller: _fullName,
                  onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Student ID', hint: '2021/CS/001',
                  controller: _studentId, onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Email', controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Password', controller: _password,
                  obscure: true, onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Confirm Password', controller: _confirm,
                  obscure: true,
                  error: _confirm.text.isNotEmpty && _password.text != _confirm.text
                      ? 'Passwords do not match' : null,
                  onChanged: (_) => setState(() {})),
              if (_error != null) ...[
                const SizedBox(height: sp8),
                Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
              ],
              const SizedBox(height: sp24),
              FBButton(
                label: 'Create Account',
                onPressed: _valid ? _register : null,
                loading: _loading,
              ),
              const SizedBox(height: sp16),
              TextButton(
                onPressed: () => context.go('/auth/login'),
                child: Text('Already have an account? Sign in',
                    style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
