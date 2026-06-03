// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoanModel _$LoanModelFromJson(Map<String, dynamic> json) {
  return _LoanModel.fromJson(json);
}

/// @nodoc
mixin _$LoanModel {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get amountRequested => throw _privateConstructorUsedError;
  String? get amountApproved => throw _privateConstructorUsedError;
  String get purpose => throw _privateConstructorUsedError;
  int get repaymentPeriodWeeks => throw _privateConstructorUsedError;
  String get interestRate => throw _privateConstructorUsedError;
  double? get aiRiskScore => throw _privateConstructorUsedError;
  String? get aiRiskSummary => throw _privateConstructorUsedError;
  String? get blockchainContractHash => throw _privateConstructorUsedError;
  String? get submittedAt => throw _privateConstructorUsedError;
  String? get decidedAt => throw _privateConstructorUsedError;
  String? get disbursedAt => throw _privateConstructorUsedError;

  /// Serializes this LoanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanModelCopyWith<LoanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanModelCopyWith<$Res> {
  factory $LoanModelCopyWith(LoanModel value, $Res Function(LoanModel) then) =
      _$LoanModelCopyWithImpl<$Res, LoanModel>;
  @useResult
  $Res call({
    String id,
    String status,
    String amountRequested,
    String? amountApproved,
    String purpose,
    int repaymentPeriodWeeks,
    String interestRate,
    double? aiRiskScore,
    String? aiRiskSummary,
    String? blockchainContractHash,
    String? submittedAt,
    String? decidedAt,
    String? disbursedAt,
  });
}

/// @nodoc
class _$LoanModelCopyWithImpl<$Res, $Val extends LoanModel>
    implements $LoanModelCopyWith<$Res> {
  _$LoanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? amountRequested = null,
    Object? amountApproved = freezed,
    Object? purpose = null,
    Object? repaymentPeriodWeeks = null,
    Object? interestRate = null,
    Object? aiRiskScore = freezed,
    Object? aiRiskSummary = freezed,
    Object? blockchainContractHash = freezed,
    Object? submittedAt = freezed,
    Object? decidedAt = freezed,
    Object? disbursedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            amountRequested: null == amountRequested
                ? _value.amountRequested
                : amountRequested // ignore: cast_nullable_to_non_nullable
                      as String,
            amountApproved: freezed == amountApproved
                ? _value.amountApproved
                : amountApproved // ignore: cast_nullable_to_non_nullable
                      as String?,
            purpose: null == purpose
                ? _value.purpose
                : purpose // ignore: cast_nullable_to_non_nullable
                      as String,
            repaymentPeriodWeeks: null == repaymentPeriodWeeks
                ? _value.repaymentPeriodWeeks
                : repaymentPeriodWeeks // ignore: cast_nullable_to_non_nullable
                      as int,
            interestRate: null == interestRate
                ? _value.interestRate
                : interestRate // ignore: cast_nullable_to_non_nullable
                      as String,
            aiRiskScore: freezed == aiRiskScore
                ? _value.aiRiskScore
                : aiRiskScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            aiRiskSummary: freezed == aiRiskSummary
                ? _value.aiRiskSummary
                : aiRiskSummary // ignore: cast_nullable_to_non_nullable
                      as String?,
            blockchainContractHash: freezed == blockchainContractHash
                ? _value.blockchainContractHash
                : blockchainContractHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            decidedAt: freezed == decidedAt
                ? _value.decidedAt
                : decidedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            disbursedAt: freezed == disbursedAt
                ? _value.disbursedAt
                : disbursedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoanModelImplCopyWith<$Res>
    implements $LoanModelCopyWith<$Res> {
  factory _$$LoanModelImplCopyWith(
    _$LoanModelImpl value,
    $Res Function(_$LoanModelImpl) then,
  ) = __$$LoanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String status,
    String amountRequested,
    String? amountApproved,
    String purpose,
    int repaymentPeriodWeeks,
    String interestRate,
    double? aiRiskScore,
    String? aiRiskSummary,
    String? blockchainContractHash,
    String? submittedAt,
    String? decidedAt,
    String? disbursedAt,
  });
}

