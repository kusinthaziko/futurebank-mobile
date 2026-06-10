// Single responsibility: pure data models — no UI, no GraphQL
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required AccountModel primaryAccount,
    required UserModel user,
    required List<TransactionModel> recentTransactions,
    HealthScoreModel? healthScore,
  }) = _DashboardData;
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String fullName,
    required int financialHealthScore,
    required int kycLevel,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required String accountNumber,
    required String accountType,
    required String balance,
    required String currency,
    required String status,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String reference,
    String? description,
    required String amount,
    required String transactionType,
    required String status,
    required String insertedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

@freezed
class HealthScoreModel with _$HealthScoreModel {
  const factory HealthScoreModel({
    required int score,
    required double savingsConsistency,
    required double loanRepaymentRate,
    required int challengeCompletions,
  }) = _HealthScoreModel;

  factory HealthScoreModel.fromJson(Map<String, dynamic> json) =>
      _$HealthScoreModelFromJson(json);
}
