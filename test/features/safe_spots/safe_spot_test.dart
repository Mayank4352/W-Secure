import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/safe_spots/model/safe_spot.dart';

SafeSpot _spot({String open = '09:00', String close = '17:00'}) => SafeSpot(
      name: 'Shelter',
      distanceKm: 2,
      contact: '100',
      openingTime: open,
      closingTime: close,
    );

void main() {
  group('SafeSpot', () {
    test('fromJson reads all fields', () {
      final spot = SafeSpot.fromJson(const {
        'name': 'Shelter',
        'distanceKm': 2,
        'contact': '100',
        'openingTime': '09:00',
        'closingTime': '17:00',
      });

      expect(spot.name, 'Shelter');
      expect(spot.distanceKm, 2);
      expect(spot.contact, '100');
      expect(spot.openingTime, '09:00');
      expect(spot.closingTime, '17:00');
    });

    test('toJson round-trips through fromJson', () {
      final original = _spot();
      expect(SafeSpot.fromJson(original.toJson()), original);
    });

    group('isOpenAt', () {
      test('is true within opening hours', () {
        expect(_spot().isOpenAt(12 * 60), isTrue);
      });

      test('is false before opening', () {
        expect(_spot().isOpenAt(8 * 60), isFalse);
      });

      test('is false after closing', () {
        expect(_spot().isOpenAt(18 * 60), isFalse);
      });

      test('is inclusive of the opening and closing minute', () {
        final spot = _spot(open: '09:00', close: '17:00');
        expect(spot.isOpenAt(9 * 60), isTrue);
        expect(spot.isOpenAt(17 * 60), isTrue);
      });
    });
  });
}
