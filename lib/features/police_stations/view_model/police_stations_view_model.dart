import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/police_stations_repository.dart';
import '../model/police_station.dart';

part 'generated/police_stations_view_model.g.dart';

@riverpod
class PoliceStationsViewModel extends _$PoliceStationsViewModel {
  @override
  Future<List<PoliceStation>> build() {
    return ref.watch(policeStationsRepositoryProvider).fetchNearby();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      ref.read(policeStationsRepositoryProvider).fetchNearby,
    );
  }
}
