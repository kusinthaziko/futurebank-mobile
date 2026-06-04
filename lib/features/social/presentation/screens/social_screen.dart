import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/providers.dart';
import '../../../../core/widgets/error_view.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final institutionId = ref.watch(institutionIdProvider) ?? '';
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
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(socialProvider(institutionId))),
          data: (data) => TabBarView(children: [
            _GroupsTab(groups: data.groups),
            ChallengesList(challenges: data.challenges),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/social/create-group'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  final List groups;
  const _GroupsTab({required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(sp32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.group_add_outlined, size: 64, color: gray300),
            const SizedBox(height: sp16),
            const Text('No groups yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: sp8),
            Text('Start a savings circle with friends',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500),
                textAlign: TextAlign.center),
            const SizedBox(height: sp24),
            FBButton(
              label: 'Create Group',
              onPressed: () => context.push('/social/create-group'),
            ),
          ]),
        ),
      );
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

class ChallengesList extends ConsumerWidget {
  final List challenges;
  const ChallengesList({super.key, required this.challenges});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _FilterChip(label: 'All', selected: true, onTap: () {}),
            const SizedBox(width: sp8),
            _FilterChip(label: 'Active', selected: false, onTap: () {}),
            const SizedBox(width: sp8),
            _FilterChip(label: 'Upcoming', selected: false, onTap: () {}),
            const SizedBox(width: sp8),
            _FilterChip(label: 'Completed', selected: false, onTap: () {}),
          ]),
        ),
      ),
      Expanded(
        child: challenges.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.emoji_events_outlined, size: 64, color: gray300),
                  const SizedBox(height: sp16),
                  Text('No challenges yet',
                      style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                ]),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: sp16),
                itemCount: challenges.length,
                itemBuilder: (_, i) {
                  final c = challenges[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: sp8),
                    child: FBCard(
                      onTap: () => context.push('/social/challenges/${c.id}'),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Icon(_typeIcon(c.challengeType), size: 20, color: gold500),
                          const SizedBox(width: sp8),
                          Expanded(child: Text(c.title, style: AppTextStyles.titleMedium)),
                        ]),
                        const SizedBox(height: sp4),
                        Text('${c.rewardPoints} pts',
                            style: AppTextStyles.caption.copyWith(color: gray500)),
                      ]),
                    ),
                  );
                },
              ),
      ),
    ]);
  }

  IconData _typeIcon(String type) => switch (type) {
    'savings_streak' => Icons.local_fire_department,
    'referral' => Icons.share,
    'loan_repayment' => Icons.credit_score,
    _ => Icons.emoji_events,
  };
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp8),
      decoration: BoxDecoration(
        color: selected ? primary500 : gray100,
        borderRadius: radiusPill,
      ),
      child: Text(label,
          style: AppTextStyles.labelMedium.copyWith(
              color: selected ? white : gray700)),
    ),
  );
}
