import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/geo_distance.dart';
import 'place_result.dart';

part 'generated/cached_places.freezed.dart';
part 'generated/cached_places.g.dart';

@freezed
class CachedPlaces with _$CachedPlaces {
  const CachedPlaces._();

  const factory CachedPlaces({
    required double latitude,
    required double longitude,
    required DateTime fetchedAt,
    required List<PlaceResult> places,
  }) = _CachedPlaces;

  factory CachedPlaces.fromJson(Map<String, dynamic> json) =>
      _$CachedPlacesFromJson(json);

  static const reuseRadiusMeters = 1000.0;

  bool isUsableFrom(double latitude, double longitude) =>
      distanceMeters(this.latitude, this.longitude, latitude, longitude) <=
      reuseRadiusMeters;
}
