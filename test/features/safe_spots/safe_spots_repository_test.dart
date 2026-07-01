import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/safe_spots/data/safe_spots_repository.dart';

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
  group('SafeSpotsRepository.fetchNearby', () {
    test('parses the bundled JSON into SafeSpot models', () async {
      final bundle = _FakeAssetBundle(
        '[{"name":"Shelter","distanceKm":2,"contact":"100",'
        '"openingTime":"09:00","closingTime":"17:00"}]',
      );
      final repo = SafeSpotsRepository(bundle);

      final spots = await repo.fetchNearby();

      expect(spots, hasLength(1));
      expect(spots.single.name, 'Shelter');
      expect(spots.single.isOpenAt(10 * 60), isTrue);
    });

    test('returns an empty list when the asset holds no rows', () async {
      final repo = SafeSpotsRepository(_FakeAssetBundle('[]'));
      expect(await repo.fetchNearby(), isEmpty);
    });
  });
}
