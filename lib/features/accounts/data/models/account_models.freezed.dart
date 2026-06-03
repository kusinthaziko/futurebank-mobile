// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return _AccountModel.fromJson(json);
}

/// @nodoc
mixin _$AccountModel {
  String get id => throw _privateConstructorUsedError;
  String get accountNumber => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get interestRate => throw _privateConstructorUsedError;

  /// Serializes this AccountModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountModelCopyWith<AccountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountModelCopyWith<$Res> {
  factory $AccountModelCopyWith(
    AccountModel value,
    $Res Function(AccountModel) then,
  ) = _$AccountModelCopyWithImpl<$Res, AccountModel>;
  @useResult
  $Res call({
    String id,
    String accountNumber,
    String accountType,
    String balance,
    String currency,
    String status,
    String interestRate,
  });
}

/// @nodoc
class _$AccountModelCopyWithImpl<$Res, $Val extends AccountModel>
    implements $AccountModelCopyWith<$Res> {
  _$AccountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountNumber = null,
    Object? accountType = null,
    Object? balance = null,
    Object? currency = null,
    Object? status = null,
    Object? interestRate = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            accountNumber: null == accountNumber
                ? _value.accountNumber
                : accountNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            accountType: null == accountType
                ? _value.accountType
                : accountType // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            interestRate: null == interestRate
                ? _value.interestRate
                : interestRate // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountModelImplCopyWith<$Res>
    implements $AccountModelCopyWith<$Res> {
  factory _$$AccountModelImplCopyWith(
    _$AccountModelImpl value,
    $Res Function(_$AccountModelImpl) then,
  ) = __$$AccountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String accountNumber,
    String accountType,
    String balance,
    String currency,
    String status,
    String interestRate,
  });
}

/// @nodoc
class __$$AccountModelImplCopyWithImpl<$Res>
    extends _$AccountModelCopyWithImpl<$Res, _$AccountModelImpl>
    implements _$$AccountModelImplCopyWith<$Res> {
  __$$AccountModelImplCopyWithImpl(
    _$AccountModelImpl _value,
    $Res Function(_$AccountModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountNumber = null,
    Object? accountType = null,
    Object? balance = null,
    Object? currency = null,
    Object? status = null,
    Object? interestRate = null,
  }) {
    return _then(
      _$AccountModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        accountNumber: null == accountNumber
            ? _value.accountNumber
            : accountNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        accountType: null == accountType
            ? _value.accountType
            : accountType // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        interestRate: null == interestRate
            ? _value.interestRate
            : interestRate // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountModelImpl implements _AccountModel {
  const _$AccountModelImpl({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.balance,
    required this.currency,
    required this.status,
    required this.interestRate,
  });

  factory _$AccountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountModelImplFromJson(json);

  @override
  final String id;
  @override
  final String accountNumber;
  @override
  final String accountType;
  @override
  final String balance;
  @override
  final String currency;
  @override
  final String status;
  @override
  final String interestRate;

  @override
  String toString() {
    return 'AccountModel(id: $id, accountNumber: $accountNumber, accountType: $accountType, balance: $balance, currency: $currency, status: $status, interestRate: $interestRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    accountNumber,
    accountType,
    balance,
    currency,
    status,
    interestRate,
  );

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      __$$AccountModelImplCopyWithImpl<_$AccountModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountModelImplToJson(this);
  }
}

abstract class _AccountModel implements AccountModel {
  const factory _AccountModel({
    required final String id,
    required final String accountNumber,
    required final String accountType,
    required final String balance,
    required final String currency,
    required final String status,
    required final String interestRate,
  }) = _$AccountModelImpl;

  factory _AccountModel.fromJson(Map<String, dynamic> json) =
      _$AccountModelImpl.fromJson;

  @override
  String get id;
  @override
  String get accountNumber;
  @override
  String get accountType;
  @override
  String get balance;
  @override
  String get currency;
  @override
  String get status;
  @override
  String get interestRate;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavingsGoalModel _$SavingsGoalModelFromJson(Map<String, dynamic> json) {
  return _SavingsGoalModel.fromJson(json);
}

/// @nodoc
mixin _$SavingsGoalModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get targetAmount => throw _privateConstructorUsedError;
  String get currentAmount => throw _privateConstructorUsedError;
  String? get deadline => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this SavingsGoalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavingsGoalModelCopyWith<SavingsGoalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavingsGoalModelCopyWith<$Res> {
  factory $SavingsGoalModelCopyWith(
    SavingsGoalModel value,
    $Res Function(SavingsGoalModel) then,
  ) = _$SavingsGoalModelCopyWithImpl<$Res, SavingsGoalModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String targetAmount,
    String currentAmount,
    String? deadline,
    String category,
    String status,
  });
}

/// @nodoc
class _$SavingsGoalModelCopyWithImpl<$Res, $Val extends SavingsGoalModel>
    implements $SavingsGoalModelCopyWith<$Res> {
  _$SavingsGoalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? deadline = freezed,
    Object? category = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAmount: null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            currentAmount: null == currentAmount
                ? _value.currentAmount
                : currentAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            deadline: freezed == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavingsGoalModelImplCopyWith<$Res>
    implements $SavingsGoalModelCopyWith<$Res> {
  factory _$$SavingsGoalModelImplCopyWith(
    _$SavingsGoalModelImpl value,
    $Res Function(_$SavingsGoalModelImpl) then,
  ) = __$$SavingsGoalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String targetAmount,
    String currentAmount,
    String? deadline,
    String category,
    String status,
  });
}

