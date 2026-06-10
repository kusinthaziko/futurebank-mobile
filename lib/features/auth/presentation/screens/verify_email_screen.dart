import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/graphql/auth_mutations.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String? email;
  const VerifyEmailScreen({super.key, this.email});
  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 60;
  Timer? _timer;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      _focusNodes[i].onKeyEvent = (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.backspace &&
            _controllers[i].text.isEmpty &&
            i > 0) {
          _focusNodes[i - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onDigitChange(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_code.length < 6) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthMutations.verifyEmail(ref, code: _code, email: widget.email);
      if (mounted) context.go('/auth/kyc');
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    if (_resendSeconds > 0) return;
    try {
      await AuthMutations.resendVerificationCode(ref, email: widget.email);
      _startResendTimer();
    } catch (e) {
      if (mounted) {
        showErrorToast(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(sp24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: sp32),
              const Text(
                'Check your email',
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: sp8),
              Text(
                'We sent a 6-digit code to ${widget.email ?? 'your email'}',
                style: AppTextStyles.bodyLarge.copyWith(color: gray500),
              ),
              const SizedBox(height: sp32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (i) => SizedBox(
                    width: 48,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.titleLarge,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: radius12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: radius12,
                          borderSide: const BorderSide(color: gray300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: radius12,
                          borderSide: const BorderSide(color: primary500),
                        ),
                      ),
                      onChanged: (v) => _onDigitChange(i, v),
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: sp16),
                Text(
                  _error!,
                  style: AppTextStyles.caption.copyWith(color: error500),
                ),
              ],
              const SizedBox(height: sp32),
              FBButton(
                label: 'Verify',
                onPressed: _code.length == 6 ? _verify : null,
                loading: _loading,
              ),
              const SizedBox(height: sp16),
              Center(
                child: TextButton(
                  onPressed: _resendSeconds > 0 ? null : _resend,
                  child: Text(
                    _resendSeconds > 0
                        ? 'Resend code in $_resendSeconds s'
                        : 'Resend code',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _resendSeconds > 0 ? gray500 : primary500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
