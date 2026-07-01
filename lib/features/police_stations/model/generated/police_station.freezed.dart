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

PoliceStation _$PoliceStationFromJson(Map<String, dynamic> json) {
  return _PoliceStation.fromJson(json);
}

/// @nodoc
mixin _$PoliceStation {
  String get name => throw _privateConstructorUsedError;
  int get distanceKm => throw _privateConstructorUsedError;
  String get contact => throw _privateConstructorUsedError;

  /// Serializes this PoliceStation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
  $Res call({String name, int distanceKm, String contact});
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
    Object? name = null,
    Object? distanceKm = null,
    Object? contact = null,
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
  $Res call({String name, int distanceKm, String contact});
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
    Object? name = null,
    Object? distanceKm = null,
    Object? contact = null,
  }) {
    return _then(_$PoliceStationImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoliceStationImpl implements _PoliceStation {
  const _$PoliceStationImpl(
      {required this.name, required this.distanceKm, required this.contact});

  factory _$PoliceStationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoliceStationImplFromJson(json);

  @override
  final String name;
  @override
  final int distanceKm;
  @override
  final String contact;

  @override
  String toString() {
    return 'PoliceStation(name: $name, distanceKm: $distanceKm, contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoliceStationImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, distanceKm, contact);

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoliceStationImplCopyWith<_$PoliceStationImpl> get copyWith =>
      __$$PoliceStationImplCopyWithImpl<_$PoliceStationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoliceStationImplToJson(
      this,
    );
  }
}

abstract class _PoliceStation implements PoliceStation {
  const factory _PoliceStation(
      {required final String name,
      required final int distanceKm,
      required final String contact}) = _$PoliceStationImpl;

  factory _PoliceStation.fromJson(Map<String, dynamic> json) =
      _$PoliceStationImpl.fromJson;

  @override
  String get name;
  @override
  int get distanceKm;
  @override
  String get contact;

  /// Create a copy of PoliceStation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoliceStationImplCopyWith<_$PoliceStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
