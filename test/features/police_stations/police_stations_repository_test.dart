import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/police_stations/data/police_stations_repository.dart';

/// Serves fixed JSON as if it were a bundled asset.
class _FakeAssetBundle extends CachingAssetBundle {
  _FakeAssetBundle(this.contents);

  final String contents;

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(utf8.encode(contents));
    return ByteData.view(bytes.buffer);
  }
}

void main() {
  group('PoliceStationsRepository.fetchNearby', () {
    test('parses the bundled JSON into PoliceStation models', () async {
      final bundle = _FakeAssetBundle(
        '[{"name":"Central","distanceKm":4,"contact":"100"},'
        '{"name":"North","distanceKm":7,"contact":"101"}]',
      );
      final repo = PoliceStationsRepository(bundle);

      final stations = await repo.fetchNearby();

      expect(stations, hasLength(2));
      expect(stations.first.name, 'Central');
      expect(stations.last.contact, '101');
    });

    test('returns an empty list when the asset holds no rows', () async {
      final repo = PoliceStationsRepository(_FakeAssetBundle('[]'));
      expect(await repo.fetchNearby(), isEmpty);
    });
  });
}
