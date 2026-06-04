import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/graphql/client.dart';
import '../data/models/social_models.dart';
import '../data/repository.dart';

final socialRepositoryProvider = Provider.family<SocialRepository, String?>(
  (ref, token) => SocialRepository(
    ref.read(graphQLClientProvider(token)),
    ref.read(cacheServiceProvider),
  ),
);

final socialProvider = FutureProvider.autoDispose.family<
    ({List<GroupModel> groups, List<ChallengeModel> challenges, List<LeaderboardEntry> leaderboard}),
    String>((ref, institutionId) async {
  final token = ref.watch(accessTokenProvider);
  return ref.read(socialRepositoryProvider(token)).fetchSocial(institutionId);
});

final groupDetailProvider = FutureProvider.autoDispose.family<GroupDetailModel, String>(
  (ref, groupId) async {
    final token = ref.watch(accessTokenProvider);
    return ref.read(socialRepositoryProvider(token)).fetchGroupDetail(groupId);
  },
);

final challengeDetailProvider = FutureProvider.autoDispose.family<ChallengeDetailModel, String>(
  (ref, challengeId) async {
    final token = ref.watch(accessTokenProvider);
    return ref.read(socialRepositoryProvider(token)).fetchChallengeDetail(challengeId);
  },
);

final leaderboardListProvider = FutureProvider.autoDispose.family<List<LeaderboardEntry>, ({String institutionId, String period})>(
  (ref, params) async {
    final token = ref.watch(accessTokenProvider);
    return ref.read(socialRepositoryProvider(token)).fetchLeaderboard(params.institutionId, params.period);
  },
);
