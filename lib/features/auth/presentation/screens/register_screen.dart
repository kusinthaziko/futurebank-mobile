import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/graphql/auth_mutations.dart';
import '../../data/graphql/institutions_query.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../core/widgets/error_view.dart';
import '../widgets/register_step_indicator.dart';
import '../widgets/register_step1_institution.dart';
import '../widgets/register_step2_details.dart';
import '../widgets/register_step3_account.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  int _step = 0;

  // Step 1
  List<Map<String, dynamic>> _institutions = [];
  bool _loadingInstitutions = false;
  Map<String, dynamic>? _selectedInstitution;

  // Step 2
  final _fullName = TextEditingController();
  final _studentId = TextEditingController();
  final _phone = TextEditingController();
  DateTime? _dateOfBirth;

  // Step 3
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  String? _error;
  bool _loading = false;

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
    _phone.dispose();
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

  void _validateEmailDomain() {
    final email = _email.text.trim();
    final domain = _selectedInstitution?['domain'] as String?;
    if (email.isEmpty || domain == null || domain.isEmpty) {
      setState(() => _emailError = null);
      return;
    }
    if (email.contains('@')) {
      final emailDomain = email.split('@').last;
      setState(
        () => _emailError = emailDomain != domain
            ? 'Use your @$domain email'
            : null,
      );
    } else {
      setState(() => _emailError = null);
    }
  }

  Future<void> _pickDateOfBirth() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: now.subtract(const Duration(days: 365 * 100)),
      lastDate: now.subtract(const Duration(days: 365 * 16)),
      helpText: 'Select your date of birth',
    );
    if (picked != null && mounted) setState(() => _dateOfBirth = picked);
  }

  bool get _canContinueStep2 =>
      _fullName.text.trim().isNotEmpty &&
      _studentId.text.trim().isNotEmpty &&
      _phone.text.trim().isNotEmpty &&
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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dob = _dateOfBirth!;
      final dobStr =
          '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';
      final result = await AuthMutations.register(ref, input: {
        'full_name': _fullName.text.trim(),
        'student_id': _studentId.text.trim(),
        'date_of_birth': dobStr,
        'phone': _phone.text.trim(),
        'email': _email.text.trim(),
        'password': _password.text,
        'institution_id': _selectedInstitution!['id'],
      });
      if (result != null && mounted) {
        await ref
            .read(authProvider.notifier)
            .login(
              result['accessToken'],
              result['refreshToken'],
              result['user']['id'],
              institutionId: result['user']['institutionId'],
            );
        if (mounted) context.go('/home');
      }
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static const _titles = ['Select Institution', 'Your Details', 'Set Password'];

  @override
  Widget build(BuildContext context) {
    return ScreenshotProtectedScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_step]),
          leading: _step > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _step--),
                )
              : null,
        ),
        body: Column(
          children: [
            RegisterStepIndicator(currentStep: _step, totalSteps: 3),
            Expanded(
              child: switch (_step) {
                0 => RegisterStep1Institution(
                  institutions: _institutions,
                  loading: _loadingInstitutions,
                  selected: _selectedInstitution,
                  onSelect: (inst) => setState(() {
                    _selectedInstitution = inst;
                    _emailError = null;
                    _validateEmailDomain();
                  }),
                  onContinue: () => setState(() => _step = 1),
                ),
                1 => RegisterStep2Details(
                  fullName: _fullName,
                  studentId: _studentId,
                  phone: _phone,
                  dateOfBirth: _dateOfBirth,
                  onPickDate: _pickDateOfBirth,
                  onClearDate: () => setState(() => _dateOfBirth = null),
                  canContinue: _canContinueStep2,
                  onContinue: () => setState(() => _step = 2),
                ),
                _ => RegisterStep3Account(
                  email: _email,
                  password: _password,
                  institutionDomain: _selectedInstitution?['domain'],
                  emailError: _emailError,
                  submitError: _error,
                  loading: _loading,
                  canSubmit: _canSubmit,
                  onSubmit: _submit,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
