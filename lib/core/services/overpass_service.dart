import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../error/app_exception.dart';
import '../models/place_result.dart';
import '../providers/http_providers.dart';

part 'generated/overpass_service.g.dart';

class OverpassService {
  const OverpassService({
    required http.Client client,
    required List<String> baseUrls,
  })  : _client = client,
        _baseUrls = baseUrls;

  final http.Client _client;

  final List<String> _baseUrls;
  static const _userAgent = 'w_secure_app/1.0';

  static const _timeout = Duration(seconds: 30);
  static const _amenityTypes = <String, String>{
    'hospital': 'hospital',
    'clinic': 'hospital',
    'pharmacy': 'pharmacy',
    'fire_station': 'fire_station',
    'police': 'police',
  };

  static const _shopTypes = <String, String>{
    'mall': 'shopping_mall',
    'department_store': 'shopping_mall',
  };

  Future<List<PlaceResult>> searchNearby({
    required double latitude,
    required double longitude,
    required List<String> types,
    double radiusMeters = 10000,
  }) async {
    final radius = radiusMeters.round();
    final around = 'around:$radius,$latitude,$longitude';

    final amenities = [
      for (final entry in _amenityTypes.entries)
        if (types.contains(entry.value)) entry.key,
    ];
    final shops = [
      for (final entry in _shopTypes.entries)
        if (types.contains(entry.value)) entry.key,
    ];

    final clauses = [
      if (amenities.isNotEmpty)
        'nwr["amenity"~"^(${amenities.join('|')})\$"]($around);',
      if (shops.isNotEmpty) 'nwr["shop"~"^(${shops.join('|')})\$"]($around);',
    ];
    if (clauses.isEmpty) return const [];

    // `out center` gives ways and relations a usable point.
    final query =
        '[out:json][timeout:25];(${clauses.join()});out center tags;';

    final response = await _post(query);

    final Object? decoded;
    try {
      decoded = json.decode(response.body);
    } catch (_) {
      throw const AppException('Unexpected response from OpenStreetMap.');
    }

    final elements = decoded is Map<String, dynamic>
        ? decoded['elements'] as List<dynamic>?
        : null;

    return (elements ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(parseElement)
        .whereType<PlaceResult>()
        .toList();
  }

  static PlaceResult? parseElement(Map<String, dynamic> element) {
    final center = element['center'];
    final centerMap = center is Map<String, dynamic> ? center : null;
    final latitude = (element['lat'] as num?)?.toDouble() ??
        (centerMap?['lat'] as num?)?.toDouble();
    final longitude = (element['lon'] as num?)?.toDouble() ??
        (centerMap?['lon'] as num?)?.toDouble();
    if (latitude == null || longitude == null) return null;

    final tags = element['tags'];
    if (tags is! Map<String, dynamic>) return null;

    final type = _amenityTypes[tags['amenity']] ?? _shopTypes[tags['shop']];
    if (type == null) return null;

    final name = tags['name'];
    final hasName = name is String && name.trim().isNotEmpty;

    return PlaceResult(
      id: '${element['type'] ?? 'node'}/${element['id'] ?? '$latitude,$longitude'}',
      // Many OSM entries are unnamed but still worth showing.
      name: hasName ? name.trim() : _fallbackName(type),
      latitude: latitude,
      longitude: longitude,
      address: _address(tags),
      primaryType: type,
      types: [type],
    );
  }

  // Public instances are often at capacity, so try each in turn.
  Future<http.Response> _post(String query) async {
    AppException? lastFailure;

    for (final baseUrl in _baseUrls) {
      final http.Response response;
      try {
        response = await _client
            .post(
              Uri.parse('$baseUrl/api/interpreter'),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'User-Agent': _userAgent,
              },
              body: {'data': query},
            )
            .timeout(_timeout);
      } on TimeoutException {
        lastFailure =
            const AppException('The search timed out. Please try again.');
        continue;
      } catch (_) {
        lastFailure = const AppException(
          'Could not reach OpenStreetMap. Check your connection.',
        );
        continue;
      }

      if (response.statusCode == 200) return response;

      // Rate limited or overloaded: another instance may answer.
      if (response.statusCode == 429 || response.statusCode >= 500) {
        lastFailure = const AppException(
          'OpenStreetMap is busy right now. Please try again in a moment.',
        );
        continue;
      }

      throw AppException(
        'OpenStreetMap request failed (${response.statusCode}).',
      );
    }

    throw lastFailure ??
        const AppException('No OpenStreetMap instance is configured.');
  }

  static String _fallbackName(String type) => switch (type) {
        'hospital' => 'Hospital',
        'pharmacy' => 'Pharmacy',
        'fire_station' => 'Fire station',
        'police' => 'Police station',
        'shopping_mall' => 'Shopping mall',
        _ => 'Safe spot',
      };

  static String? _address(Map<String, dynamic> tags) {
    final full = tags['addr:full'];
    if (full is String && full.trim().isNotEmpty) return full.trim();

    final parts = [
      for (final key in const [
        'addr:housenumber',
        'addr:street',
        'addr:suburb',
        'addr:city',
      ])
        if (tags[key] is String && (tags[key] as String).trim().isNotEmpty)
          (tags[key] as String).trim(),
    ];
    return parts.isEmpty ? null : parts.join(', ');
  }
}

@Riverpod(keepAlive: true)
OverpassService overpassService(Ref ref) => OverpassService(
      client: ref.watch(httpClientProvider),
      baseUrls: AppConfig.overpassBaseUrls,
    );
