// Single responsibility: recent transactions list only
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../../../core/widgets/animations/fade_in_staggered.dart';
import '../../data/models/dashboard_data.dart';
import '../../domain/providers.dart';

class RecentTransactions extends ConsumerStatefulWidget {
  final String accountId;
  const RecentTransactions({super.key, required this.accountId});

  @override
  ConsumerState<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends ConsumerState<RecentTransactions> {
  List<TransactionModel>? _subscriptionItems;

  @override
  Widget build(BuildContext context) {
    final txsAsync = ref.watch(recentTransactionsProvider);

    ref.listen(transactionSubscriptionProvider(widget.accountId), (_, next) {
      next.whenData((tx) {
        final model = TransactionModel(
          id: tx.id,
          reference: tx.reference,
          description: tx.description,
          amount: tx.amount,
          transactionType: tx.transactionType,
          status: tx.status,
          insertedAt: tx.insertedAt,
        );
        setState(() {
          (_subscriptionItems ??= []).insert(0, model);
          if (_subscriptionItems!.length > 5) {
            _subscriptionItems!.removeLast();
          }
        });
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent', style: AppTextStyles.titleMedium),
            TextButton(
              onPressed: () =>
                  context.push('/accounts/${widget.accountId}/history'),
              child: Text(
                'See all',
                style: AppTextStyles.labelMedium.copyWith(color: primary500),
              ),
            ),
          ],
        ),
        txsAsync.when(
          loading: () => const FBSkeletonLoader(height: 200),
          error: (e, _) => GestureDetector(
            onTap: () => ref.invalidate(recentTransactionsProvider),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(sp12),
              decoration: BoxDecoration(
                color: error100,
                borderRadius: radius12,
              ),
              child: Row(
                children: [
                  const Icon(FbIcons.refresh, color: error500, size: 16),
                  const SizedBox(width: sp8),
                  Expanded(
                    child: Text(
                      'Transactions unavailable. Tap to retry.',
                      style: AppTextStyles.caption.copyWith(color: error500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (txs) {
            final items = _subscriptionItems ?? txs;
            return FadeInStaggered(
              staggerDelayMs: 60,
              children: items
                  .map((tx) => _TxRow(key: ValueKey(tx.id), tx: tx))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _TxRow extends StatelessWidget {
  final TransactionModel tx;
  const _TxRow({super.key, required this.tx});

  bool get _isCredit =>
      tx.transactionType == 'deposit' ||
      tx.transactionType == 'interest_credit';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isCredit ? success100 : error100,
              borderRadius: radius12,
            ),
            child: Icon(
              _isCredit ? FbIcons.arrowDown : FbIcons.arrowUp,
              color: _isCredit ? success500 : error500,
              size: 18,
            ),
          ),
          const SizedBox(width: sp12),
          Expanded(
            child: Text(
              tx.description ?? tx.transactionType,
              style: AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${_isCredit ? '+' : '-'}${tx.amount}',
            style: AppTextStyles.labelLarge.copyWith(
              color: _isCredit ? success500 : error500,
            ),
          ),
        ],
      ),
    );
  }
}
