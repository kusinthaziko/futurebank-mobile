// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      id: json['id'] as String,
      accountNumber: json['accountNumber'] as String,
      accountType: json['accountType'] as String,
      balance: json['balance'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String,
      interestRate: json['interestRate'] as String,
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountNumber': instance.accountNumber,
      'accountType': instance.accountType,
      'balance': instance.balance,
      'currency': instance.currency,
      'status': instance.status,
      'interestRate': instance.interestRate,
    };

_$SavingsGoalModelImpl _$$SavingsGoalModelImplFromJson(
  Map<String, dynamic> json,
) => _$SavingsGoalModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  targetAmount: json['targetAmount'] as String,
  currentAmount: json['currentAmount'] as String,
  deadline: json['deadline'] as String?,
  category: json['category'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$$SavingsGoalModelImplToJson(
  _$SavingsGoalModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'targetAmount': instance.targetAmount,
  'currentAmount': instance.currentAmount,
  'deadline': instance.deadline,
  'category': instance.category,
  'status': instance.status,
};

_$TxModelImpl _$$TxModelImplFromJson(Map<String, dynamic> json) =>
    _$TxModelImpl(
      id: json['id'] as String,
      reference: json['reference'] as String,
      description: json['description'] as String?,
      amount: json['amount'] as String,
      transactionType: json['transactionType'] as String,
      status: json['status'] as String,
      insertedAt: json['insertedAt'] as String,
    );

Map<String, dynamic> _$$TxModelImplToJson(_$TxModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'description': instance.description,
      'amount': instance.amount,
      'transactionType': instance.transactionType,
      'status': instance.status,
      'insertedAt': instance.insertedAt,
    };
