// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfileData {
  UserProfile get user => throw _privateConstructorUsedError;
  HealthScoreData get healthScore => throw _privateConstructorUsedError;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileDataCopyWith<ProfileData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileDataCopyWith<$Res> {
  factory $ProfileDataCopyWith(
    ProfileData value,
    $Res Function(ProfileData) then,
  ) = _$ProfileDataCopyWithImpl<$Res, ProfileData>;
  @useResult
  $Res call({UserProfile user, HealthScoreData healthScore});

  $UserProfileCopyWith<$Res> get user;
  $HealthScoreDataCopyWith<$Res> get healthScore;
}

/// @nodoc
class _$ProfileDataCopyWithImpl<$Res, $Val extends ProfileData>
    implements $ProfileDataCopyWith<$Res> {
  _$ProfileDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? healthScore = null}) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserProfile,
            healthScore: null == healthScore
                ? _value.healthScore
                : healthScore // ignore: cast_nullable_to_non_nullable
                      as HealthScoreData,
          )
          as $Val,
    );
  }

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get user {
    return $UserProfileCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthScoreDataCopyWith<$Res> get healthScore {
    return $HealthScoreDataCopyWith<$Res>(_value.healthScore, (value) {
      return _then(_value.copyWith(healthScore: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileDataImplCopyWith<$Res>
    implements $ProfileDataCopyWith<$Res> {
  factory _$$ProfileDataImplCopyWith(
    _$ProfileDataImpl value,
    $Res Function(_$ProfileDataImpl) then,
  ) = __$$ProfileDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserProfile user, HealthScoreData healthScore});

  @override
  $UserProfileCopyWith<$Res> get user;
  @override
  $HealthScoreDataCopyWith<$Res> get healthScore;
}

/// @nodoc
class __$$ProfileDataImplCopyWithImpl<$Res>
    extends _$ProfileDataCopyWithImpl<$Res, _$ProfileDataImpl>
    implements _$$ProfileDataImplCopyWith<$Res> {
  __$$ProfileDataImplCopyWithImpl(
    _$ProfileDataImpl _value,
    $Res Function(_$ProfileDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? healthScore = null}) {
    return _then(
      _$ProfileDataImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserProfile,
        healthScore: null == healthScore
            ? _value.healthScore
            : healthScore // ignore: cast_nullable_to_non_nullable
                  as HealthScoreData,
      ),
    );
  }
}

/// @nodoc

class _$ProfileDataImpl implements _ProfileData {
  const _$ProfileDataImpl({required this.user, required this.healthScore});

  @override
  final UserProfile user;
  @override
  final HealthScoreData healthScore;

  @override
  String toString() {
    return 'ProfileData(user: $user, healthScore: $healthScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileDataImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, healthScore);

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileDataImplCopyWith<_$ProfileDataImpl> get copyWith =>
      __$$ProfileDataImplCopyWithImpl<_$ProfileDataImpl>(this, _$identity);
}

abstract class _ProfileData implements ProfileData {
  const factory _ProfileData({
    required final UserProfile user,
    required final HealthScoreData healthScore,
  }) = _$ProfileDataImpl;

  @override
  UserProfile get user;
  @override
  HealthScoreData get healthScore;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileDataImplCopyWith<_$ProfileDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  int get kycLevel => throw _privateConstructorUsedError;
  String get kycStatus => throw _privateConstructorUsedError;
  int get financialHealthScore => throw _privateConstructorUsedError;
  String? get blockchainDid => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    String fullName,
    String email,
    int kycLevel,
    String kycStatus,
    int financialHealthScore,
    String? blockchainDid,
    String? avatarUrl,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? kycLevel = null,
    Object? kycStatus = null,
    Object? financialHealthScore = null,
    Object? blockchainDid = freezed,
    Object? avatarUrl = freezed,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            kycLevel: null == kycLevel
                ? _value.kycLevel
                : kycLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            kycStatus: null == kycStatus
                ? _value.kycStatus
                : kycStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            financialHealthScore: null == financialHealthScore
                ? _value.financialHealthScore
                : financialHealthScore // ignore: cast_nullable_to_non_nullable
                      as int,
            blockchainDid: freezed == blockchainDid
                ? _value.blockchainDid
                : blockchainDid // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fullName,
    String email,
    int kycLevel,
    String kycStatus,
    int financialHealthScore,
    String? blockchainDid,
    String? avatarUrl,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = null,
    Object? kycLevel = null,
    Object? kycStatus = null,
    Object? financialHealthScore = null,
    Object? blockchainDid = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _$UserProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        kycLevel: null == kycLevel
            ? _value.kycLevel
            : kycLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        kycStatus: null == kycStatus
            ? _value.kycStatus
            : kycStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        financialHealthScore: null == financialHealthScore
            ? _value.financialHealthScore
            : financialHealthScore // ignore: cast_nullable_to_non_nullable
                  as int,
        blockchainDid: freezed == blockchainDid
            ? _value.blockchainDid
            : blockchainDid // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    required this.fullName,
    required this.email,
    required this.kycLevel,
    required this.kycStatus,
    required this.financialHealthScore,
    this.blockchainDid,
    this.avatarUrl,
  });

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final int kycLevel;
  @override
  final String kycStatus;
  @override
  final int financialHealthScore;
  @override
  final String? blockchainDid;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, kycLevel: $kycLevel, kycStatus: $kycStatus, financialHealthScore: $financialHealthScore, blockchainDid: $blockchainDid, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.kycLevel, kycLevel) ||
                other.kycLevel == kycLevel) &&
            (identical(other.kycStatus, kycStatus) ||
                other.kycStatus == kycStatus) &&
            (identical(other.financialHealthScore, financialHealthScore) ||
                other.financialHealthScore == financialHealthScore) &&
            (identical(other.blockchainDid, blockchainDid) ||
                other.blockchainDid == blockchainDid) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    email,
    kycLevel,
    kycStatus,
    financialHealthScore,
    blockchainDid,
    avatarUrl,
  );

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String id,
    required final String fullName,
    required final String email,
    required final int kycLevel,
    required final String kycStatus,
    required final int financialHealthScore,
    final String? blockchainDid,
    final String? avatarUrl,
  }) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String get email;
  @override
  int get kycLevel;
  @override
  String get kycStatus;
  @override
  int get financialHealthScore;
  @override
  String? get blockchainDid;
  @override
  String? get avatarUrl;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthScoreData _$HealthScoreDataFromJson(Map<String, dynamic> json) {
  return _HealthScoreData.fromJson(json);
}

