// Single responsibility: layout only — no data fetching, no business logic
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../domain/providers.dart';
import '../../../../core/widgets/error_view.dart';
import '../widgets/balance_card.dart';
import '../widgets/health_score_tile.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/savings_goals.dart';
import '../widgets/active_challenge.dart';
import '../widgets/ai_nudge.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => _buildSkeleton(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(dashboardProvider)),
          data: (data) => RefreshIndicator(
            onRefresh: () => Future.wait([
              ref.refresh(dashboardProvider.future),
              ref.refresh(savingsGoalsProvider.future),
              ref.refresh(activeChallengeProvider.future),
              ref.refresh(aiInsightProvider.future),
              ref.refresh(monthlyDeltaProvider(data.primaryAccount.id).future),
            ]),
            child: ListView(
              padding: const EdgeInsets.all(sp16),
              children: [
                Text(_greeting(data.user.fullName),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: sp20),
                BalanceCard(account: data.primaryAccount),
                const SizedBox(height: sp16),
                const QuickActions(),
                const SizedBox(height: sp20),
                if (data.healthScore != null)
                  HealthScoreTile(healthScore: data.healthScore!),
                const SizedBox(height: sp16),
                const ActiveChallengeWidget(),
                const AiNudgeWidget(),
                const SavingsGoalsWidget(),
                RecentTransactions(accountId: data.primaryAccount.id),
                const SizedBox(height: sp80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() => ListView(
    padding: const EdgeInsets.all(sp16),
    children: const [
      FBSkeletonLoader(height: 120),
      SizedBox(height: sp16),
      FBSkeletonLoader(height: 60),
      SizedBox(height: sp16),
      FBSkeletonLoader(height: 80),
      SizedBox(height: sp16),
      FBSkeletonLoader(height: 100),
      SizedBox(height: sp16),
      FBSkeletonLoader(height: 64),
      SizedBox(height: sp16),
      FBSkeletonLoader(height: 120),
      SizedBox(height: sp16),
      FBSkeletonLoader(height: 200),
    ],
  );

  String _greeting(String name) {
    final hour = DateTime.now().hour;
    final g = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    return '$g, ${name.split(' ').first}';
  }
}
