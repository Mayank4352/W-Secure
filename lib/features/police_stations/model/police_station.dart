import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/place_result.dart';
import '../../../core/utils/distance_format.dart';

part 'generated/police_station.freezed.dart';

@freezed
class PoliceStation with _$PoliceStation {
  const PoliceStation._();

  const factory PoliceStation({
    required String id,
    required String name,
    required double latitude,
    required double longitude,

    required double distanceKm,
    String? address,
  }) = _PoliceStation;

  factory PoliceStation.fromPlace(
    PlaceResult place, {
    required double distanceKm,
  }) =>
      PoliceStation(
        id: place.id,
        name: place.name,
        latitude: place.latitude,
        longitude: place.longitude,
        distanceKm: distanceKm,
        address: place.address,
      );

  String get distanceLabel => formatDistanceKm(distanceKm);
}