/// @nodoc
mixin _$HealthScoreData {
  int get score => throw _privateConstructorUsedError;
  double get savingsConsistency => throw _privateConstructorUsedError;
  double get loanRepaymentRate => throw _privateConstructorUsedError;
  int get challengeCompletions => throw _privateConstructorUsedError;
  int get accountAgeDays => throw _privateConstructorUsedError;
  int get kycLevel => throw _privateConstructorUsedError;

  /// Serializes this HealthScoreData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthScoreData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthScoreDataCopyWith<HealthScoreData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthScoreDataCopyWith<$Res> {
  factory $HealthScoreDataCopyWith(
    HealthScoreData value,
    $Res Function(HealthScoreData) then,
  ) = _$HealthScoreDataCopyWithImpl<$Res, HealthScoreData>;
  @useResult
  $Res call({
    int score,
    double savingsConsistency,
    double loanRepaymentRate,
    int challengeCompletions,
    int accountAgeDays,
    int kycLevel,
  });
}

/// @nodoc
class _$HealthScoreDataCopyWithImpl<$Res, $Val extends HealthScoreData>
    implements $HealthScoreDataCopyWith<$Res> {
  _$HealthScoreDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthScoreData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? savingsConsistency = null,
    Object? loanRepaymentRate = null,
    Object? challengeCompletions = null,
    Object? accountAgeDays = null,
    Object? kycLevel = null,
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
            accountAgeDays: null == accountAgeDays
                ? _value.accountAgeDays
                : accountAgeDays // ignore: cast_nullable_to_non_nullable
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
abstract class _$$HealthScoreDataImplCopyWith<$Res>
    implements $HealthScoreDataCopyWith<$Res> {
  factory _$$HealthScoreDataImplCopyWith(
    _$HealthScoreDataImpl value,
    $Res Function(_$HealthScoreDataImpl) then,
  ) = __$$HealthScoreDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int score,
    double savingsConsistency,
    double loanRepaymentRate,
    int challengeCompletions,
    int accountAgeDays,
    int kycLevel,
  });
}

