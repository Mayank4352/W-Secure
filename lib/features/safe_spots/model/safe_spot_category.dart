enum SafeSpotCategory {
  hospital('Hospital'),
  fireStation('Fire station'),
  policeStation('Police'),
  pharmacy('Pharmacy'),
  shoppingMall('Mall'),
  other('Safe spot');

  const SafeSpotCategory(this.label);

  final String label;

  static const searchTypes = [
    'hospital',
    'fire_station',
    'pharmacy',
    'shopping_mall',
  ];

  static SafeSpotCategory fromPlaceTypes(Iterable<String> types) {
    for (final category in values) {
      if (types.any(category._matches)) return category;
    }
    return SafeSpotCategory.other;
  }

  bool _matches(String type) => switch (this) {
        SafeSpotCategory.hospital => type == 'hospital' || type == 'general_hospital',
        SafeSpotCategory.fireStation => type == 'fire_station',
        SafeSpotCategory.policeStation => type == 'police',
        SafeSpotCategory.pharmacy => type == 'pharmacy' || type == 'drugstore',
        SafeSpotCategory.shoppingMall => type == 'shopping_mall',
        SafeSpotCategory.other => false,
      };
}
