// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../nearby_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NearbyAlert _$NearbyAlertFromJson(Map<String, dynamic> json) {
  return _NearbyAlert.fromJson(json);
}

/// @nodoc
mixin _$NearbyAlert {
  int get distanceKm => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;

  /// Serializes this NearbyAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearbyAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearbyAlertCopyWith<NearbyAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyAlertCopyWith<$Res> {
  factory $NearbyAlertCopyWith(
          NearbyAlert value, $Res Function(NearbyAlert) then) =
      _$NearbyAlertCopyWithImpl<$Res, NearbyAlert>;
  @useResult
  $Res call({int distanceKm, String time});
}

/// @nodoc
class _$NearbyAlertCopyWithImpl<$Res, $Val extends NearbyAlert>
    implements $NearbyAlertCopyWith<$Res> {
  _$NearbyAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearbyAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceKm = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NearbyAlertImplCopyWith<$Res>
    implements $NearbyAlertCopyWith<$Res> {
  factory _$$NearbyAlertImplCopyWith(
          _$NearbyAlertImpl value, $Res Function(_$NearbyAlertImpl) then) =
      __$$NearbyAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int distanceKm, String time});
}

/// @nodoc
class __$$NearbyAlertImplCopyWithImpl<$Res>
    extends _$NearbyAlertCopyWithImpl<$Res, _$NearbyAlertImpl>
    implements _$$NearbyAlertImplCopyWith<$Res> {
  __$$NearbyAlertImplCopyWithImpl(
      _$NearbyAlertImpl _value, $Res Function(_$NearbyAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of NearbyAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceKm = null,
    Object? time = null,
  }) {
    return _then(_$NearbyAlertImpl(
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyAlertImpl implements _NearbyAlert {
  const _$NearbyAlertImpl({required this.distanceKm, required this.time});

  factory _$NearbyAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyAlertImplFromJson(json);

  @override
  final int distanceKm;
  @override
  final String time;

  @override
  String toString() {
    return 'NearbyAlert(distanceKm: $distanceKm, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyAlertImpl &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, distanceKm, time);

  /// Create a copy of NearbyAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyAlertImplCopyWith<_$NearbyAlertImpl> get copyWith =>
      __$$NearbyAlertImplCopyWithImpl<_$NearbyAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyAlertImplToJson(
      this,
    );
  }
}

abstract class _NearbyAlert implements NearbyAlert {
  const factory _NearbyAlert(
      {required final int distanceKm,
      required final String time}) = _$NearbyAlertImpl;

  factory _NearbyAlert.fromJson(Map<String, dynamic> json) =
      _$NearbyAlertImpl.fromJson;

  @override
  int get distanceKm;
  @override
  String get time;

  /// Create a copy of NearbyAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearbyAlertImplCopyWith<_$NearbyAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
