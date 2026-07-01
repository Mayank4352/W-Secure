import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/alerts/data/alerts_repository.dart';
import 'package:security/features/alerts/model/nearby_alert.dart';
import 'package:security/features/alerts/view_model/alerts_view_model.dart';

class _FakeAlertsRepository implements AlertsRepository {
  _FakeAlertsRepository(this.alerts);

  List<NearbyAlert> alerts;

  @override
  Future<List<NearbyAlert>> fetchNearby() async => alerts;

  @override
  Future<void> saveAlert({
    required String location,
    required String timeFrom,
    required String timeTo,
    required String message,
  }) async {}
}

void main() {
  group('AlertsViewModel', () {
    test('build exposes the nearby alerts from the repository', () async {
      final repo = _FakeAlertsRepository(
        const [NearbyAlert(distanceKm: 2, time: 'now')],
      );
      final container = ProviderContainer(
        overrides: [alertsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final alerts = await container.read(alertsViewModelProvider.future);

      expect(alerts, hasLength(1));
      expect(alerts.single.distanceKm, 2);
    });
  });
}
