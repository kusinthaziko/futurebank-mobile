import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/animations/shake_widget.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/animations/success_celebration.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../dashboard/domain/providers.dart' show dashboardProvider;
import '../../domain/providers.dart';

const _transferMutation = r'''
  mutation Transfer($fromAccountId: ID!, $toAccountId: ID!, $amount: Decimal!,
                    $description: String, $idempotencyKey: String) {
    transfer(from_account_id: $fromAccountId, to_account_id: $toAccountId,
             amount: $amount, description: $description,
             idempotency_key: $idempotencyKey) {
      id reference status
    }
  }
''';

const _findRecipientQuery = r'''
  query FindRecipient($studentId: String!, $institutionId: ID!) {
    findRecipient(student_id: $studentId, institution_id: $institutionId) {
      account_id full_name
    }
  }
''';

const _meQuery = r'''
  query Me {
    me {
      kyc_level
      kyc_status
    }
  }
''';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});
  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _recipientId = TextEditingController();
  final _amount = TextEditingController();
  final _desc = TextEditingController();
  bool _loading = false;
  String? _error, _recipientName, _recipientAccountId;
  double? _availableBalance;
  bool _kycChecked = false;
  bool _kycValid = false;

  // Idempotency key is stable across retries of the SAME transfer so a lost
  // response (network blip) cannot cause a double-spend. It is regenerated only
  // when the transfer parameters change (a genuinely different transfer).
  String? _idempotencyKey;
  String? _idempotencyForSignature;

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _checkKyc();
  }

  Future<void> _checkKyc() async {
    final a = ref.read(authProvider);
    final t = a is Authenticated ? a.accessToken : null;
    if (t == null) return;

    final client = ref.read(graphQLClientProvider(t));
    final r = await client.query(QueryOptions(document: gql(_meQuery)));
    if (!mounted) return;
    if (!r.hasException && r.data != null) {
      final me = r.data!['me'];
      final level = me['kycLevel'] as int? ?? 0;
      setState(() {
        _kycChecked = true;
        _kycValid = level >= 1;
      });
    } else {
      setState(() {
        _kycChecked = true;
        _kycValid = false;
      });
    }
  }

  Future<void> _loadBalance() async {
    try {
      final data = await ref.read(accountsProvider.future);
      final savings = data.accounts
          .where((a) => a.accountType == 'savings')
          .toList();
      if (savings.isEmpty) return;
      setState(() => _availableBalance = double.tryParse(savings.first.balance));
    } catch (_) {}
  }

  Future<void> _lookupRecipient(String studentId) async {
    if (studentId.length < 4) return;
    final auth = ref.read(authProvider);
    final institutionId = auth is Authenticated ? auth.institutionId : null;
    final token = auth is Authenticated ? auth.accessToken : null;
    final client = ref.read(graphQLClientProvider(token));
    final r = await client.query(
      QueryOptions(
        document: gql(_findRecipientQuery),
        variables: {'studentId': studentId, 'institutionId': institutionId},
      ),
    );
    if (!mounted) return;
    if (!r.hasException && r.data != null) {
      final recipient = r.data!['findRecipient'];
      if (recipient != null) {
        setState(() {
          _recipientName = recipient['fullName'];
          _recipientAccountId = recipient['accountId'];
        });
      } else {
        setState(() => _recipientName = null);
      }
    }
  }

  Future<void> _openQrScanner() async {
    final result = await context.push<String>('/qr-scanner');
    if (result != null && result.isNotEmpty && mounted) {
      _recipientId.text = result;
      _lookupRecipient(result);
    }
  }

  Future<void> _submit() async {
    final amt = double.tryParse(_amount.text);
    if (amt == null || amt <= 0) {
      setState(() => _error = 'Enter a valid amount');
      return;
    }
    if (_recipientName == null) {
      setState(() => _error = 'Recipient not found');
      return;
    }
    if (_availableBalance != null && amt > _availableBalance!) {
      setState(() => _error = 'Insufficient balance');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref.read(accountsProvider.future);
      final savings = data.accounts
          .where((a) => a.accountType == 'savings')
          .toList();
      if (savings.isEmpty) {
        setState(() => _error = 'No savings account available to send from.');
        return;
      }
      final fromId = savings.first.id;
      final a = ref.read(authProvider);
      final t = a is Authenticated ? a.accessToken : null;
      final client = ref.read(graphQLClientProvider(t));
      final toId = _recipientAccountId ?? '';
      final desc = _desc.text.isEmpty ? null : _desc.text;
      // Reuse the key when retrying the identical transfer; new key otherwise.
      final signature = '$fromId|$toId|${_amount.text}|${desc ?? ''}';
      if (_idempotencyKey == null || _idempotencyForSignature != signature) {
        _idempotencyKey = const Uuid().v4();
        _idempotencyForSignature = signature;
      }
      final idempotencyKey = _idempotencyKey!;
      final r = await client.mutate(
        MutationOptions(
          document: gql(_transferMutation),
          variables: {
            'fromAccountId': fromId,
            'toAccountId': toId,
            'amount': _amount.text,
            'description': desc,
            'idempotencyKey': idempotencyKey,
          },
        ),
      );
      if (r.hasException) {
        final msg = r.exception.toString();
        if (msg.contains('duplicate_idempotency_key') ||
            msg.contains('already processed')) {
          if (mounted) {
            await SuccessCelebration.show(
              context,
              message: 'Transfer successful!',
              onComplete: () => mounted ? context.go('/home') : null,
            );
          }
          return;
        }
        throw r.exception!;
      }
      ref.invalidate(accountsProvider);
      ref.invalidate(dashboardProvider);
      if (mounted) {
        final txId = r.data?['transfer']?['id'] as String?;
        await SuccessCelebration.show(
          context,
          message: 'Transfer successful!',
          onComplete: () {
            if (mounted) {
              context.go(txId != null ? '/receipt/$txId' : '/home');
            }
          },
        );
      }
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _recipientId.dispose();
    _amount.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amt = double.tryParse(_amount.text) ?? 0;
    final exceedsBalance = _availableBalance != null && amt > _availableBalance!;

    if (_kycChecked && !_kycValid) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transfer')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(sp32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: warning100,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: const Icon(FbIcons.shield, color: warning500, size: 32),
                ),
                const SizedBox(height: sp24),
                Text(
                  'Identity Verification Required',
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: sp12),
                Text(
                  'Please complete your KYC verification to send money. '
                  'This is required by the Reserve Bank of Malawi.',
                  style: AppTextStyles.bodyMedium.copyWith(color: gray700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: sp32),
                FBButton(
                  label: 'Complete KYC',
                  onPressed: () => context.push('/auth/kyc'),
                ),
                const SizedBox(height: sp12),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Go Back',
                    style: AppTextStyles.labelMedium.copyWith(color: gray500),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_kycChecked) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transfer')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(sp24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FBInput(
                      label: 'Recipient Student ID',
                      hint: '2024/CS/001',
                      controller: _recipientId,
                      error: _recipientId.text.isNotEmpty
                          ? validateStudentId(_recipientId.text)
                          : null,
                      onChanged: _lookupRecipient,
                    ),
                  ),
                  const SizedBox(width: sp8),
                  GestureDetector(
                    onTap: _openQrScanner,
                    child: Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.only(top: 22),
                      decoration: BoxDecoration(
                        color: primary100,
                        borderRadius: radius12,
                      ),
                      child: const Icon(
                        FbIcons.qrCode,
                        color: primary500,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              if (_recipientName != null) ...[
                const SizedBox(height: sp8),
                Row(
                  children: [
                    const Icon(FbIcons.checkCircle, color: success500, size: 14),
                    const SizedBox(width: sp4),
                    Text(
                      _recipientName!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: success500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: sp16),
              FBInput(
                label: 'Amount (MWK)',
                hint: '1000',
                controller: _amount,
                keyboardType: TextInputType.number,
                error: _amount.text.isNotEmpty
                    ? validateAmount(_amount.text)
                    : null,
              ),
              if (exceedsBalance) ...[
                const SizedBox(height: sp4),
                Text(
                  'Exceeds available balance',
                  style: AppTextStyles.caption.copyWith(color: error500),
                ),
              ] else ...[
                if (_amount.text.isNotEmpty && _error == null)
                  Padding(
                    padding: const EdgeInsets.only(top: sp4),
                    child: Text(
                      'You will send: MWK ${_amount.text}',
                      style: AppTextStyles.caption.copyWith(color: gray500),
                    ),
                  ),
              ],
              const SizedBox(height: sp16),
              FBInput(label: 'Description (optional)', controller: _desc),
              const SizedBox(height: sp24),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: sp16),
                  child: ShakeWidget(
                    shake: true,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: sp16,
                        vertical: sp12,
                      ),
                      decoration: BoxDecoration(
                        color: error100,
                        borderRadius: radius12,
                      ),
                      child: Row(
                        children: [
                          const Icon(FbIcons.warning, color: error500, size: 18),
                          const SizedBox(width: sp8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: AppTextStyles.caption.copyWith(
                                color: error500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              FBButton(
                label: 'Send Money',
                onPressed:
                    _recipientName != null && !exceedsBalance ? _submit : null,
                loading: _loading,
              ),
              const SizedBox(height: sp24),
            ],
          ),
        ),
      ),
    );
  }
}
