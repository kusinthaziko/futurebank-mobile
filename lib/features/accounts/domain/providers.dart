import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../data/models/account_models.dart';
import '../data/repository.dart';

final accountRepositoryProvider = Provider.family<AccountRepository, String?>(
  (ref, token) => AccountRepository(ref.read(graphQLClientProvider(token))),
);

final accountsProvider = FutureProvider.autoDispose<
    ({List<AccountModel> accounts, List<SavingsGoalModel> goals})>((ref) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(accountRepositoryProvider(token)).fetchAccounts();
});

final transactionsProvider =
    FutureProvider.autoDispose.family<List<TxModel>, String>((ref, accountId) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(accountRepositoryProvider(token)).fetchTransactions(accountId);
});
