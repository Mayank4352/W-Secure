// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../police_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoliceStationImpl _$$PoliceStationImplFromJson(Map<String, dynamic> json) =>
    _$PoliceStationImpl(
      name: json['name'] as String,
      distanceKm: (json['distanceKm'] as num).toInt(),
      contact: json['contact'] as String,
    );

Map<String, dynamic> _$$PoliceStationImplToJson(_$PoliceStationImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'distanceKm': instance.distanceKm,
      'contact': instance.contact,
    };
