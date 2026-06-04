import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/graphql/client.dart';
import '../data/models/profile_models.dart';
import '../data/repository.dart';

final profileRepositoryProvider = Provider.family<ProfileRepository, String?>(
  (ref, token) => ProfileRepository(
    ref.read(graphQLClientProvider(token)),
    ref.read(cacheServiceProvider),
  ),
);

final profileProvider = FutureProvider.autoDispose<ProfileData>((ref) async {
  final token = ref.watch(accessTokenProvider);
  final userId = ref.watch(userIdProvider) ?? '';
  return ref.read(profileRepositoryProvider(token)).fetchProfile(userId);
});

final badgesProvider = FutureProvider.autoDispose<List<BadgeModel>>((ref) async {
  final token = ref.watch(accessTokenProvider);
  return ref.read(profileRepositoryProvider(token)).fetchBadges();
});