/// @nodoc
class __$$HealthScoreDataImplCopyWithImpl<$Res>
    extends _$HealthScoreDataCopyWithImpl<$Res, _$HealthScoreDataImpl>
    implements _$$HealthScoreDataImplCopyWith<$Res> {
  __$$HealthScoreDataImplCopyWithImpl(
    _$HealthScoreDataImpl _value,
    $Res Function(_$HealthScoreDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthScoreData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? savingsConsistency = null,
    Object? loanRepaymentRate = null,
    Object? challengeCompletions = null,
    Object? accountAgeDays = null,
    Object? kycLevel = null,
  }) {
    return _then(
      _$HealthScoreDataImpl(
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
        accountAgeDays: null == accountAgeDays
            ? _value.accountAgeDays
            : accountAgeDays // ignore: cast_nullable_to_non_nullable
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
class _$HealthScoreDataImpl implements _HealthScoreData {
  const _$HealthScoreDataImpl({
    required this.score,
    required this.savingsConsistency,
    required this.loanRepaymentRate,
    required this.challengeCompletions,
    required this.accountAgeDays,
    required this.kycLevel,
  });

  factory _$HealthScoreDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthScoreDataImplFromJson(json);

  @override
  final int score;
  @override
  final double savingsConsistency;
  @override
  final double loanRepaymentRate;
  @override
  final int challengeCompletions;
  @override
  final int accountAgeDays;
  @override
  final int kycLevel;

  @override
  String toString() {
    return 'HealthScoreData(score: $score, savingsConsistency: $savingsConsistency, loanRepaymentRate: $loanRepaymentRate, challengeCompletions: $challengeCompletions, accountAgeDays: $accountAgeDays, kycLevel: $kycLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthScoreDataImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.savingsConsistency, savingsConsistency) ||
                other.savingsConsistency == savingsConsistency) &&
            (identical(other.loanRepaymentRate, loanRepaymentRate) ||
                other.loanRepaymentRate == loanRepaymentRate) &&
            (identical(other.challengeCompletions, challengeCompletions) ||
                other.challengeCompletions == challengeCompletions) &&
            (identical(other.accountAgeDays, accountAgeDays) ||
                other.accountAgeDays == accountAgeDays) &&
            (identical(other.kycLevel, kycLevel) ||
                other.kycLevel == kycLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    savingsConsistency,
    loanRepaymentRate,
    challengeCompletions,
    accountAgeDays,
    kycLevel,
  );

  /// Create a copy of HealthScoreData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthScoreDataImplCopyWith<_$HealthScoreDataImpl> get copyWith =>
      __$$HealthScoreDataImplCopyWithImpl<_$HealthScoreDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthScoreDataImplToJson(this);
  }
}

abstract class _HealthScoreData implements HealthScoreData {
  const factory _HealthScoreData({
    required final int score,
    required final double savingsConsistency,
    required final double loanRepaymentRate,
    required final int challengeCompletions,
    required final int accountAgeDays,
    required final int kycLevel,
  }) = _$HealthScoreDataImpl;

  factory _HealthScoreData.fromJson(Map<String, dynamic> json) =
      _$HealthScoreDataImpl.fromJson;

  @override
  int get score;
  @override
  double get savingsConsistency;
  @override
  double get loanRepaymentRate;
  @override
  int get challengeCompletions;
  @override
  int get accountAgeDays;
  @override
  int get kycLevel;

  /// Create a copy of HealthScoreData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthScoreDataImplCopyWith<_$HealthScoreDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) {
  return _BadgeModel.fromJson(json);
}

/// @nodoc
mixin _$BadgeModel {
  String get badgeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get awardedAt => throw _privateConstructorUsedError;

  /// Serializes this BadgeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeModelCopyWith<BadgeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeModelCopyWith<$Res> {
  factory $BadgeModelCopyWith(
    BadgeModel value,
    $Res Function(BadgeModel) then,
  ) = _$BadgeModelCopyWithImpl<$Res, BadgeModel>;
  @useResult
  $Res call({String badgeId, String name, String awardedAt});
}

/// @nodoc
class _$BadgeModelCopyWithImpl<$Res, $Val extends BadgeModel>
    implements $BadgeModelCopyWith<$Res> {
  _$BadgeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badgeId = null,
    Object? name = null,
    Object? awardedAt = null,
  }) {
    return _then(
      _value.copyWith(
            badgeId: null == badgeId
                ? _value.badgeId
                : badgeId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            awardedAt: null == awardedAt
                ? _value.awardedAt
                : awardedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BadgeModelImplCopyWith<$Res>
    implements $BadgeModelCopyWith<$Res> {
  factory _$$BadgeModelImplCopyWith(
    _$BadgeModelImpl value,
    $Res Function(_$BadgeModelImpl) then,
  ) = __$$BadgeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String badgeId, String name, String awardedAt});
}

/// @nodoc
class __$$BadgeModelImplCopyWithImpl<$Res>
    extends _$BadgeModelCopyWithImpl<$Res, _$BadgeModelImpl>
    implements _$$BadgeModelImplCopyWith<$Res> {
  __$$BadgeModelImplCopyWithImpl(
    _$BadgeModelImpl _value,
    $Res Function(_$BadgeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badgeId = null,
    Object? name = null,
    Object? awardedAt = null,
  }) {
    return _then(
      _$BadgeModelImpl(
        badgeId: null == badgeId
            ? _value.badgeId
            : badgeId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        awardedAt: null == awardedAt
            ? _value.awardedAt
            : awardedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeModelImpl implements _BadgeModel {
  const _$BadgeModelImpl({
    required this.badgeId,
    required this.name,
    required this.awardedAt,
  });

  factory _$BadgeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeModelImplFromJson(json);

  @override
  final String badgeId;
  @override
  final String name;
  @override
  final String awardedAt;

  @override
  String toString() {
    return 'BadgeModel(badgeId: $badgeId, name: $name, awardedAt: $awardedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeModelImpl &&
            (identical(other.badgeId, badgeId) || other.badgeId == badgeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.awardedAt, awardedAt) ||
                other.awardedAt == awardedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, badgeId, name, awardedAt);

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeModelImplCopyWith<_$BadgeModelImpl> get copyWith =>
      __$$BadgeModelImplCopyWithImpl<_$BadgeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeModelImplToJson(this);
  }
}

abstract class _BadgeModel implements BadgeModel {
  const factory _BadgeModel({
    required final String badgeId,
    required final String name,
    required final String awardedAt,
  }) = _$BadgeModelImpl;

  factory _BadgeModel.fromJson(Map<String, dynamic> json) =
      _$BadgeModelImpl.fromJson;

  @override
  String get badgeId;
  @override
  String get name;
  @override
  String get awardedAt;

  /// Create a copy of BadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeModelImplCopyWith<_$BadgeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
