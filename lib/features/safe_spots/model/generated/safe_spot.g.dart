// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../safe_spot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SafeSpotImpl _$$SafeSpotImplFromJson(Map<String, dynamic> json) =>
    _$SafeSpotImpl(
      name: json['name'] as String,
      distanceKm: (json['distanceKm'] as num).toInt(),
      contact: json['contact'] as String,
      openingTime: json['openingTime'] as String,
      closingTime: json['closingTime'] as String,
    );

Map<String, dynamic> _$$SafeSpotImplToJson(_$SafeSpotImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'distanceKm': instance.distanceKm,
      'contact': instance.contact,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
    };
