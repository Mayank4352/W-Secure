import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/data/nearby_cache.dart';
import 'package:security/core/models/place_result.dart';
import 'package:security/core/services/places_service.dart';
import 'package:security/features/police_stations/data/police_stations_repository.dart';

const _user = (lat: 28.6000, lng: 77.3700);

const _near = PlaceResult(
  id: 'places/near',
  name: 'Sector 58 Police Station',
  latitude: 28.6012,
  longitude: 77.3701,
  primaryType: 'police',
);

const _far = PlaceResult(
  id: 'places/far',
  name: 'Sector 20 Police Station',
  latitude: 28.6500,
  longitude: 77.3700,
  primaryType: 'police',
);

class _FakePlacesService implements PlacesService {
  _FakePlacesService(this.places);

  List<PlaceResult> places;
  int calls = 0;
  List<String>? lastIncludedTypes;
  double? lastRadiusMeters;

  @override
  Future<List<PlaceResult>> searchNearby({
    required double latitude,
    required double longitude,
    required List<String> includedTypes,
    double radiusMeters = 10000,
    int maxResults = PlacesService.maxResultCount,
  }) async {
    calls++;
    lastIncludedTypes = includedTypes;
    lastRadiusMeters = radiusMeters;
    return places;
  }
}

void main() {
  late Directory tempDir;
  late NearbyCache cache;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('police_repo_test');
    cache = NearbyCache('police_stations.json', directory: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  group('PoliceStationsRepository.fetchNearby', () {
    test('asks Places for police within the search radius', () async {
      final service = _FakePlacesService(const [_near]);
      await PoliceStationsRepository(service, cache).fetchNearby(
        latitude: _user.lat,
        longitude: _user.lng,
      );

      expect(service.lastIncludedTypes, ['police']);
      expect(
        service.lastRadiusMeters,
        PoliceStationsRepository.searchRadiusMeters,
      );
    });

    test('maps results to stations, nearest first', () async {
      final stations =
          await PoliceStationsRepository(_FakePlacesService(const [_far, _near]),
                  cache)
              .fetchNearby(latitude: _user.lat, longitude: _user.lng);

      expect(stations.map((s) => s.id), ['places/near', 'places/far']);
      expect(stations.first.distanceKm, closeTo(0.134, 0.02));
      expect(stations.last.distanceKm, closeTo(5.57, 0.1));
    });

    test('measures distance from the user, not from the cached lookup',
        () async {
      final repo =
          PoliceStationsRepository(_FakePlacesService(const [_near]), cache);
      await repo.fetchNearby(latitude: _user.lat, longitude: _user.lng);

      final moved = await repo.fetchNearby(
        latitude: _user.lat + 0.005,
        longitude: _user.lng,
      );

      expect(moved.single.distanceKm, closeTo(0.42, 0.05));
    });

    test('a short move is served from the cache without another call',
        () async {
      final service = _FakePlacesService(const [_near]);
      final repo = PoliceStationsRepository(service, cache);
      await repo.fetchNearby(latitude: _user.lat, longitude: _user.lng);

      await repo.fetchNearby(
        latitude: _user.lat + 0.004,
        longitude: _user.lng,
      );

      expect(service.calls, 1);
    });

    test('forceRefresh queries again from the same spot', () async {
      final service = _FakePlacesService(const [_near]);
      final repo = PoliceStationsRepository(service, cache);
      await repo.fetchNearby(latitude: _user.lat, longitude: _user.lng);

      await repo.fetchNearby(
        latitude: _user.lat,
        longitude: _user.lng,
        forceRefresh: true,
      );

      expect(service.calls, 2);
    });
  });
}
