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
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../core/widgets/error_view.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  int _step = 0;

  // Step 1 — Institution
  List<Map<String, dynamic>> _institutions = [];
  bool _loadingInstitutions = false;
  String _institutionSearch = '';
  Map<String, dynamic>? _selectedInstitution;

  // Step 2 — Personal details
  final _fullName = TextEditingController();
  final _studentId = TextEditingController();
  DateTime? _dateOfBirth;

  // Step 3 — Account
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  // Validation state
  String? _emailError;
  bool _emailValidating = false;

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInstitutions();
    _email.addListener(_validateEmailDomain);
  }

  @override
  void dispose() {
    _email.removeListener(_validateEmailDomain);
    _fullName.dispose();
    _studentId.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _loadInstitutions() async {
    setState(() => _loadingInstitutions = true);
    try {
      _institutions = await InstitutionsQuery.fetch(ref);
    } catch (_) {}
    if (mounted) setState(() => _loadingInstitutions = false);
  }

  List<Map<String, dynamic>> get _filtered => _institutions
      .where((i) => (i['name'] as String)
          .toLowerCase()
          .contains(_institutionSearch.toLowerCase()))
      .toList();

  void _validateEmailDomain() {
    final email = _email.text.trim();
    if (email.isEmpty || _selectedInstitution == null) {
      setState(() => _emailError = null);
      return;
    }
    final domain = _selectedInstitution!['domain'] as String?;
    if (domain == null || domain.isEmpty) return;

    if (email.contains('@')) {
      final emailDomain = email.split('@').last;
      if (emailDomain != domain) {
        setState(() => _emailError = 'Use your @$domain email');
      } else {
        setState(() => _emailError = null);
      }
    } else {
      setState(() => _emailError = null);
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: now.subtract(const Duration(days: 365 * 100)),
      lastDate: now.subtract(const Duration(days: 365 * 16)),
      helpText: 'Select your date of birth',
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDateISO(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool get _canContinueStep2 =>
      _fullName.text.trim().isNotEmpty &&
      _studentId.text.trim().isNotEmpty &&
      _dateOfBirth != null;

  bool get _canSubmit =>
      _email.text.trim().isNotEmpty &&
      _password.text.length >= 6 &&
      _emailError == null;

  Future<void> _submit() async {
    if (!_canSubmit) {
      setState(() => _error = 'Please complete all fields');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final result = await AuthMutations.register(ref, {
        'full_name': _fullName.text.trim(),
        'student_id': _studentId.text.trim(),
        'date_of_birth': _formatDateISO(_dateOfBirth),
        'email': _email.text.trim(),
        'password': _password.text,
        'institution_id': _selectedInstitution!['id'],
      });
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
    return ScreenshotProtectedScreen(
      child: Scaffold(
      appBar: AppBar(
        title: Text(['Select Institution', 'Your Details', 'Set Password'][_step]),
        leading: _step > 0
            ? IconButton(icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--))
            : null,
      ),
      body: [_buildStep1, _buildStep2, _buildStep3][_step](),
    ));
  }

  // Step 1 — Institution search & select
  Widget _buildStep1() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(sp16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search institution...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: radius12),
          ),
          onChanged: (v) => setState(() => _institutionSearch = v),
        ),
      ),
      Expanded(
        child: _loadingInstitutions
            ? const Center(child: CircularProgressIndicator())
            : _filtered.isEmpty
                ? Center(child: Text('No institutions found',
                    style: AppTextStyles.bodyMedium.copyWith(color: gray500)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: sp16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final inst = _filtered[i];
                      final selected = _selectedInstitution?['id'] == inst['id'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: sp8),
                        child: ListTile(
                          tileColor: selected ? primary100 : white,
                          shape: RoundedRectangleBorder(
                            borderRadius: radius12,
                            side: BorderSide(color: selected ? primary500 : gray300),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: primary100,
                            child: Text(inst['name'][0],
                                style: AppTextStyles.labelLarge.copyWith(color: primary500)),
                          ),
                          title: Text(inst['name'], style: AppTextStyles.labelLarge),
                          subtitle: Text(inst['domain'] ?? '',
                              style: AppTextStyles.caption.copyWith(color: gray500)),
                          trailing: selected
                              ? const Icon(Icons.check_circle, color: primary500)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedInstitution = inst;
                              _emailError = null;
                            });
                            _validateEmailDomain();
                          },
                        ),
                      );
                    },
                  ),
      ),
      Padding(
        padding: const EdgeInsets.all(sp16),
        child: FBButton(
          label: 'Continue',
          onPressed: _selectedInstitution != null ? () => setState(() => _step = 1) : null,
        ),
      ),
    ]);
  }

  // Step 2 — Name + Student ID + Date of Birth
  Widget _buildStep2() => Padding(
    padding: const EdgeInsets.all(sp24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Tell us about you', style: AppTextStyles.titleLarge),
      const SizedBox(height: sp8),
      Text('We need this to verify your identity.',
          style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
      const SizedBox(height: sp32),
      FBInput(label: 'Full Name', hint: 'e.g. Timothy Chalira', controller: _fullName),
      const SizedBox(height: sp16),
      FBInput(label: 'Student ID', hint: 'e.g. 2021/CS/001', controller: _studentId),
      const SizedBox(height: sp16),
      GestureDetector(
        onTap: _pickDateOfBirth,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
          decoration: BoxDecoration(
            border: Border.all(color: _dateOfBirth != null ? primary500 : gray300),
            borderRadius: radius12,
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: _dateOfBirth != null ? primary500 : gray500, size: 20),
              const SizedBox(width: sp12),
              Text(
                _dateOfBirth != null ? _formatDate(_dateOfBirth) : 'Date of Birth',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _dateOfBirth != null ? gray900 : gray500,
                ),
              ),
              const Spacer(),
              if (_dateOfBirth != null)
                GestureDetector(
                  onTap: () => setState(() => _dateOfBirth = null),
                  child: const Icon(Icons.close, size: 18, color: gray500),
                ),
            ],
          ),
        ),
      ),
      const Spacer(),
      FBButton(
        label: 'Continue',
        onPressed: _canContinueStep2 ? () => setState(() => _step = 2) : null,
      ),
    ]),
  );

  // Step 3 — Email + Password with domain validation
  Widget _buildStep3() => Padding(
    padding: const EdgeInsets.all(sp24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Create your account', style: AppTextStyles.titleLarge),
      const SizedBox(height: sp8),
      if (_selectedInstitution != null)
        Text('Must use @${_selectedInstitution!['domain']} email.',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
      const SizedBox(height: sp32),
      FBInput(
        label: 'Email',
        hint: 'you@${_selectedInstitution?['domain'] ?? 'university.ac.mw'}',
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        error: _emailError,
      ),
      const SizedBox(height: sp16),
      FBInput(
        label: 'Password',
        hint: 'At least 6 characters',
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
      const Spacer(),
      FBButton(label: 'Create Account', onPressed: _submit, loading: _loading),
      const SizedBox(height: sp12),
      Center(child: TextButton(
        onPressed: () => context.go('/auth/login'),
        child: Text('Already have an account? Sign in',
            style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
      )),
    ]),
  );
}