/// @nodoc
class __$$LoanModelImplCopyWithImpl<$Res>
    extends _$LoanModelCopyWithImpl<$Res, _$LoanModelImpl>
    implements _$$LoanModelImplCopyWith<$Res> {
  __$$LoanModelImplCopyWithImpl(
    _$LoanModelImpl _value,
    $Res Function(_$LoanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? amountRequested = null,
    Object? amountApproved = freezed,
    Object? purpose = null,
    Object? repaymentPeriodWeeks = null,
    Object? interestRate = null,
    Object? aiRiskScore = freezed,
    Object? aiRiskSummary = freezed,
    Object? blockchainContractHash = freezed,
    Object? submittedAt = freezed,
    Object? decidedAt = freezed,
    Object? disbursedAt = freezed,
  }) {
    return _then(
      _$LoanModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        amountRequested: null == amountRequested
            ? _value.amountRequested
            : amountRequested // ignore: cast_nullable_to_non_nullable
                  as String,
        amountApproved: freezed == amountApproved
            ? _value.amountApproved
            : amountApproved // ignore: cast_nullable_to_non_nullable
                  as String?,
        purpose: null == purpose
            ? _value.purpose
            : purpose // ignore: cast_nullable_to_non_nullable
                  as String,
        repaymentPeriodWeeks: null == repaymentPeriodWeeks
            ? _value.repaymentPeriodWeeks
            : repaymentPeriodWeeks // ignore: cast_nullable_to_non_nullable
                  as int,
        interestRate: null == interestRate
            ? _value.interestRate
            : interestRate // ignore: cast_nullable_to_non_nullable
                  as String,
        aiRiskScore: freezed == aiRiskScore
            ? _value.aiRiskScore
            : aiRiskScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        aiRiskSummary: freezed == aiRiskSummary
            ? _value.aiRiskSummary
            : aiRiskSummary // ignore: cast_nullable_to_non_nullable
                  as String?,
        blockchainContractHash: freezed == blockchainContractHash
            ? _value.blockchainContractHash
            : blockchainContractHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        decidedAt: freezed == decidedAt
            ? _value.decidedAt
            : decidedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        disbursedAt: freezed == disbursedAt
            ? _value.disbursedAt
            : disbursedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanModelImpl implements _LoanModel {
  const _$LoanModelImpl({
    required this.id,
    required this.status,
    required this.amountRequested,
    this.amountApproved,
    required this.purpose,
    required this.repaymentPeriodWeeks,
    required this.interestRate,
    this.aiRiskScore,
    this.aiRiskSummary,
    this.blockchainContractHash,
    this.submittedAt,
    this.decidedAt,
    this.disbursedAt,
  });

  factory _$LoanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanModelImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final String amountRequested;
  @override
  final String? amountApproved;
  @override
  final String purpose;
  @override
  final int repaymentPeriodWeeks;
  @override
  final String interestRate;
  @override
  final double? aiRiskScore;
  @override
  final String? aiRiskSummary;
  @override
  final String? blockchainContractHash;
  @override
  final String? submittedAt;
  @override
  final String? decidedAt;
  @override
  final String? disbursedAt;

  @override
  String toString() {
    return 'LoanModel(id: $id, status: $status, amountRequested: $amountRequested, amountApproved: $amountApproved, purpose: $purpose, repaymentPeriodWeeks: $repaymentPeriodWeeks, interestRate: $interestRate, aiRiskScore: $aiRiskScore, aiRiskSummary: $aiRiskSummary, blockchainContractHash: $blockchainContractHash, submittedAt: $submittedAt, decidedAt: $decidedAt, disbursedAt: $disbursedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amountRequested, amountRequested) ||
                other.amountRequested == amountRequested) &&
            (identical(other.amountApproved, amountApproved) ||
                other.amountApproved == amountApproved) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.repaymentPeriodWeeks, repaymentPeriodWeeks) ||
                other.repaymentPeriodWeeks == repaymentPeriodWeeks) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.aiRiskScore, aiRiskScore) ||
                other.aiRiskScore == aiRiskScore) &&
            (identical(other.aiRiskSummary, aiRiskSummary) ||
                other.aiRiskSummary == aiRiskSummary) &&
            (identical(other.blockchainContractHash, blockchainContractHash) ||
                other.blockchainContractHash == blockchainContractHash) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.decidedAt, decidedAt) ||
                other.decidedAt == decidedAt) &&
            (identical(other.disbursedAt, disbursedAt) ||
                other.disbursedAt == disbursedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    status,
    amountRequested,
    amountApproved,
    purpose,
    repaymentPeriodWeeks,
    interestRate,
    aiRiskScore,
    aiRiskSummary,
    blockchainContractHash,
    submittedAt,
    decidedAt,
    disbursedAt,
  );

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanModelImplCopyWith<_$LoanModelImpl> get copyWith =>
      __$$LoanModelImplCopyWithImpl<_$LoanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanModelImplToJson(this);
  }
}

abstract class _LoanModel implements LoanModel {
  const factory _LoanModel({
    required final String id,
    required final String status,
    required final String amountRequested,
    final String? amountApproved,
    required final String purpose,
    required final int repaymentPeriodWeeks,
    required final String interestRate,
    final double? aiRiskScore,
    final String? aiRiskSummary,
    final String? blockchainContractHash,
    final String? submittedAt,
    final String? decidedAt,
    final String? disbursedAt,
  }) = _$LoanModelImpl;

