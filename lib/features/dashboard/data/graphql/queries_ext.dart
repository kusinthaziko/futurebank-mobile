const String dashboardExtrasQuery = r'''
  query DashboardExtras($accountId: ID!) {
    savingsGoals {
      id name targetAmount currentAmount deadline category status
    }
    aiInsight(accountId: $accountId) {
      summary recommendation
    }
  }
''';

const String monthlyDeltaQuery = r'''
  query MonthlyDelta($accountId: ID!) {
    balanceChange(accountId: $accountId) {
      percentage amount
    }
  }
''';
