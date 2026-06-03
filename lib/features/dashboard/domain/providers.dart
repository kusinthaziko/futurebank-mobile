// Single responsibility: Riverpod providers — bridge between data and UI
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../data/models/dashboard_data.dart';
import '../data/repository.dart';

final dashboardRepositoryProvider = Provider.family<DashboardRepository, String?>(
  (ref, token) => DashboardRepository(ref.read(graphQLClientProvider(token))),
);

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(dashboardRepositoryProvider(token)).fetchDashboard();
});

final recentTransactionsProvider =
    FutureProvider.autoDispose<List<TransactionModel>>((ref) async {
  final dashboard = await ref.watch(dashboardProvider.future);
  final token = ref.watch(authProvider).accessToken;
  return ref.read(dashboardRepositoryProvider(token))
      .fetchRecentTransactions(dashboard.primaryAccount.id);
});