  factory _LoanModel.fromJson(Map<String, dynamic> json) =
      _$LoanModelImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  String get amountRequested;
  @override
  String? get amountApproved;
  @override
  String get purpose;
  @override
  int get repaymentPeriodWeeks;
  @override
  String get interestRate;
  @override
  double? get aiRiskScore;
  @override
  String? get aiRiskSummary;
  @override
  String? get blockchainContractHash;
  @override
  String? get submittedAt;
  @override
  String? get decidedAt;
  @override
  String? get disbursedAt;

  /// Create a copy of LoanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanModelImplCopyWith<_$LoanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoanEligibility _$LoanEligibilityFromJson(Map<String, dynamic> json) {
  return _LoanEligibility.fromJson(json);
}

/// @nodoc
mixin _$LoanEligibility {
  bool get eligible => throw _privateConstructorUsedError;
  String get maxAmount => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this LoanEligibility to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanEligibility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanEligibilityCopyWith<LoanEligibility> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanEligibilityCopyWith<$Res> {
  factory $LoanEligibilityCopyWith(
    LoanEligibility value,
    $Res Function(LoanEligibility) then,
  ) = _$LoanEligibilityCopyWithImpl<$Res, LoanEligibility>;
  @useResult
  $Res call({bool eligible, String maxAmount, String? reason});
}

/// @nodoc
class _$LoanEligibilityCopyWithImpl<$Res, $Val extends LoanEligibility>
    implements $LoanEligibilityCopyWith<$Res> {
  _$LoanEligibilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanEligibility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eligible = null,
    Object? maxAmount = null,
    Object? reason = freezed,
  }) {
    return _then(
      _value.copyWith(
            eligible: null == eligible
                ? _value.eligible
                : eligible // ignore: cast_nullable_to_non_nullable
                      as bool,
            maxAmount: null == maxAmount
                ? _value.maxAmount
                : maxAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoanEligibilityImplCopyWith<$Res>
    implements $LoanEligibilityCopyWith<$Res> {
  factory _$$LoanEligibilityImplCopyWith(
    _$LoanEligibilityImpl value,
    $Res Function(_$LoanEligibilityImpl) then,
  ) = __$$LoanEligibilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool eligible, String maxAmount, String? reason});
}

/// @nodoc
class __$$LoanEligibilityImplCopyWithImpl<$Res>
    extends _$LoanEligibilityCopyWithImpl<$Res, _$LoanEligibilityImpl>
    implements _$$LoanEligibilityImplCopyWith<$Res> {
  __$$LoanEligibilityImplCopyWithImpl(
    _$LoanEligibilityImpl _value,
    $Res Function(_$LoanEligibilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoanEligibility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eligible = null,
    Object? maxAmount = null,
    Object? reason = freezed,
  }) {
    return _then(
      _$LoanEligibilityImpl(
        eligible: null == eligible
            ? _value.eligible
            : eligible // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxAmount: null == maxAmount
            ? _value.maxAmount
            : maxAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanEligibilityImpl implements _LoanEligibility {
  const _$LoanEligibilityImpl({
    required this.eligible,
    required this.maxAmount,
    this.reason,
  });

  factory _$LoanEligibilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanEligibilityImplFromJson(json);

  @override
  final bool eligible;
  @override
  final String maxAmount;
  @override
  final String? reason;

  @override
  String toString() {
    return 'LoanEligibility(eligible: $eligible, maxAmount: $maxAmount, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanEligibilityImpl &&
            (identical(other.eligible, eligible) ||
                other.eligible == eligible) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eligible, maxAmount, reason);

  /// Create a copy of LoanEligibility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanEligibilityImplCopyWith<_$LoanEligibilityImpl> get copyWith =>
      __$$LoanEligibilityImplCopyWithImpl<_$LoanEligibilityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanEligibilityImplToJson(this);
  }
}

abstract class _LoanEligibility implements LoanEligibility {
  const factory _LoanEligibility({
    required final bool eligible,
    required final String maxAmount,
    final String? reason,
  }) = _$LoanEligibilityImpl;

  factory _LoanEligibility.fromJson(Map<String, dynamic> json) =
      _$LoanEligibilityImpl.fromJson;

  @override
  bool get eligible;
  @override
  String get maxAmount;
  @override
  String? get reason;

  /// Create a copy of LoanEligibility
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanEligibilityImplCopyWith<_$LoanEligibilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RepaymentInstalment _$RepaymentInstalmentFromJson(Map<String, dynamic> json) {
  return _RepaymentInstalment.fromJson(json);
}

/// @nodoc
mixin _$RepaymentInstalment {
  String get id => throw _privateConstructorUsedError;
  int get instalmentNumber => throw _privateConstructorUsedError;
  String get dueDate => throw _privateConstructorUsedError;
  String get amountDue => throw _privateConstructorUsedError;
  String get amountPaid => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this RepaymentInstalment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RepaymentInstalment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepaymentInstalmentCopyWith<RepaymentInstalment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepaymentInstalmentCopyWith<$Res> {
  factory $RepaymentInstalmentCopyWith(
    RepaymentInstalment value,
    $Res Function(RepaymentInstalment) then,
  ) = _$RepaymentInstalmentCopyWithImpl<$Res, RepaymentInstalment>;
  @useResult
  $Res call({
    String id,
    int instalmentNumber,
    String dueDate,
    String amountDue,
    String amountPaid,
    String status,
    String? paidAt,
  });
}

/// @nodoc
class _$RepaymentInstalmentCopyWithImpl<$Res, $Val extends RepaymentInstalment>
    implements $RepaymentInstalmentCopyWith<$Res> {
  _$RepaymentInstalmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepaymentInstalment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instalmentNumber = null,
    Object? dueDate = null,
    Object? amountDue = null,
    Object? amountPaid = null,
    Object? status = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            instalmentNumber: null == instalmentNumber
                ? _value.instalmentNumber
                : instalmentNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as String,
            amountDue: null == amountDue
                ? _value.amountDue
                : amountDue // ignore: cast_nullable_to_non_nullable
                      as String,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RepaymentInstalmentImplCopyWith<$Res>
    implements $RepaymentInstalmentCopyWith<$Res> {
  factory _$$RepaymentInstalmentImplCopyWith(
    _$RepaymentInstalmentImpl value,
    $Res Function(_$RepaymentInstalmentImpl) then,
  ) = __$$RepaymentInstalmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int instalmentNumber,
    String dueDate,
    String amountDue,
    String amountPaid,
    String status,
    String? paidAt,
  });
}

/// @nodoc
class __$$RepaymentInstalmentImplCopyWithImpl<$Res>
    extends _$RepaymentInstalmentCopyWithImpl<$Res, _$RepaymentInstalmentImpl>
    implements _$$RepaymentInstalmentImplCopyWith<$Res> {
  __$$RepaymentInstalmentImplCopyWithImpl(
    _$RepaymentInstalmentImpl _value,
    $Res Function(_$RepaymentInstalmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepaymentInstalment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instalmentNumber = null,
    Object? dueDate = null,
    Object? amountDue = null,
    Object? amountPaid = null,
    Object? status = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _$RepaymentInstalmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        instalmentNumber: null == instalmentNumber
            ? _value.instalmentNumber
            : instalmentNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as String,
        amountDue: null == amountDue
            ? _value.amountDue
            : amountDue // ignore: cast_nullable_to_non_nullable
                  as String,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RepaymentInstalmentImpl implements _RepaymentInstalment {
  const _$RepaymentInstalmentImpl({
    required this.id,
    required this.instalmentNumber,
    required this.dueDate,
    required this.amountDue,
    required this.amountPaid,
    required this.status,
    this.paidAt,
  });

  factory _$RepaymentInstalmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepaymentInstalmentImplFromJson(json);

  @override
  final String id;
  @override
  final int instalmentNumber;
  @override
  final String dueDate;
  @override
  final String amountDue;
  @override
  final String amountPaid;
  @override
  final String status;
  @override
  final String? paidAt;

  @override
  String toString() {
    return 'RepaymentInstalment(id: $id, instalmentNumber: $instalmentNumber, dueDate: $dueDate, amountDue: $amountDue, amountPaid: $amountPaid, status: $status, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepaymentInstalmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.instalmentNumber, instalmentNumber) ||
                other.instalmentNumber == instalmentNumber) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.amountDue, amountDue) ||
                other.amountDue == amountDue) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    instalmentNumber,
    dueDate,
    amountDue,
    amountPaid,
    status,
    paidAt,
  );

  /// Create a copy of RepaymentInstalment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepaymentInstalmentImplCopyWith<_$RepaymentInstalmentImpl> get copyWith =>
      __$$RepaymentInstalmentImplCopyWithImpl<_$RepaymentInstalmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RepaymentInstalmentImplToJson(this);
  }
}

abstract class _RepaymentInstalment implements RepaymentInstalment {
  const factory _RepaymentInstalment({
    required final String id,
    required final int instalmentNumber,
    required final String dueDate,
    required final String amountDue,
    required final String amountPaid,
    required final String status,
    final String? paidAt,
  }) = _$RepaymentInstalmentImpl;

  factory _RepaymentInstalment.fromJson(Map<String, dynamic> json) =
      _$RepaymentInstalmentImpl.fromJson;

  @override
  String get id;
  @override
  int get instalmentNumber;
  @override
  String get dueDate;
  @override
  String get amountDue;
  @override
  String get amountPaid;
  @override
  String get status;
  @override
  String? get paidAt;

  /// Create a copy of RepaymentInstalment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepaymentInstalmentImplCopyWith<_$RepaymentInstalmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
