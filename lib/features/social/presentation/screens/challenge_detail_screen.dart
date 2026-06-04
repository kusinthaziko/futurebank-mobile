import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/social_models.dart';
import '../../domain/providers.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(challengeDetailProvider(challengeId));
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(challengeDetailProvider(challengeId))),
        data: (challenge) => _ChallengeBody(challenge: challenge),
      ),
    );
  }
}

class _ChallengeBody extends ConsumerWidget {
  final ChallengeDetailModel challenge;
  const _ChallengeBody({required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = challenge.endsAt != null
        ? DateTime.now().difference(DateTime.parse(challenge.endsAt!)).inDays.abs()
        : 0;
    final progress = challenge.targetProgress > 0
        ? (challenge.currentProgress / challenge.targetProgress).clamp(0.0, 1.0)
        : 0.0;

    return ListView(
      padding: const EdgeInsets.all(sp16),
      children: [
        FBCard(gradient: true, child: Column(children: [
          Icon(_typeIcon(challenge.challengeType), size: 40, color: gold300),
          const SizedBox(height: sp12),
          Text(challenge.title,
              style: AppTextStyles.displayMedium.copyWith(color: white),
              textAlign: TextAlign.center),
          if (challenge.description != null) ...[
            const SizedBox(height: sp8),
            Text(challenge.description!,
                style: AppTextStyles.bodyMedium.copyWith(color: white.withValues(alpha: 0.8)),
                textAlign: TextAlign.center),
          ],
        ])),
        const SizedBox(height: sp16),
        FBCard(child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.stars, color: gold500, size: 20),
            const SizedBox(width: sp8),
            Text('${challenge.rewardPoints} pts',
                style: AppTextStyles.titleLarge.copyWith(color: gold500)),
            if (challenge.challengeType == 'savings_streak') ...[
              const SizedBox(width: sp16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
                decoration: BoxDecoration(
                    color: primary100, borderRadius: radiusPill),
                child: Text('Streak Badge',
                    style: AppTextStyles.labelMedium.copyWith(color: primary500)),
              ),
            ],
          ]),
        ])),
        if (challenge.joined) ...[
          const SizedBox(height: sp16),
          FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your Progress: Day ${challenge.currentProgress} of ${challenge.targetProgress}',
                style: AppTextStyles.titleMedium),
            const SizedBox(height: sp12),
            ClipRRect(
              borderRadius: radius4,
              child: LinearProgressIndicator(
                value: progress, minHeight: 8,
                backgroundColor: gray100,
                valueColor: const AlwaysStoppedAnimation(primary500),
              ),
            ),
            const SizedBox(height: sp12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children:
                List.generate(challenge.targetProgress.clamp(1, 15), (i) {
              final filled = i < challenge.currentProgress;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: filled ? primary500 : gray100,
                  borderRadius: radius4,
                ),
                child: filled
                    ? const Icon(Icons.check, size: 14, color: white)
                    : null,
              );
            })),
          ])),
        ],
        if (challenge.leaderboard.isNotEmpty) ...[
          const SizedBox(height: sp16),
          FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Leaderboard', style: AppTextStyles.titleMedium),
            const SizedBox(height: sp12),
            ...challenge.leaderboard.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: sp4),
              child: Row(children: [
                SizedBox(width: 24, child: Text('${e.rank}.',
                    style: AppTextStyles.labelLarge.copyWith(color: gray500))),
                const SizedBox(width: sp8),
                Icon(e.rank <= 3 ? Icons.emoji_events : Icons.person,
                    size: 16, color: e.rank == 1 ? gold500 : gray500),
                const SizedBox(width: sp8),
                Expanded(child: Text(e.fullName, style: AppTextStyles.bodyMedium)),
                Text('${e.score}', style: AppTextStyles.labelLarge),
              ]),
            )),
          ])),
        ],
        const SizedBox(height: sp16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.people, size: 16, color: gray500),
          const SizedBox(width: sp4),
          Text('${challenge.participantCount} participants',
              style: AppTextStyles.caption.copyWith(color: gray500)),
          const SizedBox(width: sp16),
          const Icon(Icons.schedule, size: 16, color: gray500),
          const SizedBox(width: sp4),
          Text('$daysLeft days left',
              style: AppTextStyles.caption.copyWith(color: gray500)),
        ]),
        const SizedBox(height: sp24),
        if (!challenge.joined)
          FBButton(
            label: 'Join Challenge',
            icon: const Icon(Icons.add),
            onPressed: () async {
              try {
                final token = ref.read(accessTokenProvider);
                await ref.read(socialRepositoryProvider(token))
                    .joinChallenge(challenge.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Joined challenge!')));
                  ref.invalidate(challengeDetailProvider(challenge.id));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')));
                }
              }
            },
          ),
      ],
    );
  }

  IconData _typeIcon(String type) => switch (type) {
    'savings_streak' => Icons.local_fire_department,
    'referral' => Icons.share,
    'loan_repayment' => Icons.credit_score,
    _ => Icons.emoji_events,
  };
}
