import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/police_stations/model/police_station.dart';

void main() {
  group('PoliceStation', () {
    test('fromJson reads all fields', () {
      final station = PoliceStation.fromJson(const {
        'name': 'Central',
        'distanceKm': 4,
        'contact': '100',
      });

      expect(station.name, 'Central');
      expect(station.distanceKm, 4);
      expect(station.contact, '100');
    });

    test('toJson round-trips through fromJson', () {
      const original =
          PoliceStation(name: 'Central', distanceKm: 4, contact: '100');
      expect(PoliceStation.fromJson(original.toJson()), original);
    });
  });
}
