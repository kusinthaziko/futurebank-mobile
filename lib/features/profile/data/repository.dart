import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/services/cache_service.dart';
import 'graphql/queries.dart';
import 'models/profile_models.dart';

/// GraphQL `:decimal` fields serialize as JSON strings (e.g. "0.85"); ints
/// arrive as numbers. Tolerate String/num/null so parsing can't crash.
double _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? double.tryParse(v)?.toInt() ?? 0;
  return 0;
}

class ProfileRepository {
  final GraphQLClient _client;
  final CacheService _cacheService;
  const ProfileRepository(this._client, this._cacheService);

  Future<ProfileData> fetchProfile(String userId) async {
    final cached = await _cacheService.getFreshValue<ProfileData>(
      'profile',
      userId,
      (json) => ProfileData(
        user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
        healthScore: HealthScoreData.fromJson(
          json['healthScore'] as Map<String, dynamic>,
        ),
      ),
    );
    if (cached != null) return cached;

    try {
      final r = await _client.query(
        QueryOptions(
          document: gql(profileQuery),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );
      if (r.hasException) throw r.exception!;

      final me = r.data!['me'] as Map<String, dynamic>;
      final hs = r.data!['financialHealthScore'] as Map<String, dynamic>?;

      final profile = ProfileData(
        user: UserProfile.fromJson({
          'id': me['id'],
          'fullName': me['full_name'],
          'email': me['email'],
          'kycLevel': me['kyc_level'],
          'kycStatus': me['kyc_status'],
          'financialHealthScore': me['financial_health_score'],
          'avatarUrl': me['avatar_url'],
        }),
        healthScore: HealthScoreData.fromJson({
          'score': _toInt(hs?['score']),
          'savingsConsistency': _toDouble(hs?['savings_consistency']),
          'loanRepaymentRate': _toDouble(hs?['loan_repayment_rate']),
          'challengeCompletions': _toInt(hs?['challenge_completions']),
          'accountAgeDays': _toInt(hs?['account_age_days']),
          'kycLevel': _toInt(hs?['kyc_level'] ?? me['kyc_level']),
        }),
      );

      await _cacheService.cacheJson(
        'profile',
        userId,
        jsonEncode({
          'user': profile.user.toJson(),
          'healthScore': profile.healthScore.toJson(),
        }),
      );

      return profile;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<ProfileData>(
        'profile',
        userId,
        (json) => ProfileData(
          user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
          healthScore: HealthScoreData.fromJson(
            json['healthScore'] as Map<String, dynamic>,
          ),
        ),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<BadgeModel>> fetchBadges() async {
    final r = await _client.query(QueryOptions(document: gql(myBadgesQuery)));
    if (r.hasException) throw r.exception!;
    return (r.data!['myBadges'] as List)
        .cast<Map<String, dynamic>>()
        .map(
          (b) => BadgeModel.fromJson({
            'badgeId': b['badge_id'],
            'name': b['name'],
            'awardedAt': b['awarded_at'],
          }),
        )
        .toList();
  }

  Future<void> updateAvatar(String avatarUrl) async {
    final r = await _client.mutate(
      MutationOptions(
        document: gql(updateProfileMutation),
        variables: {'avatar_url': avatarUrl},
      ),
    );
    if (r.hasException) throw r.exception!;
  }
}
