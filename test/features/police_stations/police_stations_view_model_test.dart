import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:security/core/services/location_service.dart';
import 'package:security/features/police_stations/data/police_stations_repository.dart';
import 'package:security/features/police_stations/model/police_station.dart';
import 'package:security/features/police_stations/view_model/police_stations_view_model.dart';

class _FakeLocationService implements LocationService {
  @override
  Future<Position> currentPosition() async => Position(
        latitude: 28.6,
        longitude: 77.37,
        timestamp: DateTime.utc(2026, 1, 1),
        accuracy: 5,
        altitude: 0,
        altitudeAccuracy: 1,
        heading: 0,
        headingAccuracy: 1,
        speed: 0,
        speedAccuracy: 1,
      );
}

class _FakePoliceStationsRepository implements PoliceStationsRepository {
  _FakePoliceStationsRepository(this.stations);

  List<PoliceStation> stations;
  int fetchCalls = 0;
  bool? lastForceRefresh;

  @override
  Future<List<PoliceStation>> fetchNearby({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    fetchCalls++;
    lastForceRefresh = forceRefresh;
    return stations;
  }
}

ProviderContainer _containerWith(_FakePoliceStationsRepository repo) {
  final container = ProviderContainer(
    overrides: [
      locationServiceProvider.overrideWithValue(_FakeLocationService()),
      policeStationsRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

const _central = PoliceStation(
  id: 'places/central',
  name: 'Central',
  latitude: 28.6012,
  longitude: 77.3701,
  distanceKm: 4,
);

const _north = PoliceStation(
  id: 'places/north',
  name: 'North',
  latitude: 28.65,
  longitude: 77.37,
  distanceKm: 7,
);

void main() {
  group('PoliceStationsViewModel', () {
    test('build exposes the stations from the repository', () async {
      final container = _containerWith(
        _FakePoliceStationsRepository(const [_central]),
      );

      final stations =
          await container.read(policeStationsViewModelProvider.future);

      expect(stations.single.name, 'Central');
    });

    test('build looks the stations up at the current position', () async {
      final repo = _FakePoliceStationsRepository(const [_central]);
      final container = _containerWith(repo);

      await container.read(policeStationsViewModelProvider.future);

      expect(repo.fetchCalls, 1);
      expect(repo.lastForceRefresh, isFalse);
    });

    test('refresh re-fetches and updates the state', () async {
      final repo = _FakePoliceStationsRepository(const []);
      final container = _containerWith(repo);
      await container.read(policeStationsViewModelProvider.future);

      repo.stations = const [_north];
      await container.read(policeStationsViewModelProvider.notifier).refresh();

      expect(repo.fetchCalls, 2);
      expect(
        container.read(policeStationsViewModelProvider).valueOrNull?.single.name,
        'North',
      );
    });

    test('refresh bypasses the distance cache', () async {
      final repo = _FakePoliceStationsRepository(const [_central]);
      final container = _containerWith(repo);
      await container.read(policeStationsViewModelProvider.future);

      await container.read(policeStationsViewModelProvider.notifier).refresh();

      expect(repo.lastForceRefresh, isTrue);
    });
  });
}
