import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/nearby_cache.dart';
import '../../../core/services/overpass_service.dart';
import '../../../core/utils/geo_distance.dart';
import '../model/safe_spot.dart';
import '../model/safe_spot_category.dart';

part 'generated/safe_spots_repository.g.dart';

class SafeSpotsRepository {
  const SafeSpotsRepository(this._overpass, this._cache);

  final OverpassService _overpass;
  final NearbyCache _cache;

  static const searchRadiusMeters = 10000.0;

  static const maxResults = 40;

  Future<List<SafeSpot>> fetchNearby({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    final places = await _cache.readOrFetch(
      latitude: latitude,
      longitude: longitude,
      forceRefresh: forceRefresh,
      fetch: () => _overpass.searchNearby(
        latitude: latitude,
        longitude: longitude,
        types: SafeSpotCategory.searchTypes,
        radiusMeters: searchRadiusMeters,
      ),
    );

    // Measured from where the user is now, not where the cached lookup ran.
    final spots = places
        .map(
          (place) => SafeSpot.fromPlace(
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

    return spots.take(maxResults).toList();
  }
}

@riverpod
SafeSpotsRepository safeSpotsRepository(Ref ref) => SafeSpotsRepository(
      ref.watch(overpassServiceProvider),
      const NearbyCache('safe_spots.json'),
    );
