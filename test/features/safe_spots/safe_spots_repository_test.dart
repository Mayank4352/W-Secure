import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/data/nearby_cache.dart';
import 'package:security/core/models/place_result.dart';
import 'package:security/core/services/overpass_service.dart';
import 'package:security/features/safe_spots/data/safe_spots_repository.dart';
import 'package:security/features/safe_spots/model/safe_spot_category.dart';

const _user = (lat: 28.4744, lng: 77.5040);

const _near = PlaceResult(
  id: 'node/near',
  name: 'Kailash Hospital',
  latitude: 28.4753,
  longitude: 77.5040,
  primaryType: 'hospital',
);

const _far = PlaceResult(
  id: 'way/far',
  name: 'Ansal Plaza',
  latitude: 28.5200,
  longitude: 77.5040,
  primaryType: 'shopping_mall',
);

class _FakeOverpassService implements OverpassService {
  _FakeOverpassService(this.places);

  List<PlaceResult> places;
  int calls = 0;
  List<String>? lastTypes;
  double? lastRadiusMeters;

  @override
  Future<List<PlaceResult>> searchNearby({
    required double latitude,
    required double longitude,
    required List<String> types,
    double radiusMeters = 10000,
  }) async {
    calls++;
    lastTypes = types;
    lastRadiusMeters = radiusMeters;
    return places;
  }
}

List<PlaceResult> _ladder(int count) => [
      for (var i = 0; i < count; i++)
        PlaceResult(
          id: 'node/$i',
          name: 'Pharmacy $i',
          latitude: _user.lat + (count - i) * 0.001,
          longitude: _user.lng,
          primaryType: 'pharmacy',
        ),
    ];

void main() {
  late Directory tempDir;
  late NearbyCache cache;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('safe_spots_repo_test');
    cache = NearbyCache('safe_spots.json', directory: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  group('SafeSpotsRepository.fetchNearby', () {
    test('asks Overpass for the safe-spot categories within the radius',
        () async {
      final service = _FakeOverpassService(const [_near]);
      await SafeSpotsRepository(service, cache).fetchNearby(
        latitude: _user.lat,
        longitude: _user.lng,
      );

      expect(service.lastTypes, SafeSpotCategory.searchTypes);
      expect(service.lastRadiusMeters, SafeSpotsRepository.searchRadiusMeters);
    });

    test('maps results to spots, nearest first', () async {
      final spots =
          await SafeSpotsRepository(_FakeOverpassService(const [_far, _near]),
                  cache)
              .fetchNearby(latitude: _user.lat, longitude: _user.lng);

      expect(spots.map((s) => s.id), ['node/near', 'way/far']);
      expect(spots.first.category, SafeSpotCategory.hospital);
      expect(spots.last.category, SafeSpotCategory.shoppingMall);
      expect(spots.first.distanceKm, closeTo(0.1, 0.02));
    });

    test('keeps only the closest maxResults in a dense city', () async {
      final spots = await SafeSpotsRepository(
        _FakeOverpassService(_ladder(SafeSpotsRepository.maxResults + 12)),
        cache,
      ).fetchNearby(latitude: _user.lat, longitude: _user.lng);

      expect(spots, hasLength(SafeSpotsRepository.maxResults));
      expect(spots.first.id, 'node/51');
      expect(
        spots.first.distanceKm,
        lessThan(spots.last.distanceKm),
      );
    });

    test('a short move is served from the cache without another call',
        () async {
      final service = _FakeOverpassService(const [_near]);
      final repo = SafeSpotsRepository(service, cache);
      await repo.fetchNearby(latitude: _user.lat, longitude: _user.lng);

      await repo.fetchNearby(
        latitude: _user.lat + 0.004,
        longitude: _user.lng,
      );

      expect(service.calls, 1);
    });

    test('forceRefresh queries again from the same spot', () async {
      final service = _FakeOverpassService(const [_near]);
      final repo = SafeSpotsRepository(service, cache);
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
