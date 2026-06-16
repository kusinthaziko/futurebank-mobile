import 'package:freezed_annotation/freezed_annotation.dart';
part 'social_models.freezed.dart';
part 'social_models.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String id,
    required String name,
    required String status,
    String? inviteCode,
    String? poolAccountId,
  }) = _GroupModel;
  factory GroupModel.fromJson(Map<String, dynamic> j) =>
      _$GroupModelFromJson(j);
}

@freezed
class ChallengeModel with _$ChallengeModel {
  const factory ChallengeModel({
    required String id,
    required String title,
    required String challengeType,
    required int rewardPoints,
    required String status,
    String? endsAt,
  }) = _ChallengeModel;
  factory ChallengeModel.fromJson(Map<String, dynamic> j) =>
      _$ChallengeModelFromJson(j);
}

@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    required String fullName,
    required int score,
    required int rank,
  }) = _LeaderboardEntry;
  factory LeaderboardEntry.fromJson(Map<String, dynamic> j) =>
      _$LeaderboardEntryFromJson(j);
}

// --- Extended detail models (not freezed) ---

class GroupDetailModel {
  final String id;
  final String name;
  final String status;
  final String? inviteCode;
  final String? poolAccountId;
  final String poolBalance;
  final int memberCount;
  final String? goal;
  final String groupType;
  final List<Contributor> topContributors;
  final List<GroupActivity> recentActivity;

  GroupDetailModel({
    required this.id,
    required this.name,
    required this.status,
    this.inviteCode,
    this.poolAccountId,
    this.poolBalance = '0',
    this.memberCount = 0,
    this.goal,
    this.groupType = 'Savings Circle',
    this.topContributors = const [],
    this.recentActivity = const [],
  });

  factory GroupDetailModel.fromJson(Map<String, dynamic> json) =>
      GroupDetailModel(
        id: json['id'] as String,
        name: json['name'] as String,
        status: json['status'] as String? ?? 'active',
        inviteCode: json['inviteCode'] as String?,
        poolAccountId: json['poolAccountId'] as String?,
        poolBalance: json['poolBalance'] as String? ?? '0',
        memberCount: json['memberCount'] as int? ?? 0,
        goal: json['goal'] as String?,
        groupType: json['groupType'] as String? ?? 'Savings Circle',
        topContributors:
            (json['top_contributors'] as List?)
                ?.map((e) => Contributor.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        recentActivity:
            (json['recent_activity'] as List?)
                ?.map((e) => GroupActivity.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class Contributor {
  final String userId;
  final String fullName;
  final String totalContributed;
  final String? avatarUrl;

  Contributor({
    required this.userId,
    required this.fullName,
    required this.totalContributed,
    this.avatarUrl,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
    userId: json['userId'] as String,
    fullName: json['fullName'] as String,
    totalContributed: json['totalContributed'] as String? ?? '0',
    avatarUrl: json['avatarUrl'] as String?,
  );
}

class GroupActivity {
  final String userId;
  final String fullName;
  final String action;
  final String amount;
  final String createdAt;

  GroupActivity({
    required this.userId,
    required this.fullName,
    required this.action,
    this.amount = '',
    required this.createdAt,
  });

  factory GroupActivity.fromJson(Map<String, dynamic> json) => GroupActivity(
    userId: json['userId'] as String,
    fullName: json['fullName'] as String,
    action: json['action'] as String,
    amount: json['amount'] as String? ?? '',
    createdAt: json['createdAt'] as String,
  );
}

class ChallengeDetailModel {
  final String id;
  final String title;
  final String? description;
  final String challengeType;
  final int rewardPoints;
  final String status;
  final String? endsAt;
  final int participantCount;
  final List<LeaderboardEntry> leaderboard;
  final int currentProgress;
  final int targetProgress;
  final bool joined;

  ChallengeDetailModel({
    required this.id,
    required this.title,
    this.description,
    required this.challengeType,
    required this.rewardPoints,
    required this.status,
    this.endsAt,
    this.participantCount = 0,
    this.leaderboard = const [],
    this.currentProgress = 0,
    this.targetProgress = 1,
    this.joined = false,
  });

  factory ChallengeDetailModel.fromJson(Map<String, dynamic> json) =>
      ChallengeDetailModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        challengeType: json['challengeType'] as String,
        rewardPoints: json['rewardPoints'] as int? ?? 0,
        status: json['status'] as String? ?? 'active',
        endsAt: json['endsAt'] as String?,
        participantCount: json['participantCount'] as int? ?? 0,
        currentProgress: json['currentProgress'] as int? ?? 0,
        targetProgress: json['targetProgress'] as int? ?? 1,
        joined: json['joined'] as bool? ?? false,
        leaderboard:
            (json['leaderboard'] as List?)
                ?.map(
                  (e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
      );
}
