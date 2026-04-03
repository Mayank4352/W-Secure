import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/location_service.dart';
import '../data/alerts_repository.dart';

part 'generated/connect_nearby_view_model.g.dart';

/// Holds the location autocomplete suggestions for the connect-nearby form.
@riverpod
class ConnectNearbyViewModel extends _$ConnectNearbyViewModel {
  static final _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  List<String> build() => const [];

  Future<String> currentLocationLabel() async {
    final position = await ref.read(locationServiceProvider).currentPosition();
    return 'Lat: ${position.latitude}, Long: ${position.longitude}';
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      state = const [];
      return;
    }
    try {
      final locations = await locationFromAddress(query);
      state = await Future.wait(
        locations.map((loc) async {
          final placemarks =
              await placemarkFromCoordinates(loc.latitude, loc.longitude);
          return placemarks.first.name ?? 'Unknown location';
        }),
      );
    } catch (_) {
      state = const [];
    }
  }

  void clearSuggestions() => state = const [];

  Future<void> saveAlert({
    required String location,
    required String timeFrom,
    required String timeTo,
    required String message,
  }) async {
    final DateTime from;
    final DateTime to;
    try {
      from = _dateFormat.parse(timeFrom.replaceAll('/', '-'));
      to = _dateFormat.parse(timeTo.replaceAll('/', '-'));
    } catch (_) {
      throw const AppException('Invalid date format. Use DD-MM-YYYY.');
    }

    await ref.read(alertsRepositoryProvider).saveAlert(
          location: location,
          timeFrom: from.toIso8601String(),
          timeTo: to.toIso8601String(),
          message: message,
        );
  }
}
