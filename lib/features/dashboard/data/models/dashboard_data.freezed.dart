// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardData {
  AccountModel get primaryAccount => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  List<TransactionModel> get recentTransactions =>
      throw _privateConstructorUsedError;
  HealthScoreModel? get healthScore => throw _privateConstructorUsedError;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
    DashboardData value,
    $Res Function(DashboardData) then,
  ) = _$DashboardDataCopyWithImpl<$Res, DashboardData>;
  @useResult
  $Res call({
    AccountModel primaryAccount,
    UserModel user,
    List<TransactionModel> recentTransactions,
    HealthScoreModel? healthScore,
  });

  $AccountModelCopyWith<$Res> get primaryAccount;
  $UserModelCopyWith<$Res> get user;
  $HealthScoreModelCopyWith<$Res>? get healthScore;
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res, $Val extends DashboardData>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryAccount = null,
    Object? user = null,
    Object? recentTransactions = null,
    Object? healthScore = freezed,
  }) {
    return _then(
      _value.copyWith(
            primaryAccount: null == primaryAccount
                ? _value.primaryAccount
                : primaryAccount // ignore: cast_nullable_to_non_nullable
                      as AccountModel,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            recentTransactions: null == recentTransactions
                ? _value.recentTransactions
                : recentTransactions // ignore: cast_nullable_to_non_nullable
                      as List<TransactionModel>,
            healthScore: freezed == healthScore
                ? _value.healthScore
                : healthScore // ignore: cast_nullable_to_non_nullable
                      as HealthScoreModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountModelCopyWith<$Res> get primaryAccount {
    return $AccountModelCopyWith<$Res>(_value.primaryAccount, (value) {
      return _then(_value.copyWith(primaryAccount: value) as $Val);
    });
  }

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthScoreModelCopyWith<$Res>? get healthScore {
    if (_value.healthScore == null) {
      return null;
    }

    return $HealthScoreModelCopyWith<$Res>(_value.healthScore!, (value) {
      return _then(_value.copyWith(healthScore: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardDataImplCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$$DashboardDataImplCopyWith(
    _$DashboardDataImpl value,
    $Res Function(_$DashboardDataImpl) then,
  ) = __$$DashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AccountModel primaryAccount,
    UserModel user,
    List<TransactionModel> recentTransactions,
    HealthScoreModel? healthScore,
  });

  @override
  $AccountModelCopyWith<$Res> get primaryAccount;
  @override
  $UserModelCopyWith<$Res> get user;
  @override
  $HealthScoreModelCopyWith<$Res>? get healthScore;
}

/// @nodoc
class __$$DashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardDataCopyWithImpl<$Res, _$DashboardDataImpl>
    implements _$$DashboardDataImplCopyWith<$Res> {
  __$$DashboardDataImplCopyWithImpl(
    _$DashboardDataImpl _value,
    $Res Function(_$DashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryAccount = null,
    Object? user = null,
    Object? recentTransactions = null,
    Object? healthScore = freezed,
  }) {
    return _then(
      _$DashboardDataImpl(
        primaryAccount: null == primaryAccount
            ? _value.primaryAccount
            : primaryAccount // ignore: cast_nullable_to_non_nullable
                  as AccountModel,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        recentTransactions: null == recentTransactions
            ? _value._recentTransactions
            : recentTransactions // ignore: cast_nullable_to_non_nullable
                  as List<TransactionModel>,
        healthScore: freezed == healthScore
            ? _value.healthScore
            : healthScore // ignore: cast_nullable_to_non_nullable
                  as HealthScoreModel?,
      ),
    );
  }
}

/// @nodoc

class _$DashboardDataImpl implements _DashboardData {
  const _$DashboardDataImpl({
    required this.primaryAccount,
    required this.user,
    required final List<TransactionModel> recentTransactions,
    this.healthScore,
  }) : _recentTransactions = recentTransactions;

  @override
  final AccountModel primaryAccount;
  @override
  final UserModel user;
  final List<TransactionModel> _recentTransactions;
  @override
  List<TransactionModel> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  final HealthScoreModel? healthScore;

  @override
  String toString() {
    return 'DashboardData(primaryAccount: $primaryAccount, user: $user, recentTransactions: $recentTransactions, healthScore: $healthScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataImpl &&
            (identical(other.primaryAccount, primaryAccount) ||
                other.primaryAccount == primaryAccount) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(
              other._recentTransactions,
              _recentTransactions,
            ) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    primaryAccount,
    user,
    const DeepCollectionEquality().hash(_recentTransactions),
    healthScore,
  );

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      __$$DashboardDataImplCopyWithImpl<_$DashboardDataImpl>(this, _$identity);
}

abstract class _DashboardData implements DashboardData {
  const factory _DashboardData({
    required final AccountModel primaryAccount,
    required final UserModel user,
    required final List<TransactionModel> recentTransactions,
    final HealthScoreModel? healthScore,
  }) = _$DashboardDataImpl;

  @override
  AccountModel get primaryAccount;
  @override
  UserModel get user;
  @override
  List<TransactionModel> get recentTransactions;
  @override
  HealthScoreModel? get healthScore;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get financialHealthScore => throw _privateConstructorUsedError;
  int get kycLevel => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String fullName,
    int financialHealthScore,
    int kycLevel,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? financialHealthScore = null,
    Object? kycLevel = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            financialHealthScore: null == financialHealthScore
                ? _value.financialHealthScore
                : financialHealthScore // ignore: cast_nullable_to_non_nullable
                      as int,
            kycLevel: null == kycLevel
                ? _value.kycLevel
                : kycLevel // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fullName,
    int financialHealthScore,
    int kycLevel,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? financialHealthScore = null,
    Object? kycLevel = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        financialHealthScore: null == financialHealthScore
            ? _value.financialHealthScore
            : financialHealthScore // ignore: cast_nullable_to_non_nullable
                  as int,
        kycLevel: null == kycLevel
            ? _value.kycLevel
            : kycLevel // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.fullName,
    required this.financialHealthScore,
    required this.kycLevel,
  });

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final int financialHealthScore;
  @override
  final int kycLevel;

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, financialHealthScore: $financialHealthScore, kycLevel: $kycLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.financialHealthScore, financialHealthScore) ||
                other.financialHealthScore == financialHealthScore) &&
            (identical(other.kycLevel, kycLevel) ||
                other.kycLevel == kycLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fullName, financialHealthScore, kycLevel);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String fullName,
    required final int financialHealthScore,
    required final int kycLevel,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  int get financialHealthScore;
  @override
  int get kycLevel;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
  String toString() {
    return 'AccountModel(id: $id, accountNumber: $accountNumber, accountType: $accountType, balance: $balance, currency: $currency, status: $status)';
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
            (identical(other.status, status) || other.status == status));
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

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  String get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get transactionType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get insertedAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
    TransactionModel value,
    $Res Function(TransactionModel) then,
  ) = _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
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
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
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
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(
    _$TransactionModelImpl value,
    $Res Function(_$TransactionModelImpl) then,
  ) = __$$TransactionModelImplCopyWithImpl<$Res>;
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
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(
    _$TransactionModelImpl _value,
    $Res Function(_$TransactionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionModel
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
      _$TransactionModelImpl(
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
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl({
    required this.id,
    required this.reference,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.status,
    required this.insertedAt,
  });

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

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
    return 'TransactionModel(id: $id, reference: $reference, description: $description, amount: $amount, transactionType: $transactionType, status: $status, insertedAt: $insertedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
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

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(this);
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel({
    required final String id,
    required final String reference,
    final String? description,
    required final String amount,
    required final String transactionType,
    required final String status,
    required final String insertedAt,
  }) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

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

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthScoreModel _$HealthScoreModelFromJson(Map<String, dynamic> json) {
  return _HealthScoreModel.fromJson(json);
}

/// @nodoc
mixin _$HealthScoreModel {
  int get score => throw _privateConstructorUsedError;
  double get savingsConsistency => throw _privateConstructorUsedError;
  double get loanRepaymentRate => throw _privateConstructorUsedError;
  int get challengeCompletions => throw _privateConstructorUsedError;

  /// Serializes this HealthScoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthScoreModelCopyWith<HealthScoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthScoreModelCopyWith<$Res> {
  factory $HealthScoreModelCopyWith(
    HealthScoreModel value,
    $Res Function(HealthScoreModel) then,
  ) = _$HealthScoreModelCopyWithImpl<$Res, HealthScoreModel>;
  @useResult
  $Res call({
    int score,
    double savingsConsistency,
    double loanRepaymentRate,
    int challengeCompletions,
  });
}

/// @nodoc
class _$HealthScoreModelCopyWithImpl<$Res, $Val extends HealthScoreModel>
    implements $HealthScoreModelCopyWith<$Res> {
  _$HealthScoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? savingsConsistency = null,
    Object? loanRepaymentRate = null,
    Object? challengeCompletions = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            savingsConsistency: null == savingsConsistency
                ? _value.savingsConsistency
                : savingsConsistency // ignore: cast_nullable_to_non_nullable
                      as double,
            loanRepaymentRate: null == loanRepaymentRate
                ? _value.loanRepaymentRate
                : loanRepaymentRate // ignore: cast_nullable_to_non_nullable
                      as double,
            challengeCompletions: null == challengeCompletions
                ? _value.challengeCompletions
                : challengeCompletions // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthScoreModelImplCopyWith<$Res>
    implements $HealthScoreModelCopyWith<$Res> {
  factory _$$HealthScoreModelImplCopyWith(
    _$HealthScoreModelImpl value,
    $Res Function(_$HealthScoreModelImpl) then,
  ) = __$$HealthScoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int score,
    double savingsConsistency,
    double loanRepaymentRate,
    int challengeCompletions,
  });
}

/// @nodoc
class __$$HealthScoreModelImplCopyWithImpl<$Res>
    extends _$HealthScoreModelCopyWithImpl<$Res, _$HealthScoreModelImpl>
    implements _$$HealthScoreModelImplCopyWith<$Res> {
  __$$HealthScoreModelImplCopyWithImpl(
    _$HealthScoreModelImpl _value,
    $Res Function(_$HealthScoreModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? savingsConsistency = null,
    Object? loanRepaymentRate = null,
    Object? challengeCompletions = null,
  }) {
    return _then(
      _$HealthScoreModelImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        savingsConsistency: null == savingsConsistency
            ? _value.savingsConsistency
            : savingsConsistency // ignore: cast_nullable_to_non_nullable
                  as double,
        loanRepaymentRate: null == loanRepaymentRate
            ? _value.loanRepaymentRate
            : loanRepaymentRate // ignore: cast_nullable_to_non_nullable
                  as double,
        challengeCompletions: null == challengeCompletions
            ? _value.challengeCompletions
            : challengeCompletions // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthScoreModelImpl implements _HealthScoreModel {
  const _$HealthScoreModelImpl({
    required this.score,
    required this.savingsConsistency,
    required this.loanRepaymentRate,
    required this.challengeCompletions,
  });

  factory _$HealthScoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthScoreModelImplFromJson(json);

  @override
  final int score;
  @override
  final double savingsConsistency;
  @override
  final double loanRepaymentRate;
  @override
  final int challengeCompletions;

  @override
  String toString() {
    return 'HealthScoreModel(score: $score, savingsConsistency: $savingsConsistency, loanRepaymentRate: $loanRepaymentRate, challengeCompletions: $challengeCompletions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthScoreModelImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.savingsConsistency, savingsConsistency) ||
                other.savingsConsistency == savingsConsistency) &&
            (identical(other.loanRepaymentRate, loanRepaymentRate) ||
                other.loanRepaymentRate == loanRepaymentRate) &&
            (identical(other.challengeCompletions, challengeCompletions) ||
                other.challengeCompletions == challengeCompletions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    savingsConsistency,
    loanRepaymentRate,
    challengeCompletions,
  );

  /// Create a copy of HealthScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthScoreModelImplCopyWith<_$HealthScoreModelImpl> get copyWith =>
      __$$HealthScoreModelImplCopyWithImpl<_$HealthScoreModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthScoreModelImplToJson(this);
  }
}

abstract class _HealthScoreModel implements HealthScoreModel {
  const factory _HealthScoreModel({
    required final int score,
    required final double savingsConsistency,
    required final double loanRepaymentRate,
    required final int challengeCompletions,
  }) = _$HealthScoreModelImpl;

  factory _HealthScoreModel.fromJson(Map<String, dynamic> json) =
      _$HealthScoreModelImpl.fromJson;

  @override
  int get score;
  @override
  double get savingsConsistency;
  @override
  double get loanRepaymentRate;
  @override
  int get challengeCompletions;

  /// Create a copy of HealthScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthScoreModelImplCopyWith<_$HealthScoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
