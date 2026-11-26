import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../error/app_exception.dart';
import '../models/place_result.dart';
import '../providers/http_providers.dart';

part 'generated/places_service.g.dart';

class PlacesService {
  const PlacesService({
    required http.Client client,
    required String apiKey,
    required String baseUrl,
  })  : _client = client,
        _apiKey = apiKey,
        _baseUrl = baseUrl;

  final http.Client _client;
  final String _apiKey;
  final String _baseUrl;

  static const maxRadiusMeters = 50000.0;
  static const maxResultCount = 20;

  static const _fieldMask = 'places.id,'
      'places.displayName,'
      'places.formattedAddress,'
      'places.location,'
      'places.primaryType,'
      'places.types,'
      'places.businessStatus';

  static const _timeout = Duration(seconds: 15);

  Future<List<PlaceResult>> searchNearby({
    required double latitude,
    required double longitude,
    required List<String> includedTypes,
    double radiusMeters = 10000,
    int maxResults = maxResultCount,
  }) async {
    if (_apiKey.isEmpty) {
      throw const AppException(
        'Google Maps API key is missing. Build with '
        '--dart-define=GOOGLE_MAPS_API_KEY=your_key.',
      );
    }

    final body = <String, dynamic>{
      'includedTypes': includedTypes,
      'maxResultCount': maxResults.clamp(1, maxResultCount).toInt(),
      'rankPreference': 'DISTANCE',
      'locationRestriction': {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radiusMeters.clamp(1.0, maxRadiusMeters).toDouble(),
        },
      },
    };

    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('$_baseUrl/v1/places:searchNearby'),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': _apiKey,
              'X-Goog-FieldMask': _fieldMask,
            },
            body: json.encode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const AppException('The search timed out. Please try again.');
    } catch (_) {
      throw const AppException(
        'Could not reach Google Places. Check your connection.',
      );
    }

    if (response.statusCode != 200) {
      throw AppException(_errorMessage(response));
    }

    final Object? decoded;
    try {
      decoded = json.decode(response.body);
    } catch (_) {
      throw const AppException('Unexpected response from Google Places.');
    }

    // Google omits `places` entirely when nothing matches.
    final places = decoded is Map<String, dynamic>
        ? decoded['places'] as List<dynamic>?
        : null;

    return (places ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_parsePlace)
        .whereType<PlaceResult>()
        .toList();
  }

  // One unusable row drops out rather than failing the whole search.
  static PlaceResult? _parsePlace(Map<String, dynamic> json) {
    if (json['businessStatus'] == 'CLOSED_PERMANENTLY') return null;

    final location = json['location'];
    if (location is! Map<String, dynamic>) return null;

    final latitude = (location['latitude'] as num?)?.toDouble();
    final longitude = (location['longitude'] as num?)?.toDouble();
    if (latitude == null || longitude == null) return null;

    final displayName = json['displayName'];
    final name = displayName is Map<String, dynamic>
        ? displayName['text'] as String?
        : null;
    if (name == null || name.isEmpty) return null;

    return PlaceResult(
      id: json['id'] as String? ?? '$latitude,$longitude',
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: json['formattedAddress'] as String?,
      primaryType: json['primaryType'] as String?,
      types: (json['types'] as List<dynamic>?)?.whereType<String>().toList() ??
          const <String>[],
    );
  }

  String _errorMessage(http.Response response) {
    try {
      final error = (json.decode(response.body) as Map<String, dynamic>)['error'];
      if (error is Map<String, dynamic> && error['message'] is String) {
        return error['message'] as String;
      }
    } catch (_) {
      // Fall through to the status code below.
    }
    return 'Google Places request failed (${response.statusCode}).';
  }
}

@Riverpod(keepAlive: true)
PlacesService placesService(Ref ref) => PlacesService(
      client: ref.watch(httpClientProvider),
      apiKey: AppConfig.googleMapsApiKey,
      baseUrl: AppConfig.placesBaseUrl,
    );
