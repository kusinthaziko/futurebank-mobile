const String dashboardExtrasQuery = r'''
  query DashboardExtras {
    savingsGoals(accountId: "") {
      id name target_amount current_amount deadline category status
    }
    activeChallenges {
      id name description type progress streak_days days_remaining status
    }
    aiInsight {
      message type
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
