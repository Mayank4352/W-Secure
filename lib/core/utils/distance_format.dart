// Metres under a kilometre, otherwise kilometres to one decimal place.
String formatDistanceKm(double km) =>
    km < 1 ? '${(km * 1000).round()} m' : '${km.toStringAsFixed(1)} km';
