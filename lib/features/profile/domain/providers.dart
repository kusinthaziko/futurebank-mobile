import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../data/models/profile_models.dart';
import '../data/repository.dart';

final profileRepositoryProvider = Provider.family<ProfileRepository, String?>(
  (ref, token) => ProfileRepository(ref.read(graphQLClientProvider(token))),
);

final profileProvider = FutureProvider.autoDispose<ProfileData>((ref) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(profileRepositoryProvider(token)).fetchProfile();
});

final badgesProvider = FutureProvider.autoDispose<List<BadgeModel>>((ref) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(profileRepositoryProvider(token)).fetchBadges();
});
