import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/police_stations/data/police_stations_repository.dart';
import 'package:security/features/police_stations/model/police_station.dart';
import 'package:security/features/police_stations/view_model/police_stations_view_model.dart';

class _FakePoliceStationsRepository implements PoliceStationsRepository {
  _FakePoliceStationsRepository(this.stations);

  List<PoliceStation> stations;
  int fetchCalls = 0;

  @override
  Future<List<PoliceStation>> fetchNearby() async {
    fetchCalls++;
    return stations;
  }
}

void main() {
  group('PoliceStationsViewModel', () {
    test('build exposes the stations from the repository', () async {
      final repo = _FakePoliceStationsRepository(
        const [PoliceStation(name: 'Central', distanceKm: 4, contact: '100')],
      );
      final container = ProviderContainer(
        overrides: [
          policeStationsRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final stations =
          await container.read(policeStationsViewModelProvider.future);

      expect(stations.single.name, 'Central');
    });

    test('refresh re-fetches and updates the state', () async {
      final repo = _FakePoliceStationsRepository(const []);
      final container = ProviderContainer(
        overrides: [
          policeStationsRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      await container.read(policeStationsViewModelProvider.future);

      repo.stations = const [
        PoliceStation(name: 'North', distanceKm: 7, contact: '101'),
      ];
      await container
          .read(policeStationsViewModelProvider.notifier)
          .refresh();

      expect(repo.fetchCalls, 2);
      expect(
        container.read(policeStationsViewModelProvider).valueOrNull?.single.name,
        'North',
      );
    });
  });
}
