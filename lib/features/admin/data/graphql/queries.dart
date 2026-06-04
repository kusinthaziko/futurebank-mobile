const String pendingDepositsQuery = r'''
  query PendingDeposits {
    transactionHistory(accountId: "", limit: 50) {
      id reference amount description status inserted_at
    }
  }
''';

const String pendingLoansQuery = r'''
  query PendingLoans($institutionId: ID!) {
    pendingLoans(institutionId: $institutionId) {
      id amount_requested purpose status ai_risk_score ai_risk_summary
      applicant_id submitted_at
    }
  }
''';

const String confirmDepositMutation = r'''
  mutation ConfirmDeposit($transactionId: ID!) {
    confirmDeposit(transaction_id: $transactionId) {
      id status
    }
  }
''';

const String approveLoanMutation = r'''
  mutation ApproveLoan($loanId: ID!, $amountApproved: String!, $notes: String) {
    approveLoan(loan_id: $loanId, amount_approved: $amountApproved, notes: $notes) {
      id status
    }
  }
''';

const String rejectLoanMutation = r'''
  mutation RejectLoan($loanId: ID!, $notes: String!) {
    rejectLoan(loan_id: $loanId, notes: $notes) {
      id status
    }
  }
''';

const String adminStudentsQuery = r'''
  query AdminStudents($search: String) {
    adminStudents(search: $search) {
      id full_name kyc_level health_score balance avatar_url
    }
  }
''';

const String adminReportsQuery = r'''
  query AdminReports {
    adminReports {
      totalSavings activeLoanCount activeLoanValue defaultRate
      kycLevelDistribution { level count }
    }
  }
''';
