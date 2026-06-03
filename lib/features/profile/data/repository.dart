import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/queries.dart';
import 'models/profile_models.dart';

class ProfileRepository {
  final GraphQLClient _client;
  const ProfileRepository(this._client);

  Future<ProfileData> fetchProfile() async {
    final r = await _client.query(QueryOptions(
      document: gql(profileQuery),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));
    if (r.hasException) throw r.exception!;

    final me = r.data!['me'] as Map<String, dynamic>;
    final hs = r.data!['financialHealthScore'] as Map<String, dynamic>;

    return ProfileData(
      user: UserProfile.fromJson({
        'id': me['id'], 'fullName': me['full_name'],
        'email': me['email'], 'kycLevel': me['kyc_level'],
        'kycStatus': me['kyc_status'],
        'financialHealthScore': me['financial_health_score'],
        'blockchainDid': me['blockchain_did'],
        'avatarUrl': me['avatar_url'],
      }),
      healthScore: HealthScoreData.fromJson({
        'score': hs['score'],
        'savingsConsistency': (hs['savings_consistency'] as num).toDouble(),
        'loanRepaymentRate': (hs['loan_repayment_rate'] as num).toDouble(),
        'challengeCompletions': hs['challenge_completions'],
        'accountAgeDays': hs['account_age_days'] ?? 0,
        'kycLevel': hs['kyc_level'],
      }),
    );
  }

  Future<List<BadgeModel>> fetchBadges() async {
    final r = await _client.query(QueryOptions(document: gql(myBadgesQuery)));
    if (r.hasException) throw r.exception!;
    return (r.data!['myBadges'] as List).cast<Map<String, dynamic>>()
        .map((b) => BadgeModel.fromJson({
              'badgeId': b['badge_id'], 'name': b['name'], 'awardedAt': b['awarded_at'],
            })).toList();
  }
}
