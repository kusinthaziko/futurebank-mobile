import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../data/models/savings_goal_model.dart';
import '../../domain/providers.dart';

class SavingsGoalsWidget extends ConsumerWidget {
  const SavingsGoalsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Savings Goals', style: AppTextStyles.titleMedium),
      const SizedBox(height: sp12),
      SizedBox(
        height: 120,
        child: goalsAsync.when(
          loading: () => const Row(children: [
            FBSkeletonLoader(width: 180, height: 110),
            SizedBox(width: sp12),
            FBSkeletonLoader(width: 180, height: 110),
          ]),
          error: (_, __) => const SizedBox.shrink(),
          data: (goals) => ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...goals.map((g) => Padding(
                padding: const EdgeInsets.only(right: sp12),
                child: _GoalCard(goal: g),
              )),
              _AddGoalCard(),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _GoalCard extends StatelessWidget {
  final SavingsGoalModel goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: FBCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(goal.name, style: AppTextStyles.labelLarge,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: sp8),
          ClipRRect(
            borderRadius: radius4,
            child: LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: gray100,
              valueColor: const AlwaysStoppedAnimation(primary500),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: sp4),
          Text('${(goal.progress * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.labelMedium.copyWith(color: primary500)),
          const SizedBox(height: sp2),
          Text(goal.targetAmount,
              style: AppTextStyles.caption.copyWith(color: gray500)),
        ]),
      ),
    );
  }
}

class _AddGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/accounts/create-goal'),
      child: SizedBox(
        width: 120,
        child: FBCard(
          outlined: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: primary500, size: 32),
              const SizedBox(height: sp4),
              Text('Add Goal',
                  style: AppTextStyles.labelMedium.copyWith(color: primary500)),
            ],
          ),
        ),
      ),
    );
  }
}
