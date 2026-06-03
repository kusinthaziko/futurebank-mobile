import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';

class DashboardData {
  final String accountId;
  final String userName;
  final String balance;
  final String monthlyChange;
  final int? healthScore;
  final List<Map<String, dynamic>> recentTransactions;
  final bool balanceBlurred;

  const DashboardData({
    required this.accountId,
    required this.userName,
    required this.balance,
    required this.monthlyChange,
    this.healthScore,
    required this.recentTransactions,
    this.balanceBlurred = false,
  });
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final token = ref.watch(authProvider).accessToken;
  final client = ref.read(graphQLClientProvider(token));

  const query = r'''
    query Dashboard {
      me { id full_name financial_health_score }
      myAccounts { id balance account_type }
      transactionHistory(accountId: "", limit: 5) {
        id description amount transaction_type to_account_id
      }
    }
  ''';

  final result = await client.query(QueryOptions(document: gql(query)));
  if (result.hasException) throw result.exception!;

  final me = result.data?['me'] as Map<String, dynamic>? ?? {};
  final accounts = (result.data?['myAccounts'] as List? ?? []);
  final savings = accounts.firstWhere(
      (a) => a['account_type'] == 'savings', orElse: () => {'id': '', 'balance': '0'});
  final txs = (result.data?['transactionHistory'] as List? ?? [])
      .cast<Map<String, dynamic>>();

  return DashboardData(
    accountId: savings['id'] ?? '',
    userName: (me['full_name'] as String? ?? '').split(' ').first,
    balance: 'MWK ${savings['balance'] ?? '0'}',
    monthlyChange: '↑ this month',
    healthScore: me['financial_health_score'] as int?,
    recentTransactions: txs,
  );
});
