import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_models.freezed.dart';
part 'loan_models.g.dart';

@freezed
class LoanModel with _$LoanModel {
  const factory LoanModel({
    required String id,
    required String status,
    required String amountRequested,
    String? amountApproved,
    required String purpose,
    required int repaymentPeriodWeeks,
    required String interestRate,
    double? aiRiskScore,
    String? aiRiskSummary,
    String? blockchainContractHash,
    String? submittedAt,
    String? decidedAt,
    String? disbursedAt,
  }) = _LoanModel;

  factory LoanModel.fromJson(Map<String, dynamic> json) => _$LoanModelFromJson(json);
}

@freezed
class LoanEligibility with _$LoanEligibility {
  const factory LoanEligibility({
    required bool eligible,
    required String maxAmount,
    String? reason,
  }) = _LoanEligibility;

  factory LoanEligibility.fromJson(Map<String, dynamic> json) =>
      _$LoanEligibilityFromJson(json);
}

@freezed
class RepaymentInstalment with _$RepaymentInstalment {
  const factory RepaymentInstalment({
    required String id,
    required int instalmentNumber,
    required String dueDate,
    required String amountDue,
    required String amountPaid,
    required String status,
    String? paidAt,
  }) = _RepaymentInstalment;

  factory RepaymentInstalment.fromJson(Map<String, dynamic> json) =>
      _$RepaymentInstalmentFromJson(json);
}
