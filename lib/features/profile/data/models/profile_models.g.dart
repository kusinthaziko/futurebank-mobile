// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      kycLevel: (json['kycLevel'] as num).toInt(),
      kycStatus: json['kycStatus'] as String,
      financialHealthScore: (json['financialHealthScore'] as num).toInt(),
      blockchainDid: json['blockchainDid'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'kycLevel': instance.kycLevel,
      'kycStatus': instance.kycStatus,
      'financialHealthScore': instance.financialHealthScore,
      'blockchainDid': instance.blockchainDid,
      'avatarUrl': instance.avatarUrl,
    };

_$HealthScoreDataImpl _$$HealthScoreDataImplFromJson(
  Map<String, dynamic> json,
) => _$HealthScoreDataImpl(
  score: (json['score'] as num).toInt(),
  savingsConsistency: (json['savingsConsistency'] as num).toDouble(),
  loanRepaymentRate: (json['loanRepaymentRate'] as num).toDouble(),
  challengeCompletions: (json['challengeCompletions'] as num).toInt(),
  accountAgeDays: (json['accountAgeDays'] as num).toInt(),
  kycLevel: (json['kycLevel'] as num).toInt(),
);

Map<String, dynamic> _$$HealthScoreDataImplToJson(
  _$HealthScoreDataImpl instance,
) => <String, dynamic>{
  'score': instance.score,
  'savingsConsistency': instance.savingsConsistency,
  'loanRepaymentRate': instance.loanRepaymentRate,
  'challengeCompletions': instance.challengeCompletions,
  'accountAgeDays': instance.accountAgeDays,
  'kycLevel': instance.kycLevel,
};

_$BadgeModelImpl _$$BadgeModelImplFromJson(Map<String, dynamic> json) =>
    _$BadgeModelImpl(
      badgeId: json['badgeId'] as String,
      name: json['name'] as String,
      awardedAt: json['awardedAt'] as String,
    );

Map<String, dynamic> _$$BadgeModelImplToJson(_$BadgeModelImpl instance) =>
    <String, dynamic>{
      'badgeId': instance.badgeId,
      'name': instance.name,
      'awardedAt': instance.awardedAt,
    };
