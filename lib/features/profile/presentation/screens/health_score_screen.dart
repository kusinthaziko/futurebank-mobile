import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_health_score.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/profile_models.dart';
import '../../domain/providers.dart';

class HealthScoreScreen extends ConsumerWidget {
  const HealthScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Health Score')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(profileProvider)),
        data: (data) {
          final hs = data.healthScore;
          final tier = hs.score >= 900 ? 'Elite'
              : hs.score >= 700 ? 'Excellent'
              : hs.score >= 500 ? 'Good'
              : hs.score >= 300 ? 'Fair' : 'Poor';
          final percentile = hs.score >= 800 ? 'Top 10%'
              : hs.score >= 600 ? 'Top 30%'
              : hs.score >= 400 ? 'Top 50%'
              : 'Bottom 50%';

          return ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              FBCard(child: Column(children: [
                Center(child: FBHealthScoreMeter(score: hs.score, size: 160)),
                const SizedBox(height: sp16),
                Text('$tier — $percentile',
                    style: AppTextStyles.titleMedium,
                    textAlign: TextAlign.center),
              ])),
              const SizedBox(height: sp24),
              FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Score Breakdown', style: AppTextStyles.titleMedium),
                const SizedBox(height: sp16),
                _BreakdownBar('Savings consistency', hs.savingsConsistency),
                _BreakdownBar('Loan repayment rate', hs.loanRepaymentRate),
                _BreakdownBar('Account age (${hs.accountAgeDays} days)',
                    (hs.accountAgeDays / 365).clamp(0.0, 1.0)),
                _BreakdownBar('KYC level (${hs.kycLevel}/3)', hs.kycLevel / 3),
                _BreakdownBar('Challenge completions (${hs.challengeCompletions})',
                    (hs.challengeCompletions / 10).clamp(0.0, 1.0)),
              ])),
              const SizedBox(height: sp24),
              FBCard(outlined: true, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('How to improve', style: AppTextStyles.titleMedium),
                const SizedBox(height: sp12),
                Text(_improvementTip(hs),
                    style: AppTextStyles.bodyMedium.copyWith(color: gray700)),
              ])),
              const SizedBox(height: sp24),
              FBButton(
                label: 'View Challenges',
                variant: FBButtonVariant.secondary,
                onPressed: () => context.push('/social'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _improvementTip(HealthScoreData hs) {
    if (hs.savingsConsistency < 0.5) {
      return 'Set up automatic weekly savings to boost your consistency score.';
    }
    if (hs.challengeCompletions < 3) {
      return 'Complete 2 more challenges to reach 800 points.';
    }
    if (hs.kycLevel < 2) {
      return 'Upgrade your KYC level to unlock higher scores and loan limits.';
    }
    return 'Keep up the great work! Maintain your consistency to reach Elite tier.';
  }
}

class _BreakdownBar extends StatelessWidget {
  final String label;
  final double value;
  const _BreakdownBar(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
        Text('${(value.clamp(0.0, 1.0) * 100).toInt()}%',
            style: AppTextStyles.labelMedium.copyWith(color: primary500)),
      ]),
      const SizedBox(height: sp4),
      ClipRRect(
        borderRadius: radius4,
        child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0), minHeight: 6,
            backgroundColor: gray100,
            valueColor: const AlwaysStoppedAnimation(primary500)),
      ),
    ]),
  );
}
