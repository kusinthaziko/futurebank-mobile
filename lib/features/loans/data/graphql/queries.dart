const String myLoansQuery = r'''
  query MyLoans {
    myLoans {
      id
      status
      amount_requested
      amount_approved
      purpose
      repayment_period_weeks
      interest_rate
      ai_risk_score
      ai_risk_summary
      submitted_at
      decided_at
      disbursed_at
    }
    loanEligibility {
      eligible
      max_amount
      reason
    }
  }
''';

const String repaymentScheduleQuery = r'''
  query RepaymentSchedule($loanId: ID!) {
    repaymentSchedule(loanId: $loanId) {
      id
      instalment_number
      due_date
      amount_due
      amount_paid
      status
      paid_at
    }
  }
''';

const String applyLoanMutation = r'''
  mutation ApplyForLoan($amount: Decimal!, $purpose: String!, $weeks: Int!) {
    applyForLoan(
      amount: $amount
      purpose: $purpose
      repayment_period_weeks: $weeks
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
