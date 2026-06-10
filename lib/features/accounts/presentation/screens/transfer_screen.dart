import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/security_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/animations/shake_widget.dart';
import '../../../../core/widgets/animations/success_celebration.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../features/auth/domain/auth_state.dart';
import '../../domain/providers.dart';

const _transferMutation = r'''
  mutation Transfer($fromAccountId: ID!, $toAccountId: ID!, $amount: Decimal!, $description: String) {
    transfer(from_account_id: $fromAccountId, to_account_id: $toAccountId,
             amount: $amount, description: $description) {
      id reference status
    }
  }
''';

const _findRecipientQuery = r'''
  query FindRecipient($studentId: String!, $institutionId: ID!) {
    findRecipient(student_id: $studentId, institution_id: $institutionId) {
      account_id
      full_name
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

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final data = await ref.read(accountsProvider.future);
      final savings = data.accounts.firstWhere((a) => a.accountType == 'savings');
      setState(() => _availableBalance = double.tryParse(savings.balance));
    } catch (_) {}
  }

  Future<void> _lookupRecipient(String studentId) async {
    if (studentId.length < 4) return;
    final auth = ref.read(authProvider);
    final institutionId = auth is Authenticated ? auth.institutionId : null;
    final token = auth is Authenticated ? auth.accessToken : null;
    final client = ref.read(graphQLClientProvider(token));
    final r = await client.query(QueryOptions(
      document: gql(_findRecipientQuery),
      variables: {'studentId': studentId, 'institutionId': institutionId},
    ));
    if (!r.hasException && r.data != null) {
      final recipient = r.data!['findRecipient'];
      if (recipient != null) {
        setState(() {
          _recipientName = recipient['full_name'];
          _recipientAccountId = recipient['account_id'];
        });
      } else {
        setState(() => _recipientName = null);
      }
    }
  }

  void _openQrScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(children: [
          AppBar(title: const Text('Scan QR Code')),
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.firstOrNull;
                if (barcode?.rawValue != null) {
                  Navigator.of(context).pop();
                  _recipientId.text = barcode!.rawValue!;
                  _lookupRecipient(barcode.rawValue!);
                }
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    final amt = double.tryParse(_amount.text);
    if (amt == null || amt <= 0) { setState(() => _error = 'Enter a valid amount'); return; }
    if (_recipientName == null) { setState(() => _error = 'Recipient not found'); return; }
    if (_availableBalance != null && amt > _availableBalance!) {
      setState(() => _error = 'Insufficient balance');
      return;
    }

    final bio = ref.read(biometricServiceProvider);
    final ok = await bio.authenticate('Confirm transfer');
    if (!ok) return;

    setState(() { _loading = true; _error = null; });
    try {
      final data = await ref.read(accountsProvider.future);
      final fromId = data.accounts.firstWhere((a) => a.accountType == 'savings').id;
      final a = ref.read(authProvider);
      final t = a is Authenticated ? a.accessToken : null;
      final client = ref.read(graphQLClientProvider(t));
      final r = await client.mutate(MutationOptions(
        document: gql(_transferMutation),
        variables: {
          'fromAccountId': fromId,
          'toAccountId': _recipientAccountId ?? '',
          'amount': _amount.text,
          'description': _desc.text.isEmpty ? null : _desc.text,
        },
      ));
      if (r.hasException) throw r.exception!;
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

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: FBInput(
                label: 'Recipient Student ID',
                hint: '2024/CS/001',
                controller: _recipientId,
                error: _recipientId.text.isNotEmpty ? validateStudentId(_recipientId.text) : null,
                onChanged: _lookupRecipient,
              ),
            ),
            const SizedBox(width: sp8),
            GestureDetector(
              onTap: _openQrScanner,
              child: Container(
                width: 44, height: 44,
                margin: const EdgeInsets.only(top: 22),
                decoration: BoxDecoration(
                  color: primary100, borderRadius: radius12,
                ),
                child: const Icon(Icons.qr_code_scanner, color: primary500, size: 22),
              ),
            ),
          ]),
          if (_recipientName != null) ...[
            const SizedBox(height: sp8),
            Row(children: [
              const Icon(Icons.check_circle, color: success500, size: 14),
              const SizedBox(width: sp4),
              Text('$_recipientName',
                  style: AppTextStyles.labelMedium.copyWith(color: success500)),
            ]),
          ],
          const SizedBox(height: sp16),
          FBInput(
            label: 'Amount (MWK)',
            hint: '1000',
            controller: _amount,
            keyboardType: TextInputType.number,
            error: _amount.text.isNotEmpty ? validateAmount(_amount.text) : null,
          ),
          if (exceedsBalance) ...[
            const SizedBox(height: sp4),
            Text('Exceeds available balance',
                style: AppTextStyles.caption.copyWith(color: error500)),
          ],
          const SizedBox(height: sp16),
          FBInput(label: 'Description (optional)', controller: _desc),
          if (_error != null) ...[
            const SizedBox(height: sp8),
            ShakeWidget(
              shake: true,
              child: Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
            ),
          ],
          const Spacer(),
          FBButton(
            label: 'Send Money',
            onPressed: _recipientName != null && !exceedsBalance ? _submit : null,
            loading: _loading,
          ),
        ]),
      ),
    );
  }
}
