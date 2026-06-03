import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/dashboard_provider.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardProvider.future),
          child: state.when(
            loading: () => _buildSkeleton(),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (data) => _buildContent(context, data),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(sp16),
      children: [
        const FBSkeletonLoader(height: 160),
        const SizedBox(height: sp16),
        const FBSkeletonLoader(height: 60),
        const SizedBox(height: sp16),
        const FBSkeletonLoader(height: 100),
        const SizedBox(height: sp16),
        const FBSkeletonLoader(height: 80),
      ],
    );
  }

  Widget _buildContent(BuildContext context, DashboardData data) {
    return ListView(
      padding: const EdgeInsets.all(sp16),
      children: [
        // Greeting
        Text(_greeting(data.userName),
            style: AppTextStyles.titleLarge),
        const SizedBox(height: sp4),
        Text('MUBAS', style: AppTextStyles.caption.copyWith(color: gray500)),
        const SizedBox(height: sp20),

        // Balance Card
        _BalanceCard(
          balance: data.balance,
          monthlyChange: data.monthlyChange,
          blurred: data.balanceBlurred,
        ),
        const SizedBox(height: sp16),

        // Quick Actions
        _QuickActions(),
        const SizedBox(height: sp20),

        // Health Score
        if (data.healthScore != null)
          _HealthScoreTile(score: data.healthScore!),
        const SizedBox(height: sp16),

        // Recent Transactions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent', style: AppTextStyles.titleMedium),
            TextButton(
              onPressed: () => context.push('/transactions/${data.accountId}'),
              child: Text('See all',
                  style: AppTextStyles.labelMedium.copyWith(color: primary500)),
            ),
          ],
        ),
        ...data.recentTransactions.map((tx) => _TransactionTile(tx: tx)),
      ],
    );
  }

  String _greeting(String name) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    return '$greeting, $name 👋';
  }
}

class _BalanceCard extends ConsumerStatefulWidget {
  final String balance;
  final String monthlyChange;
  final bool blurred;
  const _BalanceCard({required this.balance, required this.monthlyChange, required this.blurred});

  @override
  ConsumerState<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<_BalanceCard> {
  late bool _blurred;

  @override
  void initState() {
    super.initState();
    _blurred = widget.blurred;
  }

  @override
  Widget build(BuildContext context) {
    return FBCard(
      gradient: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Balance',
                  style: AppTextStyles.labelMedium.copyWith(color: Colors.white70)),
              IconButton(
                icon: Icon(_blurred ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70, size: 20),
                onPressed: () => setState(() => _blurred = !_blurred),
                padding: EdgeInsets.zero, constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: sp8),
          Text(
            _blurred ? 'MWK ••••••' : widget.balance,
            style: AppTextStyles.displayMedium.copyWith(color: white),
          ),
          const SizedBox(height: sp4),
          Text(widget.monthlyChange,
              style: AppTextStyles.caption.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.send, 'Send', '/transactions/send'),
      (Icons.add, 'Deposit', '/transactions/deposit'),
      (Icons.credit_score, 'Loans', '/loans'),
      (Icons.more_horiz, 'More', null),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((a) => GestureDetector(
        onTap: a.$3 != null ? () => context.push(a.$3!) : null,
        child: Column(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: primary100, borderRadius: radius12),
              child: Icon(a.$1, color: primary500),
            ),
            const SizedBox(height: sp4),
            Text(a.$2, style: AppTextStyles.caption.copyWith(color: gray700)),
          ],
        ),
      )).toList(),
    );
  }
}

class _HealthScoreTile extends StatelessWidget {
  final int score;
  const _HealthScoreTile({required this.score});

  String get _tier => score >= 900 ? 'Elite' : score >= 700 ? 'Excellent'
      : score >= 500 ? 'Good' : score >= 300 ? 'Fair' : 'Poor';

  @override
  Widget build(BuildContext context) {
    return FBCard(
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: primary100, borderRadius: radius12),
            child: Center(
              child: Text('$score', style: AppTextStyles.labelLarge.copyWith(color: primary500)),
            ),
          ),
          const SizedBox(width: sp12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Financial Health', style: AppTextStyles.bodyMedium),
              Text(_tier, style: AppTextStyles.labelMedium.copyWith(color: success500)),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: gray500),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx['transaction_type'] == 'deposit' || tx['to_account_id'] != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isCredit ? success100 : error100,
              borderRadius: radius12,
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCredit ? success500 : error500, size: 18,
            ),
          ),
          const SizedBox(width: sp12),
          Expanded(
            child: Text(tx['description'] ?? tx['transaction_type'] ?? '',
                style: AppTextStyles.bodyMedium),
          ),
          Text(
            '${isCredit ? '+' : '-'}${tx['amount']}',
            style: AppTextStyles.labelLarge.copyWith(
                color: isCredit ? success500 : error500),
          ),
        ],
      ),
    );
  }
}
