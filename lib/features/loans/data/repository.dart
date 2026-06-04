import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/services/cache_service.dart';
import 'graphql/queries.dart';
import 'models/loan_models.dart';

class LoanRepository {
  final GraphQLClient _client;
  final CacheService _cacheService;
  const LoanRepository(this._client, this._cacheService);

  Future<({List<LoanModel> loans, LoanEligibility eligibility})> fetchLoans() async {
    final cached = await _cacheService.getFreshValue<({List<LoanModel> loans, LoanEligibility eligibility})>(
      'loans', 'all',
      (json) => (
        loans: (json['loans'] as List).cast<Map<String, dynamic>>().map(LoanModel.fromJson).toList(),
        eligibility: LoanEligibility.fromJson(json['eligibility'] as Map<String, dynamic>),
      ),
    );
    if (cached != null) return cached;

    try {
      final result = await _client.query(QueryOptions(
        document: gql(myLoansQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ));
      if (result.hasException) throw result.exception!;

      final loans = (result.data!['myLoans'] as List)
          .cast<Map<String, dynamic>>()
          .map((l) => LoanModel.fromJson({
                'id': l['id'],
                'status': l['status'],
                'amountRequested': l['amount_requested'],
                'amountApproved': l['amount_approved'],
                'purpose': l['purpose'],
                'repaymentPeriodWeeks': l['repayment_period_weeks'],
                'interestRate': l['interest_rate'],
                'aiRiskScore': l['ai_risk_score'],
                'aiRiskSummary': l['ai_risk_summary'],
                'blockchainContractHash': l['blockchain_contract_hash'],
                'submittedAt': l['submitted_at'],
                'decidedAt': l['decided_at'],
                'disbursedAt': l['disbursed_at'],
              }))
          .toList();

      final e = result.data!['loanEligibility'] as Map<String, dynamic>;
      final eligibility = LoanEligibility.fromJson({
        'eligible': e['eligible'] ?? false,
        'maxAmount': e['max_amount'] ?? '0',
        'reason': e['reason'],
      });

      await _cacheService.cacheJson('loans', 'all', jsonEncode({
        'loans': loans.map((l) => l.toJson()).toList(),
        'eligibility': eligibility.toJson(),
      }));

      return (loans: loans, eligibility: eligibility);
    } catch (e) {
      final stale = await _cacheService.getStaleValue<({List<LoanModel> loans, LoanEligibility eligibility})>(
        'loans', 'all',
        (json) => (
          loans: (json['loans'] as List).cast<Map<String, dynamic>>().map(LoanModel.fromJson).toList(),
          eligibility: LoanEligibility.fromJson(json['eligibility'] as Map<String, dynamic>),
        ),
      );
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<RepaymentInstalment>> fetchSchedule(String loanId) async {
    final result = await _client.query(QueryOptions(
      document: gql(repaymentScheduleQuery),
      variables: {'loanId': loanId},
    ));
    if (result.hasException) throw result.exception!;

    return (result.data!['repaymentSchedule'] as List)
        .cast<Map<String, dynamic>>()
        .map((r) => RepaymentInstalment.fromJson({
              'id': r['id'],
              'instalmentNumber': r['instalment_number'],
              'dueDate': r['due_date'],
              'amountDue': r['amount_due'],
              'amountPaid': r['amount_paid'],
              'status': r['status'],
              'paidAt': r['paid_at'],
            }))
        .toList();
  }

  Future<void> applyForLoan({
    required String amount,
    required String purpose,
    required int weeks,
  }) async {
    final result = await _client.mutate(MutationOptions(
      document: gql(applyLoanMutation),
      variables: {'amount': amount, 'purpose': purpose, 'weeks': weeks},
    ));
    if (result.hasException) throw result.exception!;
  }

  Future<void> makeRepayment(String loanId, String amount) async {
    final result = await _client.mutate(MutationOptions(
      document: gql(makeRepaymentMutation),
      variables: {'loanId': loanId, 'amount': amount},
    ));
    if (result.hasException) throw result.exception!;
  }
}
