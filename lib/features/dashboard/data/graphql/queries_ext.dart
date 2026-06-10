const String dashboardExtrasQuery = r'''
  query DashboardExtras {
    savingsGoals {
      id name target_amount current_amount deadline category status
    }
    aiInsight {
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
