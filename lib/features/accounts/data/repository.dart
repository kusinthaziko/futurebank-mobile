import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/queries.dart';
import 'models/account_models.dart';

class AccountRepository {
  final GraphQLClient _client;
  const AccountRepository(this._client);

  Future<({List<AccountModel> accounts, List<SavingsGoalModel> goals})> fetchAccounts() async {
    final r = await _client.query(QueryOptions(document: gql(myAccountsQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork));
    if (r.hasException) throw r.exception!;

    AccountModel _map(Map<String, dynamic> a) => AccountModel.fromJson({
      'id': a['id'], 'accountNumber': a['account_number'],
      'accountType': a['account_type'], 'balance': a['balance'],
      'currency': a['currency'], 'status': a['status'],
      'interestRate': a['interest_rate'],
    });

    SavingsGoalModel _mapGoal(Map<String, dynamic> g) => SavingsGoalModel.fromJson({
      'id': g['id'], 'name': g['name'],
      'targetAmount': g['target_amount'], 'currentAmount': g['current_amount'],
      'deadline': g['deadline'], 'category': g['category'], 'status': g['status'],
    });

    return (
      accounts: (r.data!['myAccounts'] as List).cast<Map<String, dynamic>>().map(_map).toList(),
      goals: (r.data!['savingsGoals'] as List).cast<Map<String, dynamic>>().map(_mapGoal).toList(),
    );
  }

  Future<List<TxModel>> fetchTransactions(String accountId, {int limit = 20, int offset = 0}) async {
    final r = await _client.query(QueryOptions(
      document: gql(transactionHistoryQuery),
      variables: {'accountId': accountId, 'limit': limit, 'offset': offset},
    ));
    if (r.hasException) throw r.exception!;
    return (r.data!['transactionHistory'] as List).cast<Map<String, dynamic>>()
        .map((t) => TxModel.fromJson({
          'id': t['id'], 'reference': t['reference'],
          'description': t['description'], 'amount': t['amount'],
          'transactionType': t['transaction_type'], 'status': t['status'],
          'insertedAt': t['inserted_at'],
        })).toList();
  }
}
