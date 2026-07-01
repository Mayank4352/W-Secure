import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/asset_json.dart';
import '../model/safe_spot.dart';

part 'generated/safe_spots_repository.g.dart';

class SafeSpotsRepository {
  const SafeSpotsRepository(this._bundle);

  final AssetBundle _bundle;

  Future<List<SafeSpot>> fetchNearby() async {
    final rows = await loadJsonArray(_bundle, 'assets/data/safe_spots.json');
    return rows.map(SafeSpot.fromJson).toList();
  }
}

@riverpod
SafeSpotsRepository safeSpotsRepository(Ref ref) =>
    SafeSpotsRepository(rootBundle);
