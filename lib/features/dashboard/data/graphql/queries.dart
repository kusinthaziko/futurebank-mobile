const String dashboardQuery = r'''
  query Dashboard {
    me {
      id fullName financialHealthScore kycLevel
    }
    myAccounts {
      id accountNumber accountType balance currency status
    }
    financialHealthScore {
      score savingsConsistency loanRepaymentRate challengeCompletions computedAt
    }
  }
''';

const String recentTransactionsQuery = r'''
  query RecentTransactions($accountId: ID!, $limit: Int) {
    transactionHistory(accountId: $accountId, limit: $limit) {
      id reference description amount transactionType status insertedAt
    }
  }
''';
