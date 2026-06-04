import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/services/cache_service.dart';
import 'graphql/queries.dart';
import 'models/account_models.dart';

class AccountRepository {
  final GraphQLClient _client;
  final CacheService _cacheService;
  const AccountRepository(this._client, this._cacheService);

  Future<({List<AccountModel> accounts, List<SavingsGoalModel> goals})> fetchAccounts() async {
    final cached = await _cacheService.getFreshValue<({List<AccountModel> accounts, List<SavingsGoalModel> goals})>(
      'accounts', 'all',
      (json) => (
        accounts: (json['accounts'] as List).cast<Map<String, dynamic>>().map((a) => AccountModel.fromJson(a)).toList(),
        goals: (json['goals'] as List).cast<Map<String, dynamic>>().map((g) => SavingsGoalModel.fromJson(g)).toList(),
      ),
    );
    if (cached != null) return cached;

    try {
      final r = await _client.query(QueryOptions(document: gql(myAccountsQuery),
          fetchPolicy: FetchPolicy.cacheAndNetwork));
      if (r.hasException) throw r.exception!;

      AccountModel map(Map<String, dynamic> a) => AccountModel.fromJson({
        'id': a['id'], 'accountNumber': a['account_number'],
        'accountType': a['account_type'], 'balance': a['balance'],
        'currency': a['currency'], 'status': a['status'],
        'interestRate': a['interest_rate'],
      });

      SavingsGoalModel mapGoal(Map<String, dynamic> g) => SavingsGoalModel.fromJson({
        'id': g['id'], 'name': g['name'],
        'targetAmount': g['target_amount'], 'currentAmount': g['current_amount'],
        'deadline': g['deadline'], 'category': g['category'], 'status': g['status'],
      });

      final accounts = (r.data!['myAccounts'] as List).cast<Map<String, dynamic>>().map(map).toList();
      final goals = (r.data!['savingsGoals'] as List).cast<Map<String, dynamic>>().map(mapGoal).toList();

      await _cacheService.cacheJson('accounts', 'all', jsonEncode({
        'accounts': accounts.map((a) => a.toJson()).toList(),
        'goals': goals.map((g) => g.toJson()).toList(),
      }));

      return (accounts: accounts, goals: goals);
    } catch (e) {
      final stale = await _cacheService.getStaleValue<({List<AccountModel> accounts, List<SavingsGoalModel> goals})>(
        'accounts', 'all',
        (json) => (
          accounts: (json['accounts'] as List).cast<Map<String, dynamic>>().map((a) => AccountModel.fromJson(a)).toList(),
          goals: (json['goals'] as List).cast<Map<String, dynamic>>().map((g) => SavingsGoalModel.fromJson(g)).toList(),
        ),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<TxModel>> fetchTransactions(String accountId, {int limit = 20, int offset = 0}) async {
    final cached = await _cacheService.getFreshValue<List<TxModel>>(
      'transactions', accountId,
      (json) => (json['items'] as List).cast<Map<String, dynamic>>().map(TxModel.fromJson).toList(),
    );
    if (cached != null) return cached;

    try {
      final r = await _client.query(QueryOptions(
        document: gql(transactionHistoryQuery),
        variables: {'accountId': accountId, 'limit': limit, 'offset': offset},
      ));
      if (r.hasException) throw r.exception!;
      final txs = (r.data!['transactionHistory'] as List).cast<Map<String, dynamic>>()
          .map((t) => TxModel.fromJson({
            'id': t['id'], 'reference': t['reference'],
            'description': t['description'], 'amount': t['amount'],
            'transactionType': t['transaction_type'], 'status': t['status'],
            'insertedAt': t['inserted_at'],
          })).toList();

      await _cacheService.cacheJson('transactions', accountId, jsonEncode({
        'items': txs.map((t) => t.toJson()).toList(),
      }));

      return txs;
    } catch (e) {
      final stale = await _cacheService.getStaleValue<List<TxModel>>(
        'transactions', accountId,
        (json) => (json['items'] as List).cast<Map<String, dynamic>>().map(TxModel.fromJson).toList(),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }
}
