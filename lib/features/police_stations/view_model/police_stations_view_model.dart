import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/location_service.dart';
import '../../../core/utils/map_launcher.dart';
import '../data/police_stations_repository.dart';
import '../model/police_station.dart';

part 'generated/police_stations_view_model.g.dart';

@Riverpod(keepAlive: true)
class PoliceStationsViewModel extends _$PoliceStationsViewModel {
  @override
  Future<List<PoliceStation>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(forceRefresh: true));
  }

  Future<void> openDirections(PoliceStation station) => launchDirections(
        latitude: station.latitude,
        longitude: station.longitude,
      );

  Future<List<PoliceStation>> _load({bool forceRefresh = false}) async {
    final position = await ref.read(locationServiceProvider).currentPosition();
    return ref.read(policeStationsRepositoryProvider).fetchNearby(
          latitude: position.latitude,
          longitude: position.longitude,
          forceRefresh: forceRefresh,
        );
  }
}
