import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/safe_spot.freezed.dart';
part 'generated/safe_spot.g.dart';

@freezed
class SafeSpot with _$SafeSpot {
  const SafeSpot._();

  const factory SafeSpot({
    required String name,
    required int distanceKm,
    required String contact,
    required String openingTime,
    required String closingTime,
  }) = _SafeSpot;

  factory SafeSpot.fromJson(Map<String, dynamic> json) =>
      _$SafeSpotFromJson(json);

  bool isOpenAt(int minutesOfDay) =>
      minutesOfDay >= _toMinutes(openingTime) &&
      minutesOfDay <= _toMinutes(closingTime);

  static int _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
