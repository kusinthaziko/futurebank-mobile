import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/design_system/components/fb_button.dart';
import '../../../core/design_system/components/fb_card_input.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/dimensions.dart';
import '../../../core/design_system/tokens/typography.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../../../core/widgets/error_view.dart';
import '../domain/providers.dart';

const _depositMutation = r'''
  mutation Deposit($accountId: ID!, $amount: Decimal!, $description: String) {
    deposit(accountId: $accountId, amount: $amount, description: $description) {
      id reference status
    }
  }
''';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});
  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _amount = TextEditingController();
  final _desc = TextEditingController();
  bool _loading = false, _success = false;
  String? _error;

  Future<void> _submit() async {
    final amt = double.tryParse(_amount.text);
    if (amt == null || amt <= 0) { setState(() => _error = 'Enter a valid amount'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ref.read(accountsProvider.future);
      final accountId = data.accounts.firstWhere((a) => a.accountType == 'savings').id;
      final client = ref.read(graphQLClientProvider(ref.read(authProvider).accessToken));
      final r = await client.mutate(MutationOptions(
        document: gql(_depositMutation),
        variables: {'accountId': accountId, 'amount': _amount.text,
                    'description': _desc.text.isEmpty ? null : _desc.text},
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
        const Icon(Icons.pending_actions, color: warning500, size: 80),
        const SizedBox(height: sp16),
        Text('Deposit Requested', style: AppTextStyles.titleLarge),
        const SizedBox(height: sp8),
        Text('Pending confirmation from your finance manager.',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500), textAlign: TextAlign.center),
        const SizedBox(height: sp32),
        FBButton(label: 'Back to Home', onPressed: () => context.go('/home')),
      ]),
    )));
    return Scaffold(
      appBar: AppBar(title: const Text('Deposit')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FBInput(label: 'Amount (MWK)', hint: '5000',
              controller: _amount, keyboardType: TextInputType.number),
          const SizedBox(height: sp16),
          FBInput(label: 'Description (optional)', controller: _desc),
          if (_error != null) ...[
            const SizedBox(height: sp8),
            Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
          ],
          const SizedBox(height: sp12),
          Container(
            padding: const EdgeInsets.all(sp12),
            decoration: BoxDecoration(color: primary100, borderRadius: radius12),
            child: Text('Finance manager will confirm this deposit.',
                style: AppTextStyles.caption.copyWith(color: primary500)),
          ),
          const Spacer(),
          FBButton(label: 'Request Deposit', onPressed: _submit, loading: _loading),
        ]),
      ),
    );
  }
}
