import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/alerts_repository.dart';
import '../model/nearby_alert.dart';

part 'generated/alerts_view_model.g.dart';

@riverpod
class AlertsViewModel extends _$AlertsViewModel {
  @override
  Future<List<NearbyAlert>> build() {
    return ref.watch(alertsRepositoryProvider).fetchNearby();
  }
}
