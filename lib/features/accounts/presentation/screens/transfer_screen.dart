import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/design_system/components/fb_button.dart';
import '../../../core/design_system/components/fb_card_input.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/dimensions.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../../../core/widgets/error_view.dart';
import '../domain/providers.dart';

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
    users(filter: {student_id: $studentId, institution_id: $institutionId}) {
      id full_name
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
  final _auth = LocalAuthentication();
  bool _loading = false, _success = false;
  String? _error, _recipientName, _recipientAccountId;

  Future<void> _lookupRecipient(String studentId) async {
    if (studentId.length < 4) return;
    final institutionId = ref.read(authProvider).institutionId ?? '';
    final client = ref.read(graphQLClientProvider(ref.read(authProvider).accessToken));
    final r = await client.query(QueryOptions(
      document: gql(_findRecipientQuery),
      variables: {'studentId': studentId, 'institutionId': institutionId},
    ));
    if (!r.hasException && r.data != null) {
      final users = r.data!['users'] as List? ?? [];
      if (users.isNotEmpty) {
        setState(() => _recipientName = users.first['full_name']);
      }
    }
  }

  Future<void> _submit() async {
    final amt = double.tryParse(_amount.text);
    if (amt == null || amt <= 0) { setState(() => _error = 'Enter a valid amount'); return; }
    if (_recipientName == null) { setState(() => _error = 'Recipient not found'); return; }

    // Biometric re-auth
    final ok = await _auth.authenticate(localizedReason: 'Confirm transfer');
    if (!ok) return;

    setState(() { _loading = true; _error = null; });
    try {
      final data = await ref.read(accountsProvider.future);
      final fromId = data.accounts.firstWhere((a) => a.accountType == 'savings').id;
      final client = ref.read(graphQLClientProvider(ref.read(authProvider).accessToken));
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
      setState(() => _success = true);
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_success) return Scaffold(body: Center(child: Padding(
      padding: const EdgeInsets.all(sp32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, color: success500, size: 80),
        const SizedBox(height: sp16),
        Text('Transfer Sent', style: AppTextStyles.titleLarge),
        const SizedBox(height: sp32),
        FBButton(label: 'Back to Home', onPressed: () => context.go('/home')),
      ]),
    )));
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FBInput(
            label: 'Recipient Student ID',
            hint: '2024/CS/001',
            controller: _recipientId,
            onChanged: _lookupRecipient,
          ),
          if (_recipientName != null) ...[
            const SizedBox(height: sp8),
            Text('✓ $_recipientName',
                style: AppTextStyles.labelMedium.copyWith(color: success500)),
          ],
          const SizedBox(height: sp16),
          FBInput(label: 'Amount (MWK)', hint: '1000',
              controller: _amount, keyboardType: TextInputType.number),
          const SizedBox(height: sp16),
          FBInput(label: 'Description (optional)', controller: _desc),
          if (_error != null) ...[
            const SizedBox(height: sp8),
            Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
          ],
          const Spacer(),
          FBButton(
            label: 'Send Money',
            onPressed: _recipientName != null ? _submit : null,
            loading: _loading,
          ),
        ]),
      ),
    );
  }
}
