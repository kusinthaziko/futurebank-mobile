// Single responsibility: recent transactions list only
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../data/models/dashboard_data.dart';
import '../../domain/providers.dart';

class RecentTransactions extends ConsumerWidget {
  final String accountId;
  const RecentTransactions({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txsAsync = ref.watch(recentTransactionsProvider);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Recent', style: AppTextStyles.titleMedium),
        TextButton(
          onPressed: () => context.push('/accounts/$accountId/history'),
          child: Text('See all',
              style: AppTextStyles.labelMedium.copyWith(color: primary500)),
        ),
      ]),
      txsAsync.when(
        loading: () => const FBSkeletonLoader(height: 200),
        error: (_, __) => const SizedBox(),
        data: (txs) => Column(
          children: txs.map((tx) => _TxRow(tx: tx)).toList(),
        ),
      ),
    ]);
  }
}

class _TxRow extends StatelessWidget {
  final TransactionModel tx;
  const _TxRow({required this.tx});

  bool get _isCredit =>
      tx.transactionType == 'deposit' || tx.transactionType == 'interest_credit';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: _isCredit ? success100 : error100,
            borderRadius: radius12,
          ),
          child: Icon(
            _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: _isCredit ? success500 : error500, size: 18,
          ),
        ),
        const SizedBox(width: sp12),
        Expanded(child: Text(
          tx.description ?? tx.transactionType,
          style: AppTextStyles.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        Text(
          '${_isCredit ? '+' : '-'}${tx.amount}',
          style: AppTextStyles.labelLarge.copyWith(
              color: _isCredit ? success500 : error500),
        ),
      ]),
    );
  }
}
