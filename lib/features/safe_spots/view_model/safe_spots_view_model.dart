import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/location_service.dart';
import '../../../core/utils/map_launcher.dart';
import '../data/safe_spots_repository.dart';
import '../model/safe_spot.dart';

part 'generated/safe_spots_view_model.g.dart';

@Riverpod(keepAlive: true)
class SafeSpotsViewModel extends _$SafeSpotsViewModel {
  @override
  Future<List<SafeSpot>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(forceRefresh: true));
  }

  Future<void> openDirections(SafeSpot spot) => launchDirections(
        latitude: spot.latitude,
        longitude: spot.longitude,
      );

  Future<List<SafeSpot>> _load({bool forceRefresh = false}) async {
    final position = await ref.read(locationServiceProvider).currentPosition();
    return ref.read(safeSpotsRepositoryProvider).fetchNearby(
          latitude: position.latitude,
          longitude: position.longitude,
          forceRefresh: forceRefresh,
        );
  }
}
