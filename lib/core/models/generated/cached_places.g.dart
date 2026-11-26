// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../cached_places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CachedPlacesImpl _$$CachedPlacesImplFromJson(Map<String, dynamic> json) =>
    _$CachedPlacesImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      places: (json['places'] as List<dynamic>)
          .map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CachedPlacesImplToJson(_$CachedPlacesImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'fetchedAt': instance.fetchedAt.toIso8601String(),
      'places': instance.places,
    };
