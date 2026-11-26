import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/cached_places.dart';
import '../models/place_result.dart';

class NearbyCache {
  const NearbyCache(this.fileName, {Future<Directory> Function()? directory})
      : _directory = directory;

  final String fileName;

  final Future<Directory> Function()? _directory;

  Future<List<PlaceResult>> readOrFetch({
    required double latitude,
    required double longitude,
    required bool forceRefresh,
    required Future<List<PlaceResult>> Function() fetch,
  }) async {
    final cached = await read();

    if (!forceRefresh &&
        cached != null &&
        cached.isUsableFrom(latitude, longitude)) {
      return cached.places;
    }

    final List<PlaceResult> fresh;
    try {
      fresh = await fetch();
    } catch (_) {
      if (cached != null && cached.places.isNotEmpty) return cached.places;
      rethrow;
    }

    await write(
      CachedPlaces(
        latitude: latitude,
        longitude: longitude,
        fetchedAt: DateTime.now(),
        places: fresh,
      ),
    );
    return fresh;
  }

  Future<CachedPlaces?> read() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return null;
      final decoded = json.decode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return null;
      return CachedPlaces.fromJson(decoded);
    } catch (_) {
      // A missing or unreadable cache is simply a miss.
      return null;
    }
  }

  Future<void> write(CachedPlaces entry) async {
    try {
      final file = await _file();
      await file.parent.create(recursive: true);
      await file.writeAsString(json.encode(entry.toJson()));
    } catch (_) {
      // Caching is an optimisation; failing to persist must not break a lookup.
    }
  }

  Future<void> clear() async {
    try {
      final file = await _file();
      if (file.existsSync()) await file.delete();
    } catch (_) {
      // Nothing to do: the next read simply misses.
    }
  }

  Future<File> _file() async {
    final directory =
        await (_directory?.call() ?? getApplicationSupportDirectory());
    return File('${directory.path}/nearby/$fileName');
  }
}
