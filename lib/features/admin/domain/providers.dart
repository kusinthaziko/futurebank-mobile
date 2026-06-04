import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../data/repository.dart';

final adminRepositoryProvider = Provider.family<AdminRepository, String?>(
  (ref, token) => AdminRepository(ref.read(graphQLClientProvider(token))),
);

final pendingDepositsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final token = ref.watch(accessTokenProvider);
  return ref.read(adminRepositoryProvider(token)).fetchPendingDeposits();
});

final pendingLoansProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final token = ref.watch(accessTokenProvider);
  final institutionId = ref.watch(institutionIdProvider) ?? '';
  return ref.read(adminRepositoryProvider(token)).fetchPendingLoans(institutionId);
});

final adminStudentsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String?>(
  (ref, search) async {
    final token = ref.watch(accessTokenProvider);
    return ref.read(adminRepositoryProvider(token)).fetchStudents(search);
  },
);

final adminReportsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final token = ref.watch(accessTokenProvider);
  return ref.read(adminRepositoryProvider(token)).fetchReports();
});
