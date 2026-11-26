import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/place_result.dart';
import '../../../core/utils/distance_format.dart';
import 'safe_spot_category.dart';

part 'generated/safe_spot.freezed.dart';

@freezed
class SafeSpot with _$SafeSpot {
  const SafeSpot._();

  const factory SafeSpot({
    required String id,
    required String name,
    required double latitude,
    required double longitude,

    required double distanceKm,
    required SafeSpotCategory category,
    String? address,
  }) = _SafeSpot;

  factory SafeSpot.fromPlace(
    PlaceResult place, {
    required double distanceKm,
  }) =>
      SafeSpot(
        id: place.id,
        name: place.name,
        latitude: place.latitude,
        longitude: place.longitude,
        distanceKm: distanceKm,
        category: SafeSpotCategory.fromPlaceTypes(place.allTypes),
        address: place.address,
      );

  String get distanceLabel => formatDistanceKm(distanceKm);
}
