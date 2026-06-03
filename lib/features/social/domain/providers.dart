import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../data/models/social_models.dart';
import '../data/repository.dart';

final socialRepositoryProvider = Provider.family<SocialRepository, String?>(
  (ref, token) => SocialRepository(ref.read(graphQLClientProvider(token))),
);

final socialProvider = FutureProvider.autoDispose.family<
    ({List<GroupModel> groups, List<ChallengeModel> challenges, List<LeaderboardEntry> leaderboard}),
    String>((ref, institutionId) async {
  final token = ref.watch(authProvider).accessToken;
  return ref.read(socialRepositoryProvider(token)).fetchSocial(institutionId);
});
