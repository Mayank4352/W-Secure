import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/models/place_result.dart';
import 'package:security/features/police_stations/model/police_station.dart';

const _place = PlaceResult(
  id: 'places/ChIJ1',
  name: 'Sector 58 Police Station',
  latitude: 28.6012,
  longitude: 77.3701,
  address: 'Sector 58, Noida',
  primaryType: 'police',
  types: ['police', 'point_of_interest'],
);

void main() {
  group('PoliceStation.fromPlace', () {
    test('carries the place through with the measured distance', () {
      final station = PoliceStation.fromPlace(_place, distanceKm: 2.34);

      expect(station.id, 'places/ChIJ1');
      expect(station.name, 'Sector 58 Police Station');
      expect(station.latitude, 28.6012);
      expect(station.longitude, 77.3701);
      expect(station.address, 'Sector 58, Noida');
      expect(station.distanceKm, 2.34);
    });

    test('leaves the address null when the place has none', () {
      final station = PoliceStation.fromPlace(
        const PlaceResult(
          id: 'places/x',
          name: 'Police Outpost',
          latitude: 28.6,
          longitude: 77.37,
        ),
        distanceKm: 1,
      );

      expect(station.address, isNull);
      expect(station.name, 'Police Outpost');
    });
  });

  group('PoliceStation.distanceLabel', () {
    test('reads in metres below a kilometre', () {
      expect(
        PoliceStation.fromPlace(_place, distanceKm: 0.42).distanceLabel,
        '420 m',
      );
    });

    test('reads in kilometres to one decimal from a kilometre up', () {
      expect(
        PoliceStation.fromPlace(_place, distanceKm: 2.34).distanceLabel,
        '2.3 km',
      );
    });
  });
}
