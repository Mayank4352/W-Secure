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

/// @nodoc
mixin _$SafeSpot {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Straight-line distance from the user's current position.
  double get distanceKm => throw _privateConstructorUsedError;
  SafeSpotCategory get category => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

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
      {String id,
      String name,
      double latitude,
      double longitude,
      double distanceKm,
      SafeSpotCategory category,
      String? address});
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
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distanceKm = null,
    Object? category = null,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SafeSpotCategory,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String id,
      String name,
      double latitude,
      double longitude,
      double distanceKm,
      SafeSpotCategory category,
      String? address});
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
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distanceKm = null,
    Object? category = null,
    Object? address = freezed,
  }) {
    return _then(_$SafeSpotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SafeSpotCategory,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SafeSpotImpl extends _SafeSpot {
  const _$SafeSpotImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.distanceKm,
      required this.category,
      this.address})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;

  /// Straight-line distance from the user's current position.
  @override
  final double distanceKm;
  @override
  final SafeSpotCategory category;
  @override
  final String? address;

  @override
  String toString() {
    return 'SafeSpot(id: $id, name: $name, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, category: $category, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SafeSpotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, latitude, longitude,
      distanceKm, category, address);

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SafeSpotImplCopyWith<_$SafeSpotImpl> get copyWith =>
      __$$SafeSpotImplCopyWithImpl<_$SafeSpotImpl>(this, _$identity);
}

abstract class _SafeSpot extends SafeSpot {
  const factory _SafeSpot(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      required final double distanceKm,
      required final SafeSpotCategory category,
      final String? address}) = _$SafeSpotImpl;
  const _SafeSpot._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;

  /// Straight-line distance from the user's current position.
  @override
  double get distanceKm;
  @override
  SafeSpotCategory get category;
  @override
  String? get address;

  /// Create a copy of SafeSpot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SafeSpotImplCopyWith<_$SafeSpotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
