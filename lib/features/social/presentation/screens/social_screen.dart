import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/providers.dart';

// institutionId comes from the logged-in user's profile
// For now we use a placeholder — in production, read from auth/profile provider
const _placeholderInstitutionId = '';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final institutionId = ref.watch(authProvider).institutionId ?? '';
    final async = ref.watch(socialProvider(institutionId));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Social'),
          bottom: const TabBar(tabs: [Tab(text: 'Groups'), Tab(text: 'Challenges')]),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(provider)),
          data: (data) => TabBarView(children: [
            _GroupsTab(groups: data.groups),
            _ChallengesTab(challenges: data.challenges),
          ]),
        ),
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  final groups;
  const _GroupsTab({required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(child: Text('No groups yet.',
          style: AppTextStyles.bodyMedium.copyWith(color: gray500)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(sp16),
      itemCount: groups.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: sp8),
        child: FBCard(
          onTap: () => context.push('/social/groups/${groups[i].id}'),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(groups[i].name, style: AppTextStyles.titleMedium),
              if (groups[i].inviteCode != null)
                Text('Code: ${groups[i].inviteCode}',
                    style: AppTextStyles.caption.copyWith(color: gray500)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
              decoration: BoxDecoration(color: success100, borderRadius: radiusPill),
              child: Text(groups[i].status.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(color: success500)),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ChallengesTab extends StatelessWidget {
  final challenges;
  const _ChallengesTab({required this.challenges});

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return Center(child: Text('No active challenges.',
          style: AppTextStyles.bodyMedium.copyWith(color: gray500)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(sp16),
      itemCount: challenges.length,
      itemBuilder: (_, i) {
        final c = challenges[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: sp8),
          child: FBCard(
            onTap: () => context.push('/social/challenges/${c.id}'),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.title, style: AppTextStyles.titleMedium),
              const SizedBox(height: sp4),
              Text('${c.rewardPoints} pts · ${c.challengeType}',
                  style: AppTextStyles.caption.copyWith(color: gray500)),
            ]),
          ),
        );
      },
    );
  }
}
