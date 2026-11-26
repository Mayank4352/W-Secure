// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../place_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceResult _$PlaceResultFromJson(Map<String, dynamic> json) {
  return _PlaceResult.fromJson(json);
}

/// @nodoc
mixin _$PlaceResult {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get primaryType => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;

  /// Serializes this PlaceResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceResultCopyWith<PlaceResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceResultCopyWith<$Res> {
  factory $PlaceResultCopyWith(
          PlaceResult value, $Res Function(PlaceResult) then) =
      _$PlaceResultCopyWithImpl<$Res, PlaceResult>;
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      String? address,
      String? primaryType,
      List<String> types});
}

/// @nodoc
class _$PlaceResultCopyWithImpl<$Res, $Val extends PlaceResult>
    implements $PlaceResultCopyWith<$Res> {
  _$PlaceResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? primaryType = freezed,
    Object? types = null,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryType: freezed == primaryType
          ? _value.primaryType
          : primaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceResultImplCopyWith<$Res>
    implements $PlaceResultCopyWith<$Res> {
  factory _$$PlaceResultImplCopyWith(
          _$PlaceResultImpl value, $Res Function(_$PlaceResultImpl) then) =
      __$$PlaceResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double latitude,
      double longitude,
      String? address,
      String? primaryType,
      List<String> types});
}

/// @nodoc
class __$$PlaceResultImplCopyWithImpl<$Res>
    extends _$PlaceResultCopyWithImpl<$Res, _$PlaceResultImpl>
    implements _$$PlaceResultImplCopyWith<$Res> {
  __$$PlaceResultImplCopyWithImpl(
      _$PlaceResultImpl _value, $Res Function(_$PlaceResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? primaryType = freezed,
    Object? types = null,
  }) {
    return _then(_$PlaceResultImpl(
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryType: freezed == primaryType
          ? _value.primaryType
          : primaryType // ignore: cast_nullable_to_non_nullable
              as String?,
      types: null == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceResultImpl extends _PlaceResult {
  const _$PlaceResultImpl(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.address,
      this.primaryType,
      final List<String> types = const <String>[]})
      : _types = types,
        super._();

  factory _$PlaceResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceResultImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  final String? primaryType;
  final List<String> _types;
  @override
  @JsonKey()
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  String toString() {
    return 'PlaceResult(id: $id, name: $name, latitude: $latitude, longitude: $longitude, address: $address, primaryType: $primaryType, types: $types)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.primaryType, primaryType) ||
                other.primaryType == primaryType) &&
            const DeepCollectionEquality().equals(other._types, _types));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, latitude, longitude,
      address, primaryType, const DeepCollectionEquality().hash(_types));

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceResultImplCopyWith<_$PlaceResultImpl> get copyWith =>
      __$$PlaceResultImplCopyWithImpl<_$PlaceResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceResultImplToJson(
      this,
    );
  }
}

abstract class _PlaceResult extends PlaceResult {
  const factory _PlaceResult(
      {required final String id,
      required final String name,
      required final double latitude,
      required final double longitude,
      final String? address,
      final String? primaryType,
      final List<String> types}) = _$PlaceResultImpl;
  const _PlaceResult._() : super._();

  factory _PlaceResult.fromJson(Map<String, dynamic> json) =
      _$PlaceResultImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  String? get primaryType;
  @override
  List<String> get types;

  /// Create a copy of PlaceResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceResultImplCopyWith<_$PlaceResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
