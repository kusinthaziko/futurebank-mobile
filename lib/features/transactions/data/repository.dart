import 'package:graphql_flutter/graphql_flutter.dart';
import '../../accounts/data/models/account_models.dart';
import 'graphql/queries.dart';

class TransactionRepository {
  final GraphQLClient _client;
  const TransactionRepository(this._client);

  Future<List<TxModel>> fetchTransactions({
    required String accountId,
    int limit = 20,
    int offset = 0,
    String? type,
    String? dateFrom,
    String? dateTo,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(transactionFilterQuery),
        variables: {
          'accountId': accountId,
          'limit': limit,
          'offset': offset,
          'type': type,
          'dateFrom': dateFrom,
          'dateTo': dateTo,
        },
      ),
    );
    if (result.hasException) throw result.exception!;
    return (result.data!['filteredTransactions'] as List)
        .cast<Map<String, dynamic>>()
        .map(
          (t) => TxModel.fromJson({
            'id': t['id'],
            'reference': t['reference'],
            'description': t['description'],
            'amount': t['amount'],
            'transactionType': t['transaction_type'],
            'status': t['status'],
            'insertedAt': t['inserted_at'],
          }),
        )
        .toList();
  }

  Future<List<TxModel>> searchTransactions({
    required String accountId,
    required String query,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(searchTransactionsQuery),
        variables: {'accountId': accountId, 'query': query},
      ),
    );
    if (result.hasException) throw result.exception!;
    return (result.data!['searchTransactions'] as List)
        .cast<Map<String, dynamic>>()
        .map(
          (t) => TxModel.fromJson({
            'id': t['id'],
            'reference': t['reference'],
            'description': t['description'],
            'amount': t['amount'],
            'transactionType': t['transaction_type'],
            'status': t['status'],
            'insertedAt': t['inserted_at'],
          }),
        )
        .toList();
  }
}
