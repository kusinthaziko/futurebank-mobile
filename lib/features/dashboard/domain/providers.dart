// Single responsibility: Riverpod providers — bridge between data and UI
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/graphql/client.dart';
import '../../../features/auth/domain/auth_state.dart';
import '../data/models/dashboard_data.dart';
import '../data/models/savings_goal_model.dart';
import '../data/models/challenge_model.dart';
import '../data/models/ai_insight_model.dart';
import '../data/repository.dart';

String? _token(AuthState auth) => switch (auth) {
  Authenticated(:final accessToken) => accessToken,
  _ => null,
};

String? _userId(AuthState auth) => switch (auth) {
  Authenticated(:final userId) => userId,
  _ => null,
};

final dashboardRepositoryProvider = Provider.family<DashboardRepository, String?>(
  (ref, token) => DashboardRepository(
    ref.read(graphQLClientProvider(token)),
    ref.read(cacheServiceProvider),
  ),
);

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final auth = ref.watch(authProvider);
  final token = _token(auth);
  final userId = _userId(auth) ?? '';
  return ref.read(dashboardRepositoryProvider(token)).fetchDashboard(userId);
});

final recentTransactionsProvider =
    FutureProvider.autoDispose<List<TransactionModel>>((ref) async {
  final dashboard = await ref.watch(dashboardProvider.future);
  final token = _token(ref.watch(authProvider));
  return ref.read(dashboardRepositoryProvider(token))
      .fetchRecentTransactions(dashboard.primaryAccount.id);
});

final savingsGoalsProvider = FutureProvider.autoDispose<List<SavingsGoalModel>>((ref) async {
  final token = _token(ref.watch(authProvider));
  return ref.read(dashboardRepositoryProvider(token)).fetchSavingsGoals();
});

final activeChallengeProvider = FutureProvider.autoDispose<ChallengeModel?>((ref) async {
  final token = _token(ref.watch(authProvider));
  return ref.read(dashboardRepositoryProvider(token)).fetchActiveChallenge();
});

final aiInsightProvider = FutureProvider.autoDispose<AiInsightModel?>((ref) async {
  final token = _token(ref.watch(authProvider));
  return ref.read(dashboardRepositoryProvider(token)).fetchAiInsight();
});

final monthlyDeltaProvider = FutureProvider.autoDispose.family<double?, String>((ref, accountId) async {
  final token = _token(ref.watch(authProvider));
  return ref.read(dashboardRepositoryProvider(token)).fetchMonthlyDelta(accountId);
});
