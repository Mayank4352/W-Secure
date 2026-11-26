import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/nearby_cache.dart';
import '../../../core/services/places_service.dart';
import '../../../core/utils/geo_distance.dart';
import '../model/police_station.dart';

part 'generated/police_stations_repository.g.dart';

class PoliceStationsRepository {
  const PoliceStationsRepository(this._places, this._cache);

  final PlacesService _places;
  final NearbyCache _cache;

  static const searchRadiusMeters = 20000.0;

  static const _includedTypes = ['police'];

  Future<List<PoliceStation>> fetchNearby({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    final places = await _cache.readOrFetch(
      latitude: latitude,
      longitude: longitude,
      forceRefresh: forceRefresh,
      fetch: () => _places.searchNearby(
        latitude: latitude,
        longitude: longitude,
        includedTypes: _includedTypes,
        radiusMeters: searchRadiusMeters,
      ),
    );

    // Measured from where the user is now, not where the cached lookup ran.
    return places
        .map(
          (place) => PoliceStation.fromPlace(
            place,
            distanceKm: distanceMeters(
                  latitude,
                  longitude,
                  place.latitude,
                  place.longitude,
                ) /
                1000,
          ),
        )
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }
}

@riverpod
PoliceStationsRepository policeStationsRepository(Ref ref) =>
    PoliceStationsRepository(
      ref.watch(placesServiceProvider),
      const NearbyCache('police_stations.json'),
    );
