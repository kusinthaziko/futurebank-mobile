import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class RegisterStep3Account extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;
  final String? institutionDomain;
  final String? emailError;
  final String? submitError;
  final bool loading;
  final bool canSubmit;
  final VoidCallback onSubmit;

  const RegisterStep3Account({
    super.key,
    required this.email,
    required this.password,
    required this.institutionDomain,
    required this.emailError,
    required this.submitError,
    required this.loading,
    required this.canSubmit,
    required this.onSubmit,
  });

  @override
  State<RegisterStep3Account> createState() => _RegisterStep3AccountState();
}

class _RegisterStep3AccountState extends State<RegisterStep3Account> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Create your account', style: AppTextStyles.titleLarge),
          const SizedBox(height: sp8),
          if (widget.institutionDomain != null)
            Text('Must use @${widget.institutionDomain} email.',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
          const SizedBox(height: sp32),
          FBInput(
            label: 'Email',
            hint: 'you@${widget.institutionDomain ?? 'university.ac.mw'}',
            controller: widget.email,
            keyboardType: TextInputType.emailAddress,
            error: widget.emailError,
          ),
          const SizedBox(height: sp16),
          FBInput(
            label: 'Password',
            hint: 'At least 6 characters',
            controller: widget.password,
            obscure: _obscure,
            suffix: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                  size: 20),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          if (widget.submitError != null) ...[
            const SizedBox(height: sp8),
            Text(widget.submitError!,
                style: AppTextStyles.caption.copyWith(color: error500)),
          ],
          const Spacer(),
          FBButton(
              label: 'Create Account',
              onPressed: widget.onSubmit,
              loading: widget.loading),
          const SizedBox(height: sp12),
          Center(
            child: TextButton(
              onPressed: () => context.go('/auth/login'),
              child: Text('Already have an account? Sign in',
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: primary500)),
            ),
          ),
        ]),
      ),
    );
  }
}
