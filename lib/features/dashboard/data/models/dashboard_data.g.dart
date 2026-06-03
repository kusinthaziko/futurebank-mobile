// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      financialHealthScore: (json['financialHealthScore'] as num).toInt(),
      kycLevel: (json['kycLevel'] as num).toInt(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'financialHealthScore': instance.financialHealthScore,
      'kycLevel': instance.kycLevel,
    };

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      id: json['id'] as String,
      accountNumber: json['accountNumber'] as String,
      accountType: json['accountType'] as String,
      balance: json['balance'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountNumber': instance.accountNumber,
      'accountType': instance.accountType,
      'balance': instance.balance,
      'currency': instance.currency,
      'status': instance.status,
    };

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: json['id'] as String,
  reference: json['reference'] as String,
  description: json['description'] as String?,
  amount: json['amount'] as String,
  transactionType: json['transactionType'] as String,
  status: json['status'] as String,
  insertedAt: json['insertedAt'] as String,
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'description': instance.description,
  'amount': instance.amount,
  'transactionType': instance.transactionType,
  'status': instance.status,
  'insertedAt': instance.insertedAt,
};

_$HealthScoreModelImpl _$$HealthScoreModelImplFromJson(
  Map<String, dynamic> json,
) => _$HealthScoreModelImpl(
  score: (json['score'] as num).toInt(),
  savingsConsistency: (json['savingsConsistency'] as num).toDouble(),
  loanRepaymentRate: (json['loanRepaymentRate'] as num).toDouble(),
  challengeCompletions: (json['challengeCompletions'] as num).toInt(),
);

Map<String, dynamic> _$$HealthScoreModelImplToJson(
  _$HealthScoreModelImpl instance,
) => <String, dynamic>{
  'score': instance.score,
  'savingsConsistency': instance.savingsConsistency,
  'loanRepaymentRate': instance.loanRepaymentRate,
  'challengeCompletions': instance.challengeCompletions,
};
