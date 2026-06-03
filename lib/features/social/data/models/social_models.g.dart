// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupModelImpl _$$GroupModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      inviteCode: json['inviteCode'] as String?,
      poolAccountId: json['poolAccountId'] as String?,
    );

Map<String, dynamic> _$$GroupModelImplToJson(_$GroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'inviteCode': instance.inviteCode,
      'poolAccountId': instance.poolAccountId,
    };

_$ChallengeModelImpl _$$ChallengeModelImplFromJson(Map<String, dynamic> json) =>
    _$ChallengeModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      challengeType: json['challengeType'] as String,
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      status: json['status'] as String,
      endsAt: json['endsAt'] as String?,
    );

Map<String, dynamic> _$$ChallengeModelImplToJson(
  _$ChallengeModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'challengeType': instance.challengeType,
  'rewardPoints': instance.rewardPoints,
  'status': instance.status,
  'endsAt': instance.endsAt,
};

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  userId: json['userId'] as String,
  fullName: json['fullName'] as String,
  score: (json['score'] as num).toInt(),
  rank: (json['rank'] as num).toInt(),
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'fullName': instance.fullName,
  'score': instance.score,
  'rank': instance.rank,
};
