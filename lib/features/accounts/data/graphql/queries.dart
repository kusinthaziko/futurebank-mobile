const String myAccountsQuery = r'''
  query MyAccounts {
    myAccounts {
      id account_number account_type balance currency status interest_rate
    }
    savingsGoals(accountId: "") {
      id name target_amount current_amount deadline category status
    }
  }
''';

const String transactionHistoryQuery = r'''
  query TxHistory($accountId: ID!, $limit: Int, $offset: Int) {
    transactionHistory(accountId: $accountId, limit: $limit, offset: $offset) {
      id reference description amount transaction_type status inserted_at
    }
  }
''';

const String createSavingsGoalMutation = r'''
  mutation CreateSavingsGoal($input: SavingsGoalInput!) {
    createSavingsGoal(input: $input) { id name status }
  }
''';
