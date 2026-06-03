import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(r'query { myGroups { id name status invite_code pool_account_id } }'),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final groups = (result.data?['myGroups'] as List? ?? []).cast<Map<String, dynamic>>();
        final group = groups.firstWhere((g) => g['id'] == groupId, orElse: () => {});

        return Scaffold(
          appBar: AppBar(title: Text(group['name'] ?? 'Group')),
          body: Padding(
            padding: const EdgeInsets.all(sp16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Invite Code', style: AppTextStyles.labelMedium.copyWith(color: gray500)),
                const SizedBox(height: sp4),
                Row(children: [
                  Text('${group['invite_code']}', style: AppTextStyles.titleLarge.copyWith(
                      letterSpacing: 4, color: primary500)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy, color: primary500),
                    onPressed: () {},
                  ),
                ]),
              ])),
              const SizedBox(height: sp16),
              FBButton(label: 'Contribute to Group', onPressed: () {}),
            ]),
          ),
        );
      },
    );
  }
}

class ChallengeDetailScreen extends StatelessWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(r'''
          query { activeChallenges(institutionId: "") {
            id title description challenge_type target_value
            reward_points status ends_at
          }}
        '''),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final challenges = (result.data?['activeChallenges'] as List? ?? []).cast<Map<String, dynamic>>();
        final challenge = challenges.firstWhere((c) => c['id'] == challengeId, orElse: () => {});

        return Scaffold(
          appBar: AppBar(title: Text('${challenge['title'] ?? 'Challenge'}')),
          body: Padding(
            padding: const EdgeInsets.all(sp16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${challenge['description'] ?? ''}',
                    style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                const SizedBox(height: sp12),
                Row(children: [
                  const Icon(Icons.stars, color: gold500, size: 16),
                  const SizedBox(width: sp4),
                  Text('${challenge['reward_points']} points reward',
                      style: AppTextStyles.labelMedium),
                ]),
              ])),
              const Spacer(),
              FBButton(
                label: 'Join Challenge',
                onPressed: () {
                  // join via GraphQL then pop
                  context.pop();
                },
              ),
            ]),
          ),
        );
      },
    );
  }
}
