import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/services/cache_service.dart';
import 'graphql/queries.dart';
import 'models/social_models.dart';

class SocialRepository {
  final GraphQLClient _client;
  final CacheService _cacheService;
  const SocialRepository(this._client, this._cacheService);

  Future<
    ({
      List<GroupModel> groups,
      List<ChallengeModel> challenges,
      List<LeaderboardEntry> leaderboard,
    })
  >
  fetchSocial(String institutionId) async {
    final cached = await _cacheService
        .getFreshValue<
          ({
            List<GroupModel> groups,
            List<ChallengeModel> challenges,
            List<LeaderboardEntry> leaderboard,
          })
        >(
          'social',
          institutionId,
          (json) => (
            groups: (json['groups'] as List)
                .cast<Map<String, dynamic>>()
                .map((g) => GroupModel.fromJson(g))
                .toList(),
            challenges: (json['challenges'] as List)
                .cast<Map<String, dynamic>>()
                .map((c) => ChallengeModel.fromJson(c))
                .toList(),
            leaderboard: (json['leaderboard'] as List)
                .cast<Map<String, dynamic>>()
                .map((e) => LeaderboardEntry.fromJson(e))
                .toList(),
          ),
        );
    if (cached != null) return cached;

    try {
      final r = await _client.query(
        QueryOptions(
          document: gql(socialQuery),
          variables: {'institutionId': institutionId},
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );
      if (r.hasException) throw r.exception!;

      final groups = (r.data!['myGroups'] as List)
          .cast<Map<String, dynamic>>()
          .map(
            (g) => GroupModel.fromJson({
              'id': g['id'],
              'name': g['name'],
              'status': g['status'],
              'inviteCode': g['invite_code'],
              'poolAccountId': g['pool_account_id'],
            }),
          )
          .toList();
      final challenges = (r.data!['activeChallenges'] as List)
          .cast<Map<String, dynamic>>()
          .map(
            (c) => ChallengeModel.fromJson({
              'id': c['id'],
              'title': c['title'],
              'challengeType': c['challenge_type'],
              'rewardPoints': c['reward_points'],
              'status': c['status'],
              'endsAt': c['ends_at'],
            }),
          )
          .toList();
      final leaderboard = (r.data!['leaderboard'] as List)
          .cast<Map<String, dynamic>>()
          .map(
            (e) => LeaderboardEntry.fromJson({
              'userId': e['user_id'],
              'fullName': e['full_name'],
              'score': e['score'],
              'rank': e['rank'],
            }),
          )
          .toList();

      await _cacheService.cacheJson(
        'social',
        institutionId,
        jsonEncode({
          'groups': groups.map((g) => g.toJson()).toList(),
          'challenges': challenges.map((c) => c.toJson()).toList(),
          'leaderboard': leaderboard.map((e) => e.toJson()).toList(),
        }),
      );

      return (groups: groups, challenges: challenges, leaderboard: leaderboard);
    } catch (e) {
      final stale = await _cacheService
          .getStaleValue<
            ({
              List<GroupModel> groups,
              List<ChallengeModel> challenges,
              List<LeaderboardEntry> leaderboard,
            })
          >(
            'social',
            institutionId,
            (json) => (
              groups: (json['groups'] as List)
                  .cast<Map<String, dynamic>>()
                  .map((g) => GroupModel.fromJson(g))
                  .toList(),
              challenges: (json['challenges'] as List)
                  .cast<Map<String, dynamic>>()
                  .map((c) => ChallengeModel.fromJson(c))
                  .toList(),
              leaderboard: (json['leaderboard'] as List)
                  .cast<Map<String, dynamic>>()
                  .map((e) => LeaderboardEntry.fromJson(e))
                  .toList(),
            ),
          );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<GroupDetailModel> fetchGroupDetail(String groupId) async {
    final cached = await _cacheService.getFreshValue<GroupDetailModel>(
      'social',
      'group_$groupId',
      (json) => GroupDetailModel.fromJson(json),
    );
    if (cached != null) return cached;

    try {
      final r = await _client.query(
        QueryOptions(
          document: gql(groupDetailQuery),
          variables: {'groupId': groupId},
        ),
      );
      if (r.hasException) throw r.exception!;
      final detail = GroupDetailModel.fromJson(
        r.data!['groupDetail'] as Map<String, dynamic>,
      );

      await _cacheService.cacheJson(
        'social',
        'group_$groupId',
        jsonEncode({
          'id': detail.id,
          'name': detail.name,
          'status': detail.status,
          'invite_code': detail.inviteCode,
          'pool_account_id': detail.poolAccountId,
          'pool_balance': detail.poolBalance,
          'member_count': detail.memberCount,
          'goal': detail.goal,
          'group_type': detail.groupType,
        }),
      );

      return detail;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<GroupDetailModel>(
        'social',
        'group_$groupId',
        (json) => GroupDetailModel.fromJson(json),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<ChallengeDetailModel> fetchChallengeDetail(String challengeId) async {
    final cached = await _cacheService.getFreshValue<ChallengeDetailModel>(
      'social',
      'challenge_$challengeId',
      (json) => ChallengeDetailModel.fromJson(json),
    );
    if (cached != null) return cached;

    try {
      final r = await _client.query(
        QueryOptions(
          document: gql(challengeDetailQuery),
          variables: {'challengeId': challengeId},
        ),
      );
      if (r.hasException) throw r.exception!;
      final detail = ChallengeDetailModel.fromJson(
        r.data!['challengeDetail'] as Map<String, dynamic>,
      );

      await _cacheService.cacheJson(
        'social',
        'challenge_$challengeId',
        jsonEncode({
          'id': detail.id,
          'title': detail.title,
          'description': detail.description,
          'challenge_type': detail.challengeType,
          'reward_points': detail.rewardPoints,
          'status': detail.status,
          'ends_at': detail.endsAt,
          'participant_count': detail.participantCount,
          'current_progress': detail.currentProgress,
          'target_progress': detail.targetProgress,
          'joined': detail.joined,
        }),
      );

      return detail;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<ChallengeDetailModel>(
        'social',
        'challenge_$challengeId',
        (json) => ChallengeDetailModel.fromJson(json),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard(
    String institutionId,
    String period,
  ) async {
    final key = 'lb_${institutionId}_$period';
    final cached = await _cacheService.getFreshValue<List<LeaderboardEntry>>(
      'social',
      key,
      (json) => (json['items'] as List)
          .cast<Map<String, dynamic>>()
          .map(LeaderboardEntry.fromJson)
          .toList(),
    );
    if (cached != null) return cached;

    try {
      final r = await _client.query(
        QueryOptions(
          document: gql(leaderboardQuery),
          variables: {'institutionId': institutionId, 'period': period},
        ),
      );
      if (r.hasException) throw r.exception!;
      final entries = (r.data!['leaderboard'] as List)
          .cast<Map<String, dynamic>>()
          .map(
            (e) => LeaderboardEntry.fromJson({
              'userId': e['user_id'],
              'fullName': e['full_name'],
              'score': e['score'],
              'rank': e['rank'],
            }),
          )
          .toList();

      await _cacheService.cacheJson(
        'social',
        key,
        jsonEncode({'items': entries.map((e) => e.toJson()).toList()}),
      );

      return entries;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<List<LeaderboardEntry>>(
        'social',
        key,
        (json) => (json['items'] as List)
            .cast<Map<String, dynamic>>()
            .map(LeaderboardEntry.fromJson)
            .toList(),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<void> joinGroup(String inviteCode) async {
    final r = await _client.mutate(
      MutationOptions(
        document: gql(joinGroupMutation),
        variables: {'inviteCode': inviteCode},
      ),
    );
    if (r.hasException) throw r.exception!;
  }

  Future<void> joinChallenge(String challengeId) async {
    final r = await _client.mutate(
      MutationOptions(
        document: gql(joinChallengeMutation),
        variables: {'challengeId': challengeId},
      ),
    );
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
    final r = await _client.mutate(
      MutationOptions(
        document: gql(createGroupMutation),
        variables: {
          'name': name,
          'groupType': groupType,
          'isPublic': isPublic,
          'memberLimit': memberLimit,
          'goal': goal,
          'deadline': deadline,
          'rules': rules,
        },
      ),
    );
    if (r.hasException) throw r.exception!;
    final g = r.data!['createGroup'] as Map<String, dynamic>;
    return (
      id: g['id'] as String,
      name: g['name'] as String,
      inviteCode: g['invite_code'] as String,
    );
  }

  Future<void> contributeToGroup(String groupId, String amount) async {
    final r = await _client.mutate(
      MutationOptions(
        document: gql(contributeToGroupMutation),
        variables: {'groupId': groupId, 'amount': amount},
      ),
    );
    if (r.hasException) throw r.exception!;
  }
}
