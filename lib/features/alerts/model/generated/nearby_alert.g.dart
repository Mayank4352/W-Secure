// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../nearby_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearbyAlertImpl _$$NearbyAlertImplFromJson(Map<String, dynamic> json) =>
    _$NearbyAlertImpl(
      distanceKm: (json['distanceKm'] as num).toInt(),
      time: json['time'] as String,
    );

Map<String, dynamic> _$$NearbyAlertImplToJson(_$NearbyAlertImpl instance) =>
    <String, dynamic>{
      'distanceKm': instance.distanceKm,
      'time': instance.time,
    };