/// @nodoc
class __$$SavingsGoalModelImplCopyWithImpl<$Res>
    extends _$SavingsGoalModelCopyWithImpl<$Res, _$SavingsGoalModelImpl>
    implements _$$SavingsGoalModelImplCopyWith<$Res> {
  __$$SavingsGoalModelImplCopyWithImpl(
    _$SavingsGoalModelImpl _value,
    $Res Function(_$SavingsGoalModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? deadline = freezed,
    Object? category = null,
    Object? status = null,
  }) {
    return _then(
      _$SavingsGoalModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAmount: null == targetAmount
            ? _value.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        currentAmount: null == currentAmount
            ? _value.currentAmount
            : currentAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        deadline: freezed == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavingsGoalModelImpl implements _SavingsGoalModel {
  const _$SavingsGoalModelImpl({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.category,
    required this.status,
  });

  factory _$SavingsGoalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavingsGoalModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String targetAmount;
  @override
  final String currentAmount;
  @override
  final String? deadline;
  @override
  final String category;
  @override
  final String status;

  @override
  String toString() {
    return 'SavingsGoalModel(id: $id, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline, category: $category, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavingsGoalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    targetAmount,
    currentAmount,
    deadline,
    category,
    status,
  );

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavingsGoalModelImplCopyWith<_$SavingsGoalModelImpl> get copyWith =>
      __$$SavingsGoalModelImplCopyWithImpl<_$SavingsGoalModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SavingsGoalModelImplToJson(this);
  }
}

abstract class _SavingsGoalModel implements SavingsGoalModel {
  const factory _SavingsGoalModel({
    required final String id,
    required final String name,
    required final String targetAmount,
    required final String currentAmount,
    final String? deadline,
    required final String category,
    required final String status,
  }) = _$SavingsGoalModelImpl;

  factory _SavingsGoalModel.fromJson(Map<String, dynamic> json) =
      _$SavingsGoalModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get targetAmount;
  @override
  String get currentAmount;
  @override
  String? get deadline;
  @override
  String get category;
  @override
  String get status;

  /// Create a copy of SavingsGoalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavingsGoalModelImplCopyWith<_$SavingsGoalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TxModel _$TxModelFromJson(Map<String, dynamic> json) {
  return _TxModel.fromJson(json);
}

/// @nodoc
mixin _$TxModel {
  String get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get transactionType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get insertedAt => throw _privateConstructorUsedError;

  /// Serializes this TxModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TxModelCopyWith<TxModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TxModelCopyWith<$Res> {
  factory $TxModelCopyWith(TxModel value, $Res Function(TxModel) then) =
      _$TxModelCopyWithImpl<$Res, TxModel>;
  @useResult
  $Res call({
    String id,
    String reference,
    String? description,
    String amount,
    String transactionType,
    String status,
    String insertedAt,
  });
}

/// @nodoc
class _$TxModelCopyWithImpl<$Res, $Val extends TxModel>
    implements $TxModelCopyWith<$Res> {
  _$TxModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TxModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? description = freezed,
    Object? amount = null,
    Object? transactionType = null,
    Object? status = null,
    Object? insertedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionType: null == transactionType
                ? _value.transactionType
                : transactionType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            insertedAt: null == insertedAt
                ? _value.insertedAt
                : insertedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TxModelImplCopyWith<$Res> implements $TxModelCopyWith<$Res> {
  factory _$$TxModelImplCopyWith(
    _$TxModelImpl value,
    $Res Function(_$TxModelImpl) then,
  ) = __$$TxModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reference,
    String? description,
    String amount,
    String transactionType,
    String status,
    String insertedAt,
  });
}

/// @nodoc
class __$$TxModelImplCopyWithImpl<$Res>
    extends _$TxModelCopyWithImpl<$Res, _$TxModelImpl>
    implements _$$TxModelImplCopyWith<$Res> {
  __$$TxModelImplCopyWithImpl(
    _$TxModelImpl _value,
    $Res Function(_$TxModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TxModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? description = freezed,
    Object? amount = null,
    Object? transactionType = null,
    Object? status = null,
    Object? insertedAt = null,
  }) {
    return _then(
      _$TxModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionType: null == transactionType
            ? _value.transactionType
            : transactionType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        insertedAt: null == insertedAt
            ? _value.insertedAt
            : insertedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TxModelImpl implements _TxModel {
  const _$TxModelImpl({
    required this.id,
    required this.reference,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.status,
    required this.insertedAt,
  });

  factory _$TxModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TxModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reference;
  @override
  final String? description;
  @override
  final String amount;
  @override
  final String transactionType;
  @override
  final String status;
  @override
  final String insertedAt;

  @override
  String toString() {
    return 'TxModel(id: $id, reference: $reference, description: $description, amount: $amount, transactionType: $transactionType, status: $status, insertedAt: $insertedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TxModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.insertedAt, insertedAt) ||
                other.insertedAt == insertedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reference,
    description,
    amount,
    transactionType,
    status,
    insertedAt,
  );

  /// Create a copy of TxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TxModelImplCopyWith<_$TxModelImpl> get copyWith =>
      __$$TxModelImplCopyWithImpl<_$TxModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TxModelImplToJson(this);
  }
}

abstract class _TxModel implements TxModel {
  const factory _TxModel({
    required final String id,
    required final String reference,
    final String? description,
    required final String amount,
    required final String transactionType,
    required final String status,
    required final String insertedAt,
  }) = _$TxModelImpl;

  factory _TxModel.fromJson(Map<String, dynamic> json) = _$TxModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reference;
  @override
  String? get description;
  @override
  String get amount;
  @override
  String get transactionType;
  @override
  String get status;
  @override
  String get insertedAt;

  /// Create a copy of TxModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TxModelImplCopyWith<_$TxModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
