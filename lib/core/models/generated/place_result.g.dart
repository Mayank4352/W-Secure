// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../place_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceResultImpl _$$PlaceResultImplFromJson(Map<String, dynamic> json) =>
    _$PlaceResultImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      primaryType: json['primaryType'] as String?,
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
    );

Map<String, dynamic> _$$PlaceResultImplToJson(_$PlaceResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'primaryType': instance.primaryType,
      'types': instance.types,
    };
