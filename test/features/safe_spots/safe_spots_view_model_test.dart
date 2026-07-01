import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/safe_spots/data/safe_spots_repository.dart';
import 'package:security/features/safe_spots/model/safe_spot.dart';
import 'package:security/features/safe_spots/view_model/safe_spots_view_model.dart';

class _FakeSafeSpotsRepository implements SafeSpotsRepository {
  _FakeSafeSpotsRepository(this.spots);

  List<SafeSpot> spots;
  int fetchCalls = 0;

  @override
  Future<List<SafeSpot>> fetchNearby() async {
    fetchCalls++;
    return spots;
  }
}

const _shelter = SafeSpot(
  name: 'Shelter',
  distanceKm: 2,
  contact: '100',
  openingTime: '09:00',
  closingTime: '17:00',
);

void main() {
  group('SafeSpotsViewModel', () {
    test('build exposes the spots from the repository', () async {
      final repo = _FakeSafeSpotsRepository(const [_shelter]);
      final container = ProviderContainer(
        overrides: [safeSpotsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final spots = await container.read(safeSpotsViewModelProvider.future);

      expect(spots.single.name, 'Shelter');
    });

    test('refresh re-fetches and updates the state', () async {
      final repo = _FakeSafeSpotsRepository(const []);
      final container = ProviderContainer(
        overrides: [safeSpotsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      await container.read(safeSpotsViewModelProvider.future);

      repo.spots = const [_shelter];
      await container.read(safeSpotsViewModelProvider.notifier).refresh();

      expect(repo.fetchCalls, 2);
      expect(
        container.read(safeSpotsViewModelProvider).valueOrNull?.single.name,
        'Shelter',
      );
    });
  });
}
