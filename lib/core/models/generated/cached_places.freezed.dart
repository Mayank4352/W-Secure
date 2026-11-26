// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../cached_places.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CachedPlaces _$CachedPlacesFromJson(Map<String, dynamic> json) {
  return _CachedPlaces.fromJson(json);
}

/// @nodoc
mixin _$CachedPlaces {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  DateTime get fetchedAt => throw _privateConstructorUsedError;
  List<PlaceResult> get places => throw _privateConstructorUsedError;

  /// Serializes this CachedPlaces to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CachedPlaces
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CachedPlacesCopyWith<CachedPlaces> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CachedPlacesCopyWith<$Res> {
  factory $CachedPlacesCopyWith(
          CachedPlaces value, $Res Function(CachedPlaces) then) =
      _$CachedPlacesCopyWithImpl<$Res, CachedPlaces>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      DateTime fetchedAt,
      List<PlaceResult> places});
}

/// @nodoc
class _$CachedPlacesCopyWithImpl<$Res, $Val extends CachedPlaces>
    implements $CachedPlacesCopyWith<$Res> {
  _$CachedPlacesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CachedPlaces
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? fetchedAt = null,
    Object? places = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceResult>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CachedPlacesImplCopyWith<$Res>
    implements $CachedPlacesCopyWith<$Res> {
  factory _$$CachedPlacesImplCopyWith(
          _$CachedPlacesImpl value, $Res Function(_$CachedPlacesImpl) then) =
      __$$CachedPlacesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      DateTime fetchedAt,
      List<PlaceResult> places});
}

/// @nodoc
class __$$CachedPlacesImplCopyWithImpl<$Res>
    extends _$CachedPlacesCopyWithImpl<$Res, _$CachedPlacesImpl>
    implements _$$CachedPlacesImplCopyWith<$Res> {
  __$$CachedPlacesImplCopyWithImpl(
      _$CachedPlacesImpl _value, $Res Function(_$CachedPlacesImpl) _then)
      : super(_value, _then);

  /// Create a copy of CachedPlaces
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? fetchedAt = null,
    Object? places = null,
  }) {
    return _then(_$CachedPlacesImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      fetchedAt: null == fetchedAt
          ? _value.fetchedAt
          : fetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceResult>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CachedPlacesImpl extends _CachedPlaces {
  const _$CachedPlacesImpl(
      {required this.latitude,
      required this.longitude,
      required this.fetchedAt,
      required final List<PlaceResult> places})
      : _places = places,
        super._();

  factory _$CachedPlacesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CachedPlacesImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final DateTime fetchedAt;
  final List<PlaceResult> _places;
  @override
  List<PlaceResult> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  String toString() {
    return 'CachedPlaces(latitude: $latitude, longitude: $longitude, fetchedAt: $fetchedAt, places: $places)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CachedPlacesImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.fetchedAt, fetchedAt) ||
                other.fetchedAt == fetchedAt) &&
            const DeepCollectionEquality().equals(other._places, _places));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude, fetchedAt,
      const DeepCollectionEquality().hash(_places));

  /// Create a copy of CachedPlaces
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CachedPlacesImplCopyWith<_$CachedPlacesImpl> get copyWith =>
      __$$CachedPlacesImplCopyWithImpl<_$CachedPlacesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CachedPlacesImplToJson(
      this,
    );
  }
}

abstract class _CachedPlaces extends CachedPlaces {
  const factory _CachedPlaces(
      {required final double latitude,
      required final double longitude,
      required final DateTime fetchedAt,
      required final List<PlaceResult> places}) = _$CachedPlacesImpl;
  const _CachedPlaces._() : super._();

  factory _CachedPlaces.fromJson(Map<String, dynamic> json) =
      _$CachedPlacesImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  DateTime get fetchedAt;
  @override
  List<PlaceResult> get places;

  /// Create a copy of CachedPlaces
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CachedPlacesImplCopyWith<_$CachedPlacesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
