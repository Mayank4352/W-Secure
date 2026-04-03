import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/police_station.freezed.dart';
part 'generated/police_station.g.dart';

@freezed
class PoliceStation with _$PoliceStation {
  const factory PoliceStation({
    required String name,
    required int distanceKm,
    required String contact,
  }) = _PoliceStation;

  factory PoliceStation.fromJson(Map<String, dynamic> json) =>
      _$PoliceStationFromJson(json);
}
