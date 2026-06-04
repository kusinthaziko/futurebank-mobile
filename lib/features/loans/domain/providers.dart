import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../../auth/domain/auth_state.dart';
import '../data/models/loan_models.dart';
import '../data/repository.dart';

final loanRepositoryProvider = Provider.family<LoanRepository, String?>(
  (ref, token) => LoanRepository(ref.read(graphQLClientProvider(token))),
);

final loansProvider = FutureProvider.autoDispose<
    ({List<LoanModel> loans, LoanEligibility eligibility})>((ref) async {
  final auth = ref.watch(authProvider);
  final token = auth is Authenticated ? auth.accessToken : null;
  return ref.read(loanRepositoryProvider(token)).fetchLoans();
});

final repaymentScheduleProvider =
    FutureProvider.autoDispose.family<List<RepaymentInstalment>, String>(
  (ref, loanId) async {
    final auth = ref.watch(authProvider);
    final token = auth is Authenticated ? auth.accessToken : null;
    return ref.read(loanRepositoryProvider(token)).fetchSchedule(loanId);
  },
);
