// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanModelImpl _$$LoanModelImplFromJson(Map<String, dynamic> json) =>
    _$LoanModelImpl(
      id: json['id'] as String,
      status: json['status'] as String,
      amountRequested: json['amountRequested'] as String,
      amountApproved: json['amountApproved'] as String?,
      purpose: json['purpose'] as String,
      repaymentPeriodWeeks: (json['repaymentPeriodWeeks'] as num).toInt(),
      interestRate: json['interestRate'] as String,
      aiRiskScore: (json['aiRiskScore'] as num?)?.toDouble(),
      aiRiskSummary: json['aiRiskSummary'] as String?,
      blockchainContractHash: json['blockchainContractHash'] as String?,
      submittedAt: json['submittedAt'] as String?,
      decidedAt: json['decidedAt'] as String?,
      disbursedAt: json['disbursedAt'] as String?,
    );

Map<String, dynamic> _$$LoanModelImplToJson(_$LoanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'amountRequested': instance.amountRequested,
      'amountApproved': instance.amountApproved,
      'purpose': instance.purpose,
      'repaymentPeriodWeeks': instance.repaymentPeriodWeeks,
      'interestRate': instance.interestRate,
      'aiRiskScore': instance.aiRiskScore,
      'aiRiskSummary': instance.aiRiskSummary,
      'blockchainContractHash': instance.blockchainContractHash,
      'submittedAt': instance.submittedAt,
      'decidedAt': instance.decidedAt,
      'disbursedAt': instance.disbursedAt,
    };

_$LoanEligibilityImpl _$$LoanEligibilityImplFromJson(
  Map<String, dynamic> json,
) => _$LoanEligibilityImpl(
  eligible: json['eligible'] as bool,
  maxAmount: json['maxAmount'] as String,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$$LoanEligibilityImplToJson(
  _$LoanEligibilityImpl instance,
) => <String, dynamic>{
  'eligible': instance.eligible,
  'maxAmount': instance.maxAmount,
  'reason': instance.reason,
};

_$RepaymentInstalmentImpl _$$RepaymentInstalmentImplFromJson(
  Map<String, dynamic> json,
) => _$RepaymentInstalmentImpl(
  id: json['id'] as String,
  instalmentNumber: (json['instalmentNumber'] as num).toInt(),
  dueDate: json['dueDate'] as String,
  amountDue: json['amountDue'] as String,
  amountPaid: json['amountPaid'] as String,
  status: json['status'] as String,
  paidAt: json['paidAt'] as String?,
);

Map<String, dynamic> _$$RepaymentInstalmentImplToJson(
  _$RepaymentInstalmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'instalmentNumber': instance.instalmentNumber,
  'dueDate': instance.dueDate,
  'amountDue': instance.amountDue,
  'amountPaid': instance.amountPaid,
  'status': instance.status,
  'paidAt': instance.paidAt,
};
