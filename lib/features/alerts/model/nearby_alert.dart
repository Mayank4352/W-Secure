import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/nearby_alert.freezed.dart';
part 'generated/nearby_alert.g.dart';

@freezed
class NearbyAlert with _$NearbyAlert {
  const factory NearbyAlert({
    required int distanceKm,
    required String time,
  }) = _NearbyAlert;

  factory NearbyAlert.fromJson(Map<String, dynamic> json) =>
      _$NearbyAlertFromJson(json);
}
