import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../domain/providers.dart';

class ActiveChallengeWidget extends ConsumerWidget {
  const ActiveChallengeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeAsync = ref.watch(activeChallengeProvider);

    return challengeAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: sp16),
        child: FBSkeletonLoader(height: 100),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.only(bottom: sp16),
        child: GestureDetector(
          onTap: () => ref.invalidate(activeChallengeProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: sp12,
              vertical: sp10,
            ),
            decoration: BoxDecoration(color: error100, borderRadius: radius12),
            child: Row(
              children: [
                const Icon(FbIcons.refresh, color: error500, size: 16),
                const SizedBox(width: sp8),
                Expanded(
                  child: Text(
                    'Challenge unavailable. Tap to retry.',
                    style: AppTextStyles.caption.copyWith(color: error500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (challenge) {
        if (challenge == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: sp16),
          child: FBCard(
            onTap: () => context.push('/social/challenges/${challenge.id}'),
            child: Row(
              children: [
                if (challenge.isStreak)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: gold100,
                      borderRadius: radius12,
                    ),
                    child: const Icon(FbIcons.fire, color: gold500, size: 22),
                  )
                else
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary100,
                      borderRadius: radius12,
                    ),
                    child: const Icon(
                      FbIcons.trophy,
                      color: primary500,
                      size: 22,
                    ),
                  ),
                const SizedBox(width: sp12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.name,
                        style: AppTextStyles.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: sp4),
                      ClipRRect(
                        borderRadius: radius4,
                        child: LinearProgressIndicator(
                          value: challenge.progress.clamp(0.0, 1.0),
                          backgroundColor: gray100,
                          valueColor: AlwaysStoppedAnimation(
                            challenge.isStreak ? gold500 : primary500,
                          ),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: sp4),
                      Row(
                        children: [
                          if (challenge.isStreak &&
                              challenge.streakDays != null) ...[
                            const Icon(FbIcons.fire, size: 12, color: gold500),
                            const SizedBox(width: sp4),
                            Text(
                              '${challenge.streakDays}-day streak',
                              style: AppTextStyles.caption.copyWith(
                                color: gold500,
                              ),
                            ),
                            const SizedBox(width: sp8),
                          ],
                          Text(
                            '${challenge.daysRemaining}d left',
                            style: AppTextStyles.caption.copyWith(
                              color: gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(FbIcons.caretRight, color: gray500),
              ],
            ),
          ),
        );
      },
    );
  }
}
