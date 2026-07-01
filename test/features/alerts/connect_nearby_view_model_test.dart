import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/error/app_exception.dart';
import 'package:security/features/alerts/data/alerts_repository.dart';
import 'package:security/features/alerts/model/nearby_alert.dart';
import 'package:security/features/alerts/view_model/connect_nearby_view_model.dart';

class _FakeAlertsRepository implements AlertsRepository {
  int saveCalls = 0;
  String? timeFrom;
  String? timeTo;

  @override
  Future<List<NearbyAlert>> fetchNearby() async => const [];

  @override
  Future<void> saveAlert({
    required String location,
    required String timeFrom,
    required String timeTo,
    required String message,
  }) async {
    saveCalls++;
    this.timeFrom = timeFrom;
    this.timeTo = timeTo;
  }
}

void main() {
  group('ConnectNearbyViewModel.saveAlert', () {
    late _FakeAlertsRepository repo;
    late ProviderContainer container;

    setUp(() {
      repo = _FakeAlertsRepository();
      container = ProviderContainer(
        overrides: [alertsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
    });

    test('throws AppException on an unparseable date', () async {
      final vm = container.read(connectNearbyViewModelProvider.notifier);

      expect(
        () => vm.saveAlert(
          location: 'Park',
          timeFrom: 'not-a-date',
          timeTo: 'nope',
          message: 'help',
        ),
        throwsA(isA<AppException>()),
      );
      expect(repo.saveCalls, 0);
    });

    test('parses DD-MM-YYYY dates to ISO-8601 before saving', () async {
      final vm = container.read(connectNearbyViewModelProvider.notifier);

      await vm.saveAlert(
        location: 'Park',
        timeFrom: '01-02-2024',
        timeTo: '02-02-2024',
        message: 'help',
      );

      expect(repo.saveCalls, 1);
      expect(repo.timeFrom, startsWith('2024-02-01'));
      expect(repo.timeTo, startsWith('2024-02-02'));
    });

    test('clearSuggestions empties the state', () {
      final vm = container.read(connectNearbyViewModelProvider.notifier);
      vm.clearSuggestions();
      expect(container.read(connectNearbyViewModelProvider), isEmpty);
    });
  });
}
