import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:security/core/services/location_service.dart';
import 'package:security/features/safe_spots/data/safe_spots_repository.dart';
import 'package:security/features/safe_spots/model/safe_spot.dart';
import 'package:security/features/safe_spots/model/safe_spot_category.dart';
import 'package:security/features/safe_spots/view_model/safe_spots_view_model.dart';

class _FakeLocationService implements LocationService {
  @override
  Future<Position> currentPosition() async => Position(
        latitude: 28.4744,
        longitude: 77.504,
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

class _FakeSafeSpotsRepository implements SafeSpotsRepository {
  _FakeSafeSpotsRepository(this.spots);

  List<SafeSpot> spots;
  int fetchCalls = 0;
  bool? lastForceRefresh;

  @override
  Future<List<SafeSpot>> fetchNearby({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    fetchCalls++;
    lastForceRefresh = forceRefresh;
    return spots;
  }
}

ProviderContainer _containerWith(_FakeSafeSpotsRepository repo) {
  final container = ProviderContainer(
    overrides: [
      locationServiceProvider.overrideWithValue(_FakeLocationService()),
      safeSpotsRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

const _shelter = SafeSpot(
  id: 'node/1',
  name: 'Shelter',
  latitude: 28.4753,
  longitude: 77.504,
  distanceKm: 2,
  category: SafeSpotCategory.hospital,
);

const _mall = SafeSpot(
  id: 'way/2',
  name: 'Ansal Plaza',
  latitude: 28.52,
  longitude: 77.504,
  distanceKm: 5,
  category: SafeSpotCategory.shoppingMall,
);

void main() {
  group('SafeSpotsViewModel', () {
    test('build exposes the spots from the repository', () async {
      final container = _containerWith(_FakeSafeSpotsRepository(const [_shelter]));

      final spots = await container.read(safeSpotsViewModelProvider.future);

      expect(spots.single.name, 'Shelter');
      expect(spots.single.category, SafeSpotCategory.hospital);
    });

    test('build looks the spots up at the current position', () async {
      final repo = _FakeSafeSpotsRepository(const [_shelter]);
      final container = _containerWith(repo);

      await container.read(safeSpotsViewModelProvider.future);

      expect(repo.fetchCalls, 1);
      expect(repo.lastForceRefresh, isFalse);
    });

    test('refresh re-fetches and updates the state', () async {
      final repo = _FakeSafeSpotsRepository(const []);
      final container = _containerWith(repo);
      await container.read(safeSpotsViewModelProvider.future);

      repo.spots = const [_mall];
      await container.read(safeSpotsViewModelProvider.notifier).refresh();

      expect(repo.fetchCalls, 2);
      expect(
        container.read(safeSpotsViewModelProvider).valueOrNull?.single.name,
        'Ansal Plaza',
      );
    });

    test('refresh bypasses the distance cache', () async {
      final repo = _FakeSafeSpotsRepository(const [_shelter]);
      final container = _containerWith(repo);
      await container.read(safeSpotsViewModelProvider.future);

      await container.read(safeSpotsViewModelProvider.notifier).refresh();

      expect(repo.lastForceRefresh, isTrue);
    });
  });
}
