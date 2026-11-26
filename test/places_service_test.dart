import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:security/core/error/app_exception.dart';
import 'package:security/core/services/places_service.dart';
import 'package:security/features/safe_spots/model/safe_spot_category.dart';

const _payload = {
  'places': [
    {
      'id': 'ChIJstation',
      'types': ['police', 'point_of_interest', 'establishment'],
      'formattedAddress': 'Knowledge Park, Greater Noida',
      'location': {'latitude': 28.4645, 'longitude': 77.5021},
      'businessStatus': 'OPERATIONAL',
      'displayName': {'text': 'Knowledge Park Police Station', 'languageCode': 'en'},
      'primaryType': 'police',
    },
    {
      // Permanently closed.
      'id': 'ChIJclosed',
      'location': {'latitude': 28.1, 'longitude': 77.1},
      'displayName': {'text': 'Old Station', 'languageCode': 'en'},
      'businessStatus': 'CLOSED_PERMANENTLY',
    },
    {
      // No location.
      'id': 'ChIJnoloc',
      'displayName': {'text': 'Nowhere', 'languageCode': 'en'},
    },
    {
      // No name.
      'id': 'ChIJnoname',
      'location': {'latitude': 28.2, 'longitude': 77.2},
    },
  ],
};

PlacesService _serviceReturning(
  Object body, {
  int status = 200,
  void Function(http.Request)? onRequest,
  String apiKey = 'test-key',
}) =>
    PlacesService(
      apiKey: apiKey,
      baseUrl: 'https://places.example.test',
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
  group('PlacesService.searchNearby', () {
    test('parses the nested Places payload', () async {
      final places = await _serviceReturning(_payload).searchNearby(
        latitude: 28.46,
        longitude: 77.50,
        includedTypes: ['police'],
      );

      expect(places, hasLength(1));
      final station = places.single;
      expect(station.id, 'ChIJstation');
      expect(station.name, 'Knowledge Park Police Station');
      expect(station.latitude, 28.4645);
      expect(station.longitude, 77.5021);
      expect(station.address, 'Knowledge Park, Greater Noida');
      expect(station.primaryType, 'police');
    });

    test('sends the documented headers and request body', () async {
      late http.Request captured;
      await _serviceReturning(
        _payload,
        onRequest: (request) => captured = request,
      ).searchNearby(
        latitude: 28.46,
        longitude: 77.50,
        includedTypes: ['hospital', 'pharmacy'],
        radiusMeters: 10000,
      );

      expect(captured.method, 'POST');
      expect(captured.url.path, '/v1/places:searchNearby');
      expect(captured.headers['X-Goog-Api-Key'], 'test-key');
      expect(captured.headers['X-Goog-FieldMask'], isNot(contains(' ')));
      expect(captured.headers['X-Goog-FieldMask'],
          isNot(contains('nationalPhoneNumber')));
      expect(captured.headers['X-Goog-FieldMask'],
          isNot(contains('regularOpeningHours')));

      final body = json.decode(captured.body) as Map<String, dynamic>;
      expect(body['includedTypes'], ['hospital', 'pharmacy']);
      expect(body['rankPreference'], 'DISTANCE');
      expect(body['maxResultCount'], 20);
      final circle = (body['locationRestriction']
          as Map<String, dynamic>)['circle'] as Map<String, dynamic>;
      expect(circle['radius'], 10000.0);
      expect(circle['center'], {'latitude': 28.46, 'longitude': 77.50});
    });

    test('clamps the radius and result count to the API limits', () async {
      late http.Request captured;
      await _serviceReturning(
        _payload,
        onRequest: (request) => captured = request,
      ).searchNearby(
        latitude: 1,
        longitude: 1,
        includedTypes: ['police'],
        radiusMeters: 999999,
        maxResults: 500,
      );

      final body = json.decode(captured.body) as Map<String, dynamic>;
      expect(body['maxResultCount'], PlacesService.maxResultCount);
      final circle = (body['locationRestriction']
          as Map<String, dynamic>)['circle'] as Map<String, dynamic>;
      expect(circle['radius'], PlacesService.maxRadiusMeters);
    });

    test('treats a missing places key as no results', () async {
      final places = await _serviceReturning(<String, dynamic>{}).searchNearby(
        latitude: 1,
        longitude: 1,
        includedTypes: ['police'],
      );
      expect(places, isEmpty);
    });

    test('surfaces the error message Google returns', () async {
      final service = _serviceReturning(
        {
          'error': {
            'code': 400,
            'message': 'API key not valid. Please pass a valid API key.',
          }
        },
        status: 400,
      );

      expect(
        () => service.searchNearby(
            latitude: 1, longitude: 1, includedTypes: ['police']),
        throwsA(isA<AppException>().having((e) => e.message, 'message',
            contains('API key not valid'))),
      );
    });

    test('explains a missing API key instead of calling the API', () async {
      final service = _serviceReturning(_payload, apiKey: '');
      expect(
        () => service.searchNearby(
            latitude: 1, longitude: 1, includedTypes: ['police']),
        throwsA(isA<AppException>()
            .having((e) => e.message, 'message', contains('GOOGLE_MAPS_API_KEY'))),
      );
    });
  });

  group('SafeSpotCategory', () {
    test('picks the most useful category when a place has several types', () {
      expect(
        SafeSpotCategory.fromPlaceTypes(['pharmacy', 'hospital']),
        SafeSpotCategory.hospital,
      );
    });

    test('maps each searched type to a category', () {
      expect(SafeSpotCategory.fromPlaceTypes(['fire_station']),
          SafeSpotCategory.fireStation);
      expect(SafeSpotCategory.fromPlaceTypes(['shopping_mall']),
          SafeSpotCategory.shoppingMall);
      expect(SafeSpotCategory.fromPlaceTypes(['drugstore']),
          SafeSpotCategory.pharmacy);
    });

    test('falls back to other for an unrecognised type', () {
      expect(SafeSpotCategory.fromPlaceTypes(['bowling_alley']),
          SafeSpotCategory.other);
    });
  });
}
