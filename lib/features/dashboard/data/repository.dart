// Single responsibility: fetch and map dashboard data — no UI
import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/services/cache_service.dart';
import 'graphql/queries.dart';
import 'graphql/queries_ext.dart';
import 'models/dashboard_data.dart';
import 'models/savings_goal_model.dart';
import 'models/challenge_model.dart';
import 'models/ai_insight_model.dart';

/// GraphQL `:decimal` fields are serialized as JSON strings (e.g. "0.85"),
/// while integers arrive as numbers. These coercers tolerate String, num,
/// and null so a missing/typed value can never crash model parsing.
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

class DashboardRepository {
  final GraphQLClient _client;
  final CacheService _cacheService;

  const DashboardRepository(this._client, this._cacheService);

  Future<DashboardData> fetchDashboard(String userId) async {
    final cached = await _cacheService.getFreshValue<DashboardData>(
      'dashboard',
      userId,
      (json) => DashboardData(
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        primaryAccount: AccountModel.fromJson(
          json['primaryAccount'] as Map<String, dynamic>,
        ),
        recentTransactions: (json['recentTransactions'] as List)
            .cast<Map<String, dynamic>>()
            .map(TransactionModel.fromJson)
            .toList(),
        healthScore: json['healthScore'] != null
            ? HealthScoreModel.fromJson(
                json['healthScore'] as Map<String, dynamic>,
              )
            : null,
      ),
    );
    if (cached != null) return cached;

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(dashboardQuery),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) throw result.exception!;

      final me = result.data!['me'] as Map<String, dynamic>;
      final accounts = (result.data!['myAccounts'] as List)
          .cast<Map<String, dynamic>>();
      final hsRaw =
          result.data!['financialHealthScore'] as Map<String, dynamic>?;

      final primaryAccount = accounts.firstWhere(
        (a) => a['accountType'] == 'savings',
        orElse: () => accounts.first,
      );

      final dashboard = DashboardData(
        user: UserModel.fromJson({
          'id': me['id'],
          'fullName': me['fullName'],
          'financialHealthScore': me['financialHealthScore'] ?? 0,
          'kycLevel': me['kycLevel'] ?? 0,
        }),
        primaryAccount: AccountModel.fromJson(primaryAccount),
        recentTransactions: const [],
        healthScore: hsRaw != null
            ? HealthScoreModel.fromJson({
                'score': _toInt(hsRaw['score']),
                'savingsConsistency': _toDouble(hsRaw['savingsConsistency']),
                'loanRepaymentRate': _toDouble(hsRaw['loanRepaymentRate']),
                'challengeCompletions': _toInt(hsRaw['challengeCompletions']),
              })
            : null,
      );

      await _cacheService.cacheJson(
        'dashboard',
        userId,
        jsonEncode({
          'user': dashboard.user.toJson(),
          'primaryAccount': dashboard.primaryAccount.toJson(),
          'recentTransactions': dashboard.recentTransactions
              .map((t) => t.toJson())
              .toList(),
          'healthScore': dashboard.healthScore?.toJson(),
        }),
      );

      return dashboard;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<DashboardData>(
        'dashboard',
        userId,
        (json) => DashboardData(
          user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
          primaryAccount: AccountModel.fromJson(
            json['primaryAccount'] as Map<String, dynamic>,
          ),
          recentTransactions: (json['recentTransactions'] as List)
              .cast<Map<String, dynamic>>()
              .map(TransactionModel.fromJson)
              .toList(),
          healthScore: json['healthScore'] != null
              ? HealthScoreModel.fromJson(
                  json['healthScore'] as Map<String, dynamic>,
                )
              : null,
        ),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchRecentTransactions(
    String accountId,
  ) async {
    final cached = await _cacheService.getFreshValue<List<TransactionModel>>(
      'transactions',
      accountId,
      (json) => (json['items'] as List)
          .cast<Map<String, dynamic>>()
          .map(TransactionModel.fromJson)
          .toList(),
    );
    if (cached != null) return cached;

    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(recentTransactionsQuery),
          variables: {'accountId': accountId, 'limit': 5},
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );

      if (result.hasException) throw result.exception!;

      final txs = (result.data!['transactionHistory'] as List)
          .cast<Map<String, dynamic>>()
          .map(
            (t) => TransactionModel.fromJson({
              'id': t['id'],
              'reference': t['reference'],
              'description': t['description'],
              'amount': t['amount'],
              'transactionType': t['transactionType'],
              'status': t['status'],
              'insertedAt': t['insertedAt'],
            }),
          )
          .toList();

      await _cacheService.cacheJson(
        'transactions',
        accountId,
        jsonEncode({'items': txs.map((t) => t.toJson()).toList()}),
      );

      return txs;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<List<TransactionModel>>(
        'transactions',
        accountId,
        (json) => (json['items'] as List)
            .cast<Map<String, dynamic>>()
            .map(TransactionModel.fromJson)
            .toList(),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<SavingsGoalModel>> fetchSavingsGoals() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(dashboardExtrasQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) throw result.exception!;

    return (result.data!['savingsGoals'] as List)
        .cast<Map<String, dynamic>>()
        .map((g) => SavingsGoalModel.fromJson(g))
        .toList();
  }

  Future<ChallengeModel?> fetchActiveChallenge() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(dashboardExtrasQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) throw result.exception!;

    final challenges = (result.data!['activeChallenges'] as List)
        .cast<Map<String, dynamic>>();
    if (challenges.isEmpty) return null;
    return ChallengeModel.fromJson(challenges.first);
  }

  Future<AiInsightModel?> fetchAiInsight(String accountId) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(dashboardExtrasQuery),
        variables: {'accountId': accountId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) throw result.exception!;

    final raw = result.data!['aiInsight'] as Map<String, dynamic>?;
    if (raw == null) return null;
    return AiInsightModel.fromJson(raw);
  }

  Future<double?> fetchMonthlyDelta(String accountId) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(monthlyDeltaQuery),
        variables: {'accountId': accountId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) return null;

    final raw = result.data!['balanceChange'] as Map<String, dynamic>?;
    if (raw == null) return null;
    return (raw['percentage'] as num?)?.toDouble();
  }
}
