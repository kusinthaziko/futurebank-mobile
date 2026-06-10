import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/graphql/client.dart';
import '../../../features/auth/domain/auth_state.dart';
import '../data/models/account_models.dart';
import '../data/repository.dart';

String? _token(AuthState auth) => switch (auth) {
  Authenticated(:final accessToken) => accessToken,
  _ => null,
};

final accountRepositoryProvider = Provider.family<AccountRepository, String?>(
  (ref, token) => AccountRepository(
    ref.read(graphQLClientProvider(token)),
    ref.read(cacheServiceProvider),
  ),
);

final accountsProvider =
    FutureProvider.autoDispose<
      ({List<AccountModel> accounts, List<SavingsGoalModel> goals})
    >((ref) async {
      final token = _token(ref.watch(authProvider));
      return ref.read(accountRepositoryProvider(token)).fetchAccounts();
    });

final transactionsProvider = FutureProvider.autoDispose
    .family<List<TxModel>, String>((ref, accountId) async {
      final token = _token(ref.watch(authProvider));
      return ref
          .read(accountRepositoryProvider(token))
          .fetchTransactions(accountId);
    });
