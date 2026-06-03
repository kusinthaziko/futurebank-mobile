import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../data/models/loan_models.dart';
import '../data/repository.dart';

final loanRepositoryProvider = Provider.family<LoanRepository, String?>(
  (ref, token) => LoanRepository(ref.read(graphQLClientProvider(token))),
);

final loansProvider = FutureProvider.autoDispose<
    ({List<LoanModel> loans, LoanEligibility eligibility})>((ref) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(loanRepositoryProvider(token)).fetchLoans();
});

final repaymentScheduleProvider =
    FutureProvider.autoDispose.family<List<RepaymentInstalment>, String>(
  (ref, loanId) async {
    final token = ref.watch(authProvider).accessToken;
    return ref.read(loanRepositoryProvider(token)).fetchSchedule(loanId);
  },
);
