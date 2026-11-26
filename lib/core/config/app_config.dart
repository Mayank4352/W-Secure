abstract final class AppConfig {
  static const googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static const placesBaseUrl = String.fromEnvironment(
    'PLACES_BASE_URL',
    defaultValue: 'https://places.googleapis.com',
  );

  static const _overpassBaseUrls = String.fromEnvironment(
    'OVERPASS_BASE_URLS',
    defaultValue: 'https://overpass-api.de,https://overpass.kumi.systems',
  );

  static const mapTilerApiKey = String.fromEnvironment('MAPTILER_API_KEY');

  // Any style slug MapTiler serves, e.g. streets-v4, basic-v2, dataviz-light.
  static const mapTilerStyle = String.fromEnvironment(
    'MAPTILER_STYLE',
    defaultValue: 'streets-v4',
  );

  static bool get hasMapTilerApiKey => mapTilerApiKey.isNotEmpty;

  static List<String> get overpassBaseUrls => [
        for (final url in _overpassBaseUrls.split(','))
          if (url.trim().isNotEmpty) url.trim(),
      ];

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;
}
