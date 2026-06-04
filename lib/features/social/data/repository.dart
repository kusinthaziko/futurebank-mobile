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

  Future<GroupDetailModel> fetchGroupDetail(String groupId) async {
    final r = await _client.query(QueryOptions(
      document: gql(groupDetailQuery),
      variables: {'groupId': groupId},
    ));
    if (r.hasException) throw r.exception!;
    return GroupDetailModel.fromJson(r.data!['groupDetail'] as Map<String, dynamic>);
  }

  Future<ChallengeDetailModel> fetchChallengeDetail(String challengeId) async {
    final r = await _client.query(QueryOptions(
      document: gql(challengeDetailQuery),
      variables: {'challengeId': challengeId},
    ));
    if (r.hasException) throw r.exception!;
    return ChallengeDetailModel.fromJson(r.data!['challengeDetail'] as Map<String, dynamic>);
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard(String institutionId, String period) async {
    final r = await _client.query(QueryOptions(
      document: gql(leaderboardQuery),
      variables: {'institutionId': institutionId, 'period': period},
    ));
    if (r.hasException) throw r.exception!;
    return (r.data!['leaderboard'] as List).cast<Map<String, dynamic>>()
        .map((e) => LeaderboardEntry.fromJson({'userId': e['user_id'],
            'fullName': e['full_name'], 'score': e['score'], 'rank': e['rank']})).toList();
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

  Future<({String id, String name, String inviteCode})> createGroup({
    required String name,
    String? groupType,
    bool? isPublic,
    int? memberLimit,
    String? goal,
    String? deadline,
    String? rules,
  }) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(createGroupMutation),
      variables: {
        'name': name, 'groupType': groupType, 'isPublic': isPublic,
        'memberLimit': memberLimit, 'goal': goal,
        'deadline': deadline, 'rules': rules,
      },
    ));
    if (r.hasException) throw r.exception!;
    final g = r.data!['createGroup'] as Map<String, dynamic>;
    return (id: g['id'] as String, name: g['name'] as String,
        inviteCode: g['invite_code'] as String);
  }

  Future<void> contributeToGroup(String groupId, String amount) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(contributeToGroupMutation),
      variables: {'groupId': groupId, 'amount': amount},
    ));
    if (r.hasException) throw r.exception!;
  }
}
