// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../safe_spot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SafeSpot _$SafeSpotFromJson(Map<String, dynamic> json) {
  return _SafeSpot.fromJson(json);
}

/// @nodoc
mixin _$SafeSpot {
  String get name => throw _privateConstructorUsedError;
  int get distanceKm => throw _privateConstructorUsedError;
  String get contact => throw _privateConstructorUsedError;
  String get openingTime => throw _privateConstructorUsedError;
  String get closingTime => throw _privateConstructorUsedError;

  /// Serializes this SafeSpot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SafeSpotCopyWith<SafeSpot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SafeSpotCopyWith<$Res> {
  factory $SafeSpotCopyWith(SafeSpot value, $Res Function(SafeSpot) then) =
      _$SafeSpotCopyWithImpl<$Res, SafeSpot>;
  @useResult
  $Res call(
      {String name,
      int distanceKm,
      String contact,
      String openingTime,
      String closingTime});
}

/// @nodoc
class _$SafeSpotCopyWithImpl<$Res, $Val extends SafeSpot>
    implements $SafeSpotCopyWith<$Res> {
  _$SafeSpotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? distanceKm = null,
    Object? contact = null,
    Object? openingTime = null,
    Object? closingTime = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as int,
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as String,
      openingTime: null == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as String,
      closingTime: null == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SafeSpotImplCopyWith<$Res>
    implements $SafeSpotCopyWith<$Res> {
  factory _$$SafeSpotImplCopyWith(
          _$SafeSpotImpl value, $Res Function(_$SafeSpotImpl) then) =
      __$$SafeSpotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int distanceKm,
      String contact,
      String openingTime,
      String closingTime});
}

/// @nodoc
class __$$SafeSpotImplCopyWithImpl<$Res>
    extends _$SafeSpotCopyWithImpl<$Res, _$SafeSpotImpl>
    implements _$$SafeSpotImplCopyWith<$Res> {
  __$$SafeSpotImplCopyWithImpl(
      _$SafeSpotImpl _value, $Res Function(_$SafeSpotImpl) _then)
      : super(_value, _then);

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? distanceKm = null,
    Object? contact = null,
    Object? openingTime = null,
    Object? closingTime = null,
  }) {
    return _then(_$SafeSpotImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as int,
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as String,
      openingTime: null == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as String,
      closingTime: null == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SafeSpotImpl extends _SafeSpot {
  const _$SafeSpotImpl(
      {required this.name,
      required this.distanceKm,
      required this.contact,
      required this.openingTime,
      required this.closingTime})
      : super._();

  factory _$SafeSpotImpl.fromJson(Map<String, dynamic> json) =>
      _$$SafeSpotImplFromJson(json);

  @override
  final String name;
  @override
  final int distanceKm;
  @override
  final String contact;
  @override
  final String openingTime;
  @override
  final String closingTime;

  @override
  String toString() {
    return 'SafeSpot(name: $name, distanceKm: $distanceKm, contact: $contact, openingTime: $openingTime, closingTime: $closingTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SafeSpotImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.openingTime, openingTime) ||
                other.openingTime == openingTime) &&
            (identical(other.closingTime, closingTime) ||
                other.closingTime == closingTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, distanceKm, contact, openingTime, closingTime);

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SafeSpotImplCopyWith<_$SafeSpotImpl> get copyWith =>
      __$$SafeSpotImplCopyWithImpl<_$SafeSpotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SafeSpotImplToJson(
      this,
    );
  }
}

abstract class _SafeSpot extends SafeSpot {
  const factory _SafeSpot(
      {required final String name,
      required final int distanceKm,
      required final String contact,
      required final String openingTime,
      required final String closingTime}) = _$SafeSpotImpl;
  const _SafeSpot._() : super._();

  factory _SafeSpot.fromJson(Map<String, dynamic> json) =
      _$SafeSpotImpl.fromJson;

  @override
  String get name;
  @override
  int get distanceKm;
  @override
  String get contact;
  @override
  String get openingTime;
  @override
  String get closingTime;

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SafeSpotImplCopyWith<_$SafeSpotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
