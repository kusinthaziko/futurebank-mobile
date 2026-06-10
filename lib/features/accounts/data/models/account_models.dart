import 'package:freezed_annotation/freezed_annotation.dart';
part 'account_models.freezed.dart';
part 'account_models.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required String accountNumber,
    required String accountType,
    required String balance,
    required String currency,
    required String status,
    required String interestRate,
  }) = _AccountModel;
  factory AccountModel.fromJson(Map<String, dynamic> j) =>
      _$AccountModelFromJson(j);
}

@freezed
class SavingsGoalModel with _$SavingsGoalModel {
  const factory SavingsGoalModel({
    required String id,
    required String name,
    required String targetAmount,
    required String currentAmount,
    String? deadline,
    required String category,
    required String status,
  }) = _SavingsGoalModel;
  factory SavingsGoalModel.fromJson(Map<String, dynamic> j) =>
      _$SavingsGoalModelFromJson(j);
}

@freezed
class TxModel with _$TxModel {
  const factory TxModel({
    required String id,
    required String reference,
    String? description,
    required String amount,
    required String transactionType,
    required String status,
    required String insertedAt,
  }) = _TxModel;
  factory TxModel.fromJson(Map<String, dynamic> j) => _$TxModelFromJson(j);
}
