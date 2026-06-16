const String searchTransactionsQuery = r'''
  query SearchTransactions($query: String!) {
    searchTransactions(query: $query) {
      id reference description amount transactionType status insertedAt
    }
  }
''';

const String transactionFilterQuery = r'''
  query FilteredTransactions(
    $accountId: ID!
    $type: String
    $dateFrom: String
    $dateTo: String
    $limit: Int
    $offset: Int
  ) {
    filteredTransactions(
      accountId: $accountId
      type: $type
      dateFrom: $dateFrom
      dateTo: $dateTo
      limit: $limit
      offset: $offset
    ) {
      id reference description amount transactionType status insertedAt
    }
  }
''';

const String transactionUpdatedSubscription = r'''
  subscription TxUpdated($accountId: ID!) {
    transactionUpdated(accountId: $accountId) {
      id reference description amount transactionType status insertedAt
    }
  }
''';
