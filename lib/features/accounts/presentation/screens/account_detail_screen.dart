import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/account_models.dart';
import '../../domain/providers.dart';

class AccountDetailScreen extends ConsumerWidget {
  final String accountId;
  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final txsAsync = ref.watch(transactionsProvider(accountId));

    return Scaffold(
      appBar: AppBar(title: const Text('Account Details')),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
        data: (data) {
          final account = data.accounts.firstWhere(
            (a) => a.id == accountId,
            orElse: () => data.accounts.first,
          );
          final balance = double.tryParse(account.balance) ?? 0;
          final rate = double.tryParse(account.interestRate) ?? 0;
          final monthlyInterest = balance * (rate / 100) / 12;

          return ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              FBCard(
                gradient: account.accountType == 'savings',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.accountType.toUpperCase(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: account.accountType == 'savings'
                            ? Colors.white70
                            : gray500,
                      ),
                    ),
                    const SizedBox(height: sp8),
                    Text(
                      '${account.currency} ${account.balance}',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: account.accountType == 'savings'
                            ? Colors.white
                            : gray900,
                      ),
                    ),
                    const SizedBox(height: sp4),
                    Text(
                      account.accountNumber,
                      style: AppTextStyles.caption.copyWith(
                        color: account.accountType == 'savings'
                            ? Colors.white54
                            : gray500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: sp16),
              Row(
                children: [
                  _StatCard(
                    icon: FbIcons.trendingUp,
                    label: 'Interest Rate',
                    value: '$rate%',
                  ),
                  const SizedBox(width: sp12),
                  _StatCard(
                    icon: Icons.monetization_on_outlined,
                    label: 'Est. Monthly',
                    value:
                        '${account.currency} ${monthlyInterest.toStringAsFixed(2)}',
                  ),
                ],
              ),
              const SizedBox(height: sp20),
              Row(
                children: [
                  Expanded(
                    child: FBButton(
                      label: 'Deposit',
                      icon: const Icon(FbIcons.plus, size: 16),
                      variant: FBButtonVariant.secondary,
                      onPressed: () => context.push('/deposit'),
                    ),
                  ),
                  const SizedBox(width: sp12),
                  Expanded(
                    child: FBButton(
                      label: 'Transfer',
                      icon: const Icon(FbIcons.send, size: 16),
                      variant: FBButtonVariant.secondary,
                      onPressed: () => context.push('/transfer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: sp24),
              const Text('Balance (30 days)', style: AppTextStyles.titleMedium),
              const SizedBox(height: sp12),
              SizedBox(height: 180, child: _BalanceChart(accountId: accountId)),
              const SizedBox(height: sp20),
              const Text(
                'Recent Transactions',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: sp8),
              txsAsync.when(
                loading: () => const FBSkeletonLoader(height: 200),
                error: (_, __) => const SizedBox.shrink(),
                data: (txs) => Column(
                  children: txs.take(5).map((tx) => _TxRow(tx: tx)).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FBCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primary500, size: 20),
            const SizedBox(height: sp8),
            Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
            const SizedBox(height: sp4),
            Text(value, style: AppTextStyles.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _BalanceChart extends ConsumerWidget {
  final String accountId;
  const _BalanceChart({required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FBCard(
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                30,
                (i) => FlSpot(
                  i.toDouble(),
                  1000 + (i * 50) + (i.isEven ? 200 : -100).toDouble(),
                ),
              ),
              isCurved: true,
              color: primary500,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: primary500.withAlpha(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final TxModel tx;
  const _TxRow({required this.tx});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description ?? tx.transactionType,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(tx.insertedAt),
                  style: AppTextStyles.caption.copyWith(color: gray500),
                ),
              ],
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

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
