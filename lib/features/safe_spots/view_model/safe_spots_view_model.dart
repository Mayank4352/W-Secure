import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/safe_spots_repository.dart';
import '../model/safe_spot.dart';

part 'generated/safe_spots_view_model.g.dart';

@riverpod
class SafeSpotsViewModel extends _$SafeSpotsViewModel {
  @override
  Future<List<SafeSpot>> build() {
    return ref.watch(safeSpotsRepositoryProvider).fetchNearby();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      ref.read(safeSpotsRepositoryProvider).fetchNearby,
    );
  }
}
