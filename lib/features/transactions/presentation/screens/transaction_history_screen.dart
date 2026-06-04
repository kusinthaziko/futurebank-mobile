import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../accounts/domain/providers.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  final String accountId;
  const TransactionHistoryScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(transactionsProvider(accountId));
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(provider)),
        data: (txs) => txs.isEmpty
            ? Center(child: Text('No transactions.',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500)))
            : ListView.separated(
                padding: const EdgeInsets.all(sp16),
                itemCount: txs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final tx = txs[i];
                  final isCredit = tx.transactionType == 'deposit' ||
                      tx.transactionType == 'interest_credit';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                          color: isCredit ? success100 : error100,
                          borderRadius: radius12),
                      child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isCredit ? success500 : error500, size: 18),
                    ),
                    title: Text(tx.description ?? tx.transactionType,
                        style: AppTextStyles.bodyMedium),
                    subtitle: Text(tx.reference,
                        style: AppTextStyles.caption.copyWith(color: gray500)),
                    trailing: Text(
                        '${isCredit ? '+' : '-'}MWK ${tx.amount}',
                        style: AppTextStyles.labelLarge.copyWith(
                            color: isCredit ? success500 : error500)),
                  );
                },
              ),
      ),
    );
  }
}
