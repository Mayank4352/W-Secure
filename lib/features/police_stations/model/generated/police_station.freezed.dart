// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../police_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PoliceStation {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Straight-line distance from the user's current position.
  double get distanceKm => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoliceStationCopyWith<PoliceStation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoliceStationCopyWith<$Res> {
  factory $PoliceStationCopyWith(
          PoliceStation value, $Res Function(PoliceStation) then) =
      _$PoliceStationCopyWithImpl<$Res, PoliceStation>;
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      double distanceKm,
      String? address});
}

/// @nodoc
class _$PoliceStationCopyWithImpl<$Res, $Val extends PoliceStation>
    implements $PoliceStationCopyWith<$Res> {
  _$PoliceStationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distanceKm = null,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PoliceStationImplCopyWith<$Res>
    implements $PoliceStationCopyWith<$Res> {
  factory _$$PoliceStationImplCopyWith(
          _$PoliceStationImpl value, $Res Function(_$PoliceStationImpl) then) =
      __$$PoliceStationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      double distanceKm,
      String? address});
}

/// @nodoc
class __$$PoliceStationImplCopyWithImpl<$Res>
    extends _$PoliceStationCopyWithImpl<$Res, _$PoliceStationImpl>
    implements _$$PoliceStationImplCopyWith<$Res> {
  __$$PoliceStationImplCopyWithImpl(
      _$PoliceStationImpl _value, $Res Function(_$PoliceStationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distanceKm = null,
    Object? address = freezed,
  }) {
    return _then(_$PoliceStationImpl(
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PoliceStationImpl extends _PoliceStation {
  const _$PoliceStationImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.distanceKm,
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
  final String? address;

  @override
  String toString() {
    return 'PoliceStation(id: $id, name: $name, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoliceStationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, latitude, longitude, distanceKm, address);

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoliceStationImplCopyWith<_$PoliceStationImpl> get copyWith =>
      __$$PoliceStationImplCopyWithImpl<_$PoliceStationImpl>(this, _$identity);
}

abstract class _PoliceStation extends PoliceStation {
  const factory _PoliceStation(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      required final double distanceKm,
      final String? address}) = _$PoliceStationImpl;
  const _PoliceStation._() : super._();

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
  String? get address;

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoliceStationImplCopyWith<_$PoliceStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
