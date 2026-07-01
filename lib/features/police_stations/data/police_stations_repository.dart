import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/asset_json.dart';
import '../model/police_station.dart';

part 'generated/police_stations_repository.g.dart';

class PoliceStationsRepository {
  const PoliceStationsRepository(this._bundle);

  final AssetBundle _bundle;

  // Static seed data; will be replaced by a live API once access is granted.
  Future<List<PoliceStation>> fetchNearby() async {
    final rows =
        await loadJsonArray(_bundle, 'assets/data/police_stations.json');
    return rows.map(PoliceStation.fromJson).toList();
  }
}

@riverpod
PoliceStationsRepository policeStationsRepository(Ref ref) =>
    PoliceStationsRepository(rootBundle);
