import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Social'),
          bottom: const TabBar(tabs: [Tab(text: 'Groups'), Tab(text: 'Challenges')]),
        ),
        body: const TabBarView(children: [_GroupsTab(), _ChallengesTab()]),
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  const _GroupsTab();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(r'query { myGroups { id name status invite_code } }')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Center(child: CircularProgressIndicator());
        final groups = (result.data?['myGroups'] as List? ?? []).cast<Map<String, dynamic>>();
        if (groups.isEmpty) {
          return Center(child: Text('No groups yet.\nStart a savings circle!',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500),
              textAlign: TextAlign.center));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(sp16),
          itemCount: groups.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: sp8),
            child: FBCard(child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(groups[i]['name'], style: AppTextStyles.titleMedium),
                Text('Code: ${groups[i]['invite_code']}',
                    style: AppTextStyles.caption.copyWith(color: gray500)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
                decoration: BoxDecoration(color: success100, borderRadius: radiusPill),
                child: Text('${groups[i]['status']}'.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(color: success500)),
              ),
            ])),
          ),
        );
      },
    );
  }
}

class _ChallengesTab extends StatelessWidget {
  const _ChallengesTab();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(r'''
        query { activeChallenges(institutionId: "") {
          id title challenge_type reward_points status ends_at
        }}
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Center(child: CircularProgressIndicator());
        final challenges = (result.data?['activeChallenges'] as List? ?? [])
            .cast<Map<String, dynamic>>();
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
              child: FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['title'], style: AppTextStyles.titleMedium),
                const SizedBox(height: sp4),
                Text('${c['reward_points']} pts · ${c['challenge_type']}',
                    style: AppTextStyles.caption.copyWith(color: gray500)),
              ])),
            );
          },
        );
      },
    );
  }
}
