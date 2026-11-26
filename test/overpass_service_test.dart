import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:security/core/error/app_exception.dart';
import 'package:security/core/services/overpass_service.dart';

const _payload = {
  'elements': [
    {
      'type': 'node',
      'id': 1,
      'lat': 28.4712,
      'lon': 77.5033,
      'tags': {
        'amenity': 'hospital',
        'name': 'Kailash Hospital Greater Noida',
        'addr:housenumber': '12',
        'addr:street': 'Knowledge Park I',
        'addr:city': 'Greater Noida',
      },
    },
    {
      // A way: coordinates arrive under `center`.
      'type': 'way',
      'id': 2,
      'center': {'lat': 28.4755, 'lon': 77.5102},
      'tags': {'shop': 'mall', 'name': 'Ansal Plaza'},
    },
    {
      // Unnamed but real.
      'type': 'node',
      'id': 3,
      'lat': 28.4700,
      'lon': 77.5000,
      'tags': {'amenity': 'hospital'},
    },
    {
      // Unsearched category.
      'type': 'node',
      'id': 4,
      'lat': 28.47,
      'lon': 77.50,
      'tags': {'amenity': 'bench'},
    },
    {
      // No coordinates.
      'type': 'relation',
      'id': 5,
      'tags': {'amenity': 'hospital', 'name': 'Ghost'},
    },
  ],
};

OverpassService _serviceReturning(
  Object body, {
  int status = 200,
  void Function(http.Request)? onRequest,
}) =>
    OverpassService(
      baseUrls: const ['https://overpass.example.test'],
      client: MockClient((request) async {
        onRequest?.call(request);
        return http.Response(
          json.encode(body),
          status,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

void main() {
  group('OverpassService.parseElement', () {
    test('reads a node and assembles its address', () {
      final place = OverpassService.parseElement(
        (_payload['elements'] as List)[0] as Map<String, dynamic>,
      )!;

      expect(place.id, 'node/1');
      expect(place.name, 'Kailash Hospital Greater Noida');
      expect(place.latitude, 28.4712);
      expect(place.longitude, 77.5033);
      expect(place.address, '12, Knowledge Park I, Greater Noida');
      expect(place.primaryType, 'hospital');
    });

    test('reads a way via its center point', () {
      final place = OverpassService.parseElement(
        (_payload['elements'] as List)[1] as Map<String, dynamic>,
      )!;

      expect(place.id, 'way/2');
      expect(place.latitude, 28.4755);
      expect(place.primaryType, 'shopping_mall');
      expect(place.address, isNull);
    });

    test('keeps an unnamed place, naming it after its category', () {
      final place = OverpassService.parseElement(
        (_payload['elements'] as List)[2] as Map<String, dynamic>,
      )!;

      expect(place.name, 'Hospital');
      expect(place.primaryType, 'hospital');
    });

    test('drops an unrecognised type', () {
      expect(
        OverpassService.parseElement(
          (_payload['elements'] as List)[3] as Map<String, dynamic>,
        ),
        isNull,
      );
    });

    test('drops an element with no coordinates', () {
      expect(
        OverpassService.parseElement(
          (_payload['elements'] as List)[4] as Map<String, dynamic>,
        ),
        isNull,
      );
    });
  });

  group('OverpassService.searchNearby', () {
    test('builds an Overpass QL query for the requested categories', () async {
      late http.Request captured;
      await _serviceReturning(
        _payload,
        onRequest: (request) => captured = request,
      ).searchNearby(
        latitude: 28.4744,
        longitude: 77.5040,
        types: ['hospital', 'shopping_mall'],
        radiusMeters: 10000,
      );

      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/interpreter');
      expect(captured.headers['User-Agent'], isNotEmpty);

      final query = Uri.decodeComponent(captured.body.split('data=').last)
          .replaceAll('+', ' ');
      expect(query, contains('[out:json]'));
      expect(query, contains('around:10000,28.4744,77.504'));
      expect(query, contains(r'["amenity"~"^(hospital|clinic)$"]'));
      expect(query, contains(r'["shop"~"^(mall|department_store)$"]'));
      expect(query, isNot(contains('fire_station')));
      expect(query, isNot(contains('police')));
      expect(query, contains('out center tags'));
    });

    test('returns only the usable elements', () async {
      final places = await _serviceReturning(_payload).searchNearby(
        latitude: 28.4744,
        longitude: 77.5040,
        types: ['hospital', 'shopping_mall'],
      );

      expect(places.map((p) => p.id), ['node/1', 'way/2', 'node/3']);
    });

    test('makes no request when no known category is asked for', () async {
      var called = false;
      final service = OverpassService(
        baseUrls: const ['https://overpass.example.test'],
        client: MockClient((_) async {
          called = true;
          return http.Response('{}', 200);
        }),
      );

      final places = await service.searchNearby(
        latitude: 1,
        longitude: 1,
        types: ['casino'],
      );

      expect(places, isEmpty);
      expect(called, isFalse);
    });

    test('explains the fair-use rate limit rather than leaking a 429',
        () async {
      final service = _serviceReturning(<String, dynamic>{}, status: 429);
      expect(
        () => service.searchNearby(
            latitude: 1, longitude: 1, types: ['hospital']),
        throwsA(isA<AppException>()
            .having((e) => e.message, 'message', contains('busy'))),
      );
    });

    test('steps over an overloaded instance and uses the next one', () async {
      final tried = <String>[];
      final service = OverpassService(
        baseUrls: const [
          'https://busy.example.test',
          'https://spare.example.test',
        ],
        client: MockClient((request) async {
          tried.add(request.url.host);
          if (request.url.host == 'busy.example.test') {
            return http.Response('at capacity', 502);
          }
          return http.Response(
            json.encode(_payload),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final places = await service.searchNearby(
        latitude: 1,
        longitude: 1,
        types: ['hospital', 'shopping_mall'],
      );

      expect(tried, ['busy.example.test', 'spare.example.test']);
      expect(places, isNotEmpty);
    });

    test('gives up with a readable message when every instance is busy',
        () async {
      final service = OverpassService(
        baseUrls: const ['https://a.example.test', 'https://b.example.test'],
        client: MockClient((_) async => http.Response('at capacity', 503)),
      );

      expect(
        () => service.searchNearby(
            latitude: 1, longitude: 1, types: ['hospital']),
        throwsA(isA<AppException>()
            .having((e) => e.message, 'message', contains('busy'))),
      );
    });

    test('does not retry elsewhere on a request this app got wrong', () async {
      var calls = 0;
      final service = OverpassService(
        baseUrls: const ['https://a.example.test', 'https://b.example.test'],
        client: MockClient((_) async {
          calls++;
          return http.Response('bad query', 400);
        }),
      );

      await expectLater(
        () => service.searchNearby(
            latitude: 1, longitude: 1, types: ['hospital']),
        throwsA(isA<AppException>()),
      );
      expect(calls, 1, reason: 'a 400 would repeat on every instance');
    });

    test('treats a missing elements key as no results', () async {
      final places = await _serviceReturning(<String, dynamic>{}).searchNearby(
        latitude: 1,
        longitude: 1,
        types: ['hospital'],
      );
      expect(places, isEmpty);
    });
  });
}
