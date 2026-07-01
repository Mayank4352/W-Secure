import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/alerts/model/nearby_alert.dart';

void main() {
  group('NearbyAlert', () {
    test('fromJson reads distance and time', () {
      final alert = NearbyAlert.fromJson(const {
        'distanceKm': 3,
        'time': '10 min ago',
      });

      expect(alert.distanceKm, 3);
      expect(alert.time, '10 min ago');
    });

    test('toJson round-trips through fromJson', () {
      const original = NearbyAlert(distanceKm: 5, time: 'just now');
      expect(NearbyAlert.fromJson(original.toJson()), original);
    });

    test('value equality holds for identical data', () {
      expect(
        const NearbyAlert(distanceKm: 1, time: 'now'),
        const NearbyAlert(distanceKm: 1, time: 'now'),
      );
    });
  });
}
