const String myLoansQuery = r'''
  query MyLoans {
    myLoans {
      id
      status
      amountRequested
      amountApproved
      purpose
      repaymentPeriodWeeks
      interestRate
      aiRiskScore
      aiRiskSummary
      submittedAt
      decidedAt
      disbursedAt
    }
    loanEligibility {
      eligible
      maxAmount
      reason
    }
  }
''';

const String repaymentScheduleQuery = r'''
  query RepaymentSchedule($loanId: ID!) {
    repaymentSchedule(loanId: $loanId) {
      id
      instalmentNumber
      dueDate
      amountDue
      amountPaid
      status
      paidAt
    }
  }
''';

const String applyLoanMutation = r'''
  mutation ApplyForLoan($amount: Decimal!, $purpose: String!, $weeks: Int!) {
    applyForLoan(
      amount: $amount
      purpose: $purpose
      repaymentPeriodWeeks: $weeks
    ) {
      id
      status
    }
  }
''';

const String makeRepaymentMutation = r'''
  mutation MakeRepayment($loanId: ID!, $amount: Decimal!) {
    makeRepayment(loanId: $loanId, amount: $amount) {
      id
      status
    }
  }
''';
