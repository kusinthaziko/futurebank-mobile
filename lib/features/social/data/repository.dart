import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/queries.dart';
import 'models/social_models.dart';

class SocialRepository {
  final GraphQLClient _client;
  const SocialRepository(this._client);

  Future<({List<GroupModel> groups, List<ChallengeModel> challenges, List<LeaderboardEntry> leaderboard})>
      fetchSocial(String institutionId) async {
    final r = await _client.query(QueryOptions(
      document: gql(socialQuery),
      variables: {'institutionId': institutionId},
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));
    if (r.hasException) throw r.exception!;

    return (
      groups: (r.data!['myGroups'] as List).cast<Map<String, dynamic>>()
          .map((g) => GroupModel.fromJson({'id': g['id'], 'name': g['name'],
              'status': g['status'], 'inviteCode': g['invite_code'],
              'poolAccountId': g['pool_account_id']})).toList(),
      challenges: (r.data!['activeChallenges'] as List).cast<Map<String, dynamic>>()
          .map((c) => ChallengeModel.fromJson({'id': c['id'], 'title': c['title'],
              'challengeType': c['challenge_type'], 'rewardPoints': c['reward_points'],
              'status': c['status'], 'endsAt': c['ends_at']})).toList(),
      leaderboard: (r.data!['leaderboard'] as List).cast<Map<String, dynamic>>()
          .map((e) => LeaderboardEntry.fromJson({'userId': e['user_id'],
              'fullName': e['full_name'], 'score': e['score'], 'rank': e['rank']})).toList(),
    );
  }

  Future<void> joinGroup(String inviteCode) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(joinGroupMutation), variables: {'inviteCode': inviteCode}));
    if (r.hasException) throw r.exception!;
  }

  Future<void> joinChallenge(String challengeId) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(joinChallengeMutation), variables: {'challengeId': challengeId}));
    if (r.hasException) throw r.exception!;
  }
}
