import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/models/place_result.dart';
import 'package:security/features/safe_spots/model/safe_spot.dart';
import 'package:security/features/safe_spots/model/safe_spot_category.dart';

const _place = PlaceResult(
  id: 'node/1',
  name: 'Kailash Hospital',
  latitude: 28.4712,
  longitude: 77.5033,
  address: '12, Knowledge Park I, Greater Noida',
  primaryType: 'hospital',
  types: ['hospital'],
);

void main() {
  group('SafeSpot.fromPlace', () {
    test('carries the place through with the measured distance', () {
      final spot = SafeSpot.fromPlace(_place, distanceKm: 3.45);

      expect(spot.id, 'node/1');
      expect(spot.name, 'Kailash Hospital');
      expect(spot.latitude, 28.4712);
      expect(spot.longitude, 77.5033);
      expect(spot.address, '12, Knowledge Park I, Greater Noida');
      expect(spot.distanceKm, 3.45);
    });

    test('derives the category from the place types', () {
      expect(
        SafeSpot.fromPlace(_place, distanceKm: 1).category,
        SafeSpotCategory.hospital,
      );
    });

    test('falls back to other for a type it does not recognise', () {
      final spot = SafeSpot.fromPlace(
        const PlaceResult(
          id: 'node/9',
          name: 'Community Centre',
          latitude: 28.47,
          longitude: 77.5,
          primaryType: 'community_centre',
        ),
        distanceKm: 1,
      );

      expect(spot.category, SafeSpotCategory.other);
    });

    test('leaves the address null when the place has none', () {
      final spot = SafeSpot.fromPlace(
        const PlaceResult(
          id: 'way/2',
          name: 'Ansal Plaza',
          latitude: 28.4755,
          longitude: 77.5102,
          primaryType: 'shopping_mall',
        ),
        distanceKm: 1,
      );

      expect(spot.address, isNull);
      expect(spot.category, SafeSpotCategory.shoppingMall);
    });
  });

  group('SafeSpot.distanceLabel', () {
    test('reads in metres below a kilometre', () {
      expect(SafeSpot.fromPlace(_place, distanceKm: 0.4).distanceLabel, '400 m');
    });

    test('reads in kilometres to one decimal from a kilometre up', () {
      expect(
        SafeSpot.fromPlace(_place, distanceKm: 3.45).distanceLabel,
        '3.5 km',
      );
    });
  });
}
