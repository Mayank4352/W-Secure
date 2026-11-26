import 'dart:math' as math;

const _earthRadiusMeters = 6371000.0;

double distanceMeters(
  double latitude1,
  double longitude1,
  double latitude2,
  double longitude2,
) {
  final phi1 = _radians(latitude1);
  final phi2 = _radians(latitude2);
  final deltaPhi = _radians(latitude2 - latitude1);
  final deltaLambda = _radians(longitude2 - longitude1);

  final a = math.pow(math.sin(deltaPhi / 2), 2) +
      math.cos(phi1) * math.cos(phi2) * math.pow(math.sin(deltaLambda / 2), 2);

  return 2 * _earthRadiusMeters * math.asin(math.sqrt(a));
}

double _radians(double degrees) => degrees * math.pi / 180.0;
