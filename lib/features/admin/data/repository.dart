import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/queries.dart';

class AdminRepository {
  final GraphQLClient _client;
  const AdminRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchPendingDeposits() async {
    final r = await _client.query(QueryOptions(
      document: gql(pendingDepositsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (r.hasException) throw r.exception!;
    return ((r.data!['transactionHistory'] as List?) ?? [])
        .cast<Map<String, dynamic>>()
        .where((t) => t['status'] == 'pending')
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchPendingLoans(String institutionId) async {
    final r = await _client.query(QueryOptions(
      document: gql(pendingLoansQuery),
      variables: {'institutionId': institutionId},
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (r.hasException) throw r.exception!;
    return (r.data!['pendingLoans'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  Future<void> confirmDeposit(String transactionId) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(confirmDepositMutation),
      variables: {'transactionId': transactionId},
    ));
    if (r.hasException) throw r.exception!;
  }

  Future<void> approveLoan(String loanId, String amountApproved, String? notes) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(approveLoanMutation),
      variables: {'loanId': loanId, 'amountApproved': amountApproved, 'notes': notes},
    ));
    if (r.hasException) throw r.exception!;
  }

  Future<void> rejectLoan(String loanId, String notes) async {
    final r = await _client.mutate(MutationOptions(
      document: gql(rejectLoanMutation),
      variables: {'loanId': loanId, 'notes': notes},
    ));
    if (r.hasException) throw r.exception!;
  }

  Future<List<Map<String, dynamic>>> fetchStudents(String? search) async {
    final r = await _client.query(QueryOptions(
      document: gql(adminStudentsQuery),
      variables: {'search': search},
    ));
    if (r.hasException) throw r.exception!;
    return (r.data!['adminStudents'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  Future<Map<String, dynamic>> fetchReports() async {
    final r = await _client.query(QueryOptions(
      document: gql(adminReportsQuery),
    ));
    if (r.hasException) throw r.exception!;
    return (r.data!['adminReports'] as Map<String, dynamic>?) ?? {};
  }
}
