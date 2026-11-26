import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/data/asset_json.dart';

/// Serves a fixed string as if it were a bundled asset.
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
  group('loadJsonArray', () {
    test('decodes a JSON array of objects', () async {
      final bundle = _FakeAssetBundle('[{"a":1},{"a":2}]');

      final rows = await loadJsonArray(bundle, 'assets/x.json');

      expect(rows, hasLength(2));
      expect(rows.first['a'], 1);
      expect(rows.last['a'], 2);
    });

    test('returns an empty list for an empty array', () async {
      final bundle = _FakeAssetBundle('[]');

      final rows = await loadJsonArray(bundle, 'assets/x.json');

      expect(rows, isEmpty);
    });
  });
}
