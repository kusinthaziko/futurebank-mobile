import 'package:freezed_annotation/freezed_annotation.dart';
part 'social_models.freezed.dart';
part 'social_models.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String id, required String name,
    required String status, String? inviteCode, String? poolAccountId,
  }) = _GroupModel;
  factory GroupModel.fromJson(Map<String, dynamic> j) => _$GroupModelFromJson(j);
}

@freezed
class ChallengeModel with _$ChallengeModel {
  const factory ChallengeModel({
    required String id, required String title,
    required String challengeType, required int rewardPoints,
    required String status, String? endsAt,
  }) = _ChallengeModel;
  factory ChallengeModel.fromJson(Map<String, dynamic> j) => _$ChallengeModelFromJson(j);
}

@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId, required String fullName,
    required int score, required int rank,
  }) = _LeaderboardEntry;
  factory LeaderboardEntry.fromJson(Map<String, dynamic> j) => _$LeaderboardEntryFromJson(j);
}
