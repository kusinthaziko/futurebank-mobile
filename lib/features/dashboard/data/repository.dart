// Single responsibility: fetch and map dashboard data — no UI
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/queries.dart';
import 'models/dashboard_data.dart';

class DashboardRepository {
  final GraphQLClient _client;

  const DashboardRepository(this._client);

  Future<DashboardData> fetchDashboard() async {
    final result = await _client.query(QueryOptions(
      document: gql(dashboardQuery),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));

    if (result.hasException) throw result.exception!;

    final me = result.data!['me'] as Map<String, dynamic>;
    final accounts = (result.data!['myAccounts'] as List)
        .cast<Map<String, dynamic>>();
    final hsRaw = result.data!['financialHealthScore'] as Map<String, dynamic>?;

    final primaryAccount = accounts.firstWhere(
      (a) => a['account_type'] == 'savings',
      orElse: () => accounts.first,
    );

    return DashboardData(
      user: UserModel.fromJson({
        'id': me['id'],
        'fullName': me['full_name'],
        'financialHealthScore': me['financial_health_score'] ?? 0,
        'kycLevel': me['kyc_level'] ?? 0,
      }),
      primaryAccount: AccountModel.fromJson(primaryAccount),
      recentTransactions: const [],
      healthScore: hsRaw != null ? HealthScoreModel.fromJson({
        'score': hsRaw['score'] ?? 0,
        'savingsConsistency': (hsRaw['savings_consistency'] as num?)?.toDouble() ?? 0.0,
        'loanRepaymentRate': (hsRaw['loan_repayment_rate'] as num?)?.toDouble() ?? 0.0,
        'challengeCompletions': hsRaw['challenge_completions'] ?? 0,
      }) : null,
    );
  }

  Future<List<TransactionModel>> fetchRecentTransactions(String accountId) async {
    final result = await _client.query(QueryOptions(
      document: gql(recentTransactionsQuery),
      variables: {'accountId': accountId, 'limit': 5},
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));

    if (result.hasException) throw result.exception!;

    return (result.data!['transactionHistory'] as List)
        .cast<Map<String, dynamic>>()
        .map((t) => TransactionModel.fromJson({
              'id': t['id'],
              'reference': t['reference'],
              'description': t['description'],
              'amount': t['amount'],
              'transactionType': t['transaction_type'],
              'status': t['status'],
              'insertedAt': t['inserted_at'],
            }))
        .toList();
  }
}
