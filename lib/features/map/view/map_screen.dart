import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/error_retry_view.dart';
import '../../police_stations/view_model/police_stations_view_model.dart';
import '../../safe_spots/view/safe_spots_screen.dart';
import '../../safe_spots/view_model/safe_spots_view_model.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late Future<LatLng> _position;

  @override
  void initState() {
    super.initState();
    _position = _resolvePosition();
  }

  Future<LatLng> _resolvePosition() async {
    final position = await ref.read(locationServiceProvider).currentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      extendBody: true,
      body: FutureBuilder<LatLng>(
        future: _position,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorRetryView(
              error: snapshot.error!,
              onRetry: () => setState(() => _position = _resolvePosition()),
            );
          }
          final userPos = snapshot.data;
          if (userPos == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _Map(userPos: userPos);
        },
      ),
    );
  }
}

class _Map extends ConsumerWidget {
  const _Map({required this.userPos});

  final LatLng userPos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Shared with the list screens, so this costs no extra requests.
    final stations =
        ref.watch(policeStationsViewModelProvider).valueOrNull ?? const [];
    final spots = ref.watch(safeSpotsViewModelProvider).valueOrNull ?? const [];

    final markers = [
      for (final station in stations)
        _marker(
          context,
          point: LatLng(station.latitude, station.longitude),
          icon: Icons.local_police,
          color: Colors.indigo,
          label: '${station.name} · ${station.distanceLabel}',
        ),
      for (final spot in spots)
        _marker(
          context,
          point: LatLng(spot.latitude, spot.longitude),
          icon: spot.category.icon,
          color: spot.category.color,
          label: '${spot.name} · ${spot.distanceLabel}',
        ),
    ];

    return Stack(
      children: [
        _map(context, markers),
        if (!AppConfig.hasMapTilerApiKey) const _MissingTileKeyNotice(),
      ],
    );
  }

  Widget _map(BuildContext context, List<Marker> markers) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: userPos,
        initialZoom: 15,
        keepAlive: true,
      ),
      children: [
        if (AppConfig.hasMapTilerApiKey)
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/'
                '${AppConfig.mapTilerStyle}/256/{z}/{x}/{y}@2x.png?key={key}',
            additionalOptions: const {'key': AppConfig.mapTilerApiKey},
            userAgentPackageName: 'com.example.security',
            maxZoom: 20,
            maxNativeZoom: 20,
          ),
        CurrentLocationLayer(
          alignPositionOnUpdate: AlignOnUpdate.always,
          alignDirectionOnUpdate: AlignOnUpdate.always,
          style: const LocationMarkerStyle(
            marker: DefaultLocationMarker(
              child: Icon(Icons.navigation, color: Colors.white),
            ),
            markerSize: Size(30, 30),
            markerDirection: MarkerDirection.heading,
          ),
        ),
        // Required by the MapTiler and OpenStreetMap licences.
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('MapTiler'),
            TextSourceAttribution('OpenStreetMap contributors'),
          ],
        ),
        if (markers.isNotEmpty)
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              maxZoom: 15,
              markers: markers,
              builder: (context, clustered) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    clustered.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Marker _marker(
    BuildContext context, {
    required LatLng point,
    required IconData icon,
    required Color color,
    required String label,
  }) =>
      Marker(
        point: point,
        child: GestureDetector(
          onTap: () => showAppSnackBar(context, label),
          child: Icon(icon, color: color),
        ),
      );
}

class _MissingTileKeyNotice extends StatelessWidget {
  const _MissingTileKeyNotice();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Map background unavailable — build with '
            '--dart-define=MAPTILER_API_KEY=your_key. '
            'Markers and your location still work.',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
