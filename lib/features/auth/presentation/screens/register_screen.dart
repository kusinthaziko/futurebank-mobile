import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/graphql/auth_mutations.dart';
import '../../data/graphql/institutions_query.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/error_view.dart';
import '../widgets/institution_picker.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _fullName = TextEditingController();
  final _studentId = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _fetchingInstitutions = false;
  String? _error;
  Map<String, dynamic>? _selectedInstitution;
  String? _institutionDomain;
  List<Map<String, dynamic>> _institutions = [];

  bool get _valid =>
      _fullName.text.isNotEmpty &&
      _studentId.text.isNotEmpty &&
      _selectedInstitution != null &&
      _email.text.contains('@') &&
      _domainValid &&
      _password.text.length >= 8 &&
      _password.text == _confirm.text;

  bool get _domainValid =>
      _institutionDomain == null ||
      _email.text.endsWith('@$_institutionDomain');

  Future<void> _pickInstitution() async {
    setState(() => _fetchingInstitutions = true);
    try {
      _institutions = await InstitutionsQuery.fetch(ref);
    } catch (_) {}
    if (!mounted) return;
    setState(() => _fetchingInstitutions = false);
    final selected = await showInstitutionPicker(context, _institutions);
    if (selected != null) {
      setState(() {
        _selectedInstitution = selected;
        _institutionDomain = selected['domain'] as String?;
      });
    }
  }

  Future<void> _register() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await AuthMutations.register(ref, {
        'full_name': _fullName.text,
        'student_id': _studentId.text,
        'email': _email.text,
        'password': _password.text,
        'institution_id': _selectedInstitution!['id'],
      });
      if (result != null && mounted) {
        await ref.read(authProvider.notifier).login(
          result['accessToken'],
          result['refreshToken'],
          result['user']['id'],
          institutionId: result['user']['institution_id'],
          role: result['user']['role'],
        );
        if (mounted) context.go('/auth/verify-email');
      }
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int _passwordStrength(String p) {
    if (p.isEmpty) return -1;
    var score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;
    if (score <= 2) return 0;
    if (score <= 3) return 1;
    if (score <= 4) return 2;
    if (score <= 5) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _passwordStrength(_password.text);
    const strengthLabels = ['Weak', 'Fair', 'Good', 'Strong', 'Very Strong'];
    const strengthColors = [error500, warning500, gold500, success500, success500];

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(sp24),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickInstitution,
                child: FBCard(
                  outlined: true,
                  padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
                  child: Row(
                    children: [
                      if (_selectedInstitution != null) ...[
                        ClipRRect(
                          borderRadius: radius8,
                          child: Image.network(
                            _selectedInstitution!['logo_url'] ?? '',
                            width: 28, height: 28,
                            errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 24),
                          ),
                        ),
                        const SizedBox(width: sp12),
                        Expanded(
                          child: Text(_selectedInstitution!['name'],
                              style: AppTextStyles.bodyMedium),
                        ),
                        if (_selectedInstitution!['verified'] == true)
                          const Icon(Icons.verified, color: success500, size: 18),
                      ] else ...[
                        const Icon(Icons.school, color: primary500, size: 24),
                        const SizedBox(width: sp12),
                        Expanded(
                          child: Text('Select your institution',
                              style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                        ),
                      ],
                      if (_fetchingInstitutions)
                        const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                      else
                        const Icon(Icons.chevron_right, color: gray500),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: sp16),
              FBInput(label: 'Full Name', controller: _fullName,
                  error: _fullName.text.isNotEmpty ? validateRequired(_fullName.text, 'Full name') : null,
                  onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Student ID', hint: 'e.g. 2021/CS/001',
                  controller: _studentId,
                  error: _studentId.text.isNotEmpty ? validateStudentId(_studentId.text) : null,
                  onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Email',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  error: _email.text.isNotEmpty
                      ? (validateEmail(_email.text) ??
                          (!_domainValid ? 'Must end with @$_institutionDomain' : null))
                      : null,
                  onChanged: (_) => setState(() {})),
              const SizedBox(height: sp16),
              FBInput(label: 'Password', controller: _password,
                  obscure: true,
                  error: _password.text.isNotEmpty ? validatePassword(_password.text) : null,
                  onChanged: (_) => setState(() {})),
              if (strength >= 0) ...[
                const SizedBox(height: sp8),
                ClipRRect(
                  borderRadius: radiusPill,
                  child: LinearProgressIndicator(
                    value: (strength + 1) / 5,
                    backgroundColor: gray100,
                    color: strengthColors[strength],
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: sp4),
                Text(strengthLabels[strength],
                    style: AppTextStyles.caption.copyWith(color: strengthColors[strength])),
              ],
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
