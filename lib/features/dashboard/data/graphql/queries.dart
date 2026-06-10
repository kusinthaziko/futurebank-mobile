const String dashboardQuery = r'''
  query Dashboard {
    me {
      id full_name financial_health_score kyc_level
    }
    myAccounts {
      id account_number account_type balance currency status
    }
    financialHealthScore {
      score savings_consistency loan_repayment_rate challenge_completions computed_at
    }
  }
''';

const String recentTransactionsQuery = r'''
  query RecentTransactions($accountId: ID!, $limit: Int) {
    transactionHistory(accountId: $accountId, limit: $limit) {
      id reference description amount transaction_type status inserted_at
    }
  }
''';
