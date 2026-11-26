import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/data/nearby_cache.dart';
import 'package:security/core/models/cached_places.dart';
import 'package:security/core/models/place_result.dart';
import 'package:security/core/utils/geo_distance.dart';

const _origin = (lat: 28.4744, lng: 77.5040);

const _places = [
  PlaceResult(
    id: 'node/1',
    name: 'Kailash Hospital',
    latitude: 28.4712,
    longitude: 77.5033,
    primaryType: 'hospital',
    types: ['hospital'],
  ),
];

({double lat, double lng}) _northOf(
    ({double lat, double lng}) from, double metres) {
  return (lat: from.lat + metres / 111320.0, lng: from.lng);
}

void main() {
  late Directory tempDir;
  late NearbyCache cache;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nearby_cache_test');
    cache = NearbyCache('places.json', directory: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  group('CachedPlaces.isUsableFrom', () {
    final entry = CachedPlaces(
      latitude: _origin.lat,
      longitude: _origin.lng,
      fetchedAt: DateTime(2026, 1, 1),
      places: _places,
    );

    test('reuses results while the user is inside the radius', () {
      final nearby = _northOf(_origin, 900);
      expect(entry.isUsableFrom(nearby.lat, nearby.lng), isTrue);
    });

    test('stops reusing results once the user has moved past it', () {
      final far = _northOf(_origin, 1100);
      expect(entry.isUsableFrom(far.lat, far.lng), isFalse);
    });

    test('the radius is one kilometre', () {
      expect(CachedPlaces.reuseRadiusMeters, 1000.0);
    });
  });

  group('NearbyCache.readOrFetch', () {
    test('runs the lookup and stores it on a cold cache', () async {
      var calls = 0;
      final result = await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async {
          calls++;
          return _places;
        },
      );

      expect(calls, 1);
      expect(result, _places);
      expect((await cache.read())!.places, _places);
    });

    test('serves the stored results without a lookup nearby', () async {
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async => _places,
      );

      var calls = 0;
      final nearby = _northOf(_origin, 500);
      final result = await cache.readOrFetch(
        latitude: nearby.lat,
        longitude: nearby.lng,
        forceRefresh: false,
        fetch: () async {
          calls++;
          return const <PlaceResult>[];
        },
      );

      expect(calls, 0, reason: 'a 500 m move must not cost an API call');
      expect(result, _places);
    });

    test('looks up again once the user moves beyond a kilometre', () async {
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async => _places,
      );

      var calls = 0;
      final far = _northOf(_origin, 1500);
      await cache.readOrFetch(
        latitude: far.lat,
        longitude: far.lng,
        forceRefresh: false,
        fetch: () async {
          calls++;
          return const <PlaceResult>[];
        },
      );

      expect(calls, 1);
      final stored = (await cache.read())!;
      expect(stored.latitude, closeTo(far.lat, 1e-9));
    });

    test('forceRefresh re-queries even standing still', () async {
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async => _places,
      );

      var calls = 0;
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: true,
        fetch: () async {
          calls++;
          return const <PlaceResult>[];
        },
      );

      expect(calls, 1);
    });

    test('survives a restart: a fresh instance reads the same file', () async {
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async => _places,
      );

      final reopened =
          NearbyCache('places.json', directory: () async => tempDir);
      var calls = 0;
      final result = await reopened.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async {
          calls++;
          return const <PlaceResult>[];
        },
      );

      expect(calls, 0, reason: 'a cold start nearby must not cost a call');
      expect(result.single.name, 'Kailash Hospital');
    });

    test('serves stale results when the lookup fails', () async {
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async => _places,
      );

      // Far enough that the cache would normally be refused.
      final far = _northOf(_origin, 5000);
      final result = await cache.readOrFetch(
        latitude: far.lat,
        longitude: far.lng,
        forceRefresh: false,
        fetch: () async => throw Exception('overpass is at capacity'),
      );

      expect(result, _places);
    });

    test('serves stale results when a forced refresh fails', () async {
      await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async => _places,
      );

      final result = await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: true,
        fetch: () async => throw Exception('overpass is at capacity'),
      );

      expect(result, _places);
    });

    test('surfaces the failure when there is nothing cached to fall back on',
        () async {
      expect(
        () => cache.readOrFetch(
          latitude: _origin.lat,
          longitude: _origin.lng,
          forceRefresh: false,
          fetch: () async => throw Exception('overpass is at capacity'),
        ),
        throwsException,
      );
    });

    test('treats a corrupt cache file as a miss', () async {
      final file = File('${tempDir.path}/nearby/places.json');
      await file.parent.create(recursive: true);
      await file.writeAsString('this is not json');

      var calls = 0;
      final result = await cache.readOrFetch(
        latitude: _origin.lat,
        longitude: _origin.lng,
        forceRefresh: false,
        fetch: () async {
          calls++;
          return _places;
        },
      );

      expect(calls, 1);
      expect(result, _places);
    });
  });

  group('distanceMeters', () {
    test('matches a known separation', () {
      // One degree of latitude is close to 111 km.
      expect(distanceMeters(0, 0, 1, 0), closeTo(111195, 50));
    });

    test('is zero for the same point', () {
      expect(distanceMeters(28.47, 77.50, 28.47, 77.50), 0);
    });
  });
}
