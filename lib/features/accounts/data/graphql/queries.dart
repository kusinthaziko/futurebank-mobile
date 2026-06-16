const String myAccountsQuery = r'''
  query MyAccounts {
    myAccounts {
      id accountNumber accountType balance currency status interestRate
    }
    savingsGoals {
      id name targetAmount currentAmount deadline category status
    }
  }
''';

const String transactionHistoryQuery = r'''
  query TxHistory($accountId: ID!, $limit: Int, $offset: Int) {
    transactionHistory(accountId: $accountId, limit: $limit, offset: $offset) {
      id reference description amount transactionType status insertedAt
    }
  }
''';

const String createSavingsGoalMutation = r'''
  mutation CreateSavingsGoal($input: SavingsGoalInput!) {
    createSavingsGoal(input: $input) { id name status }
  }
''';
