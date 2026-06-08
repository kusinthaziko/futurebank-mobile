// Single responsibility: recent transactions list only
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../data/models/dashboard_data.dart';
import '../../domain/providers.dart';

class RecentTransactions extends ConsumerStatefulWidget {
  final String accountId;
  const RecentTransactions({super.key, required this.accountId});

  @override
  ConsumerState<RecentTransactions> createState() =>
      _RecentTransactionsState();
}

class _RecentTransactionsState extends ConsumerState<RecentTransactions> {
  List<TransactionModel>? _subscriptionItems;
  final Set<String> _animatingIds = {};

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
          _animatingIds.add(model.id);
          if (_subscriptionItems!.length > 5) {
            final removed = _subscriptionItems!.removeLast();
            _animatingIds.remove(removed.id);
          }
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _animatingIds.remove(model.id));
        });
      });
    });

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Recent', style: AppTextStyles.titleMedium),
        TextButton(
          onPressed: () =>
              context.push('/accounts/${widget.accountId}/history'),
          child: Text('See all',
              style: AppTextStyles.labelMedium.copyWith(color: primary500)),
        ),
      ]),
      txsAsync.when(
        loading: () => const FBSkeletonLoader(height: 200),
        error: (e, _) => GestureDetector(
          onTap: () => ref.invalidate(recentTransactionsProvider),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(sp12),
            decoration: BoxDecoration(
              color: error100, borderRadius: radius12,
            ),
            child: Row(children: [
              const Icon(Icons.refresh, color: error500, size: 16),
              const SizedBox(width: sp8),
              Expanded(
                child: Text('Transactions unavailable. Tap to retry.',
                    style: AppTextStyles.caption.copyWith(color: error500)),
              ),
            ]),
          ),
        ),
        data: (txs) {
          final items = _subscriptionItems ?? txs;
          return Column(
            children: items.map((tx) {
              return _animatingIds.contains(tx.id)
                  ? _AnimatedNewRow(key: ValueKey(tx.id), tx: tx)
                  : _TxRow(key: ValueKey(tx.id), tx: tx);
            }).toList(),
          );
        },
      ),
    ]);
  }
}

class _AnimatedNewRow extends StatefulWidget {
  final TransactionModel tx;
  const _AnimatedNewRow({required super.key, required this.tx});

  @override
  State<_AnimatedNewRow> createState() => _AnimatedNewRowState();
}

class _AnimatedNewRowState extends State<_AnimatedNewRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: _TxRow(tx: widget.tx),
      ),
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
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isCredit ? success100 : error100,
            borderRadius: radius12,
          ),
          child: Icon(
            _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
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
              color: _isCredit ? success500 : error500),
        ),
      ]),
    );
  }
}
