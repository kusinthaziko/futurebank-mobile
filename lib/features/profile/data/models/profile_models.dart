import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_models.freezed.dart';
part 'profile_models.g.dart';

@freezed
class ProfileData with _$ProfileData {
  const factory ProfileData({
    required UserProfile user,
    required HealthScoreData healthScore,
  }) = _ProfileData;
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String fullName,
    required String email,
    required int kycLevel,
    required String kycStatus,
    required int financialHealthScore,
    String? blockchainDid,
    String? avatarUrl,
  }) = _UserProfile;
  factory UserProfile.fromJson(Map<String, dynamic> j) => _$UserProfileFromJson(j);
}

@freezed
class HealthScoreData with _$HealthScoreData {
  const factory HealthScoreData({
    required int score,
    required double savingsConsistency,
    required double loanRepaymentRate,
    required int challengeCompletions,
    required int accountAgeDays,
    required int kycLevel,
  }) = _HealthScoreData;
  factory HealthScoreData.fromJson(Map<String, dynamic> j) => _$HealthScoreDataFromJson(j);
}

@freezed
class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String badgeId,
    required String name,
    required String awardedAt,
  }) = _BadgeModel;
  factory BadgeModel.fromJson(Map<String, dynamic> j) => _$BadgeModelFromJson(j);
}
