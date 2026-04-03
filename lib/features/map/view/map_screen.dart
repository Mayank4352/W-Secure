import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/widgets/bottom_nav_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _styleUrl =
      'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png';
  static const _apiKey = 'a1e9793d-bed4-4986-949c-24f3abf9e654';

  LatLng? _userPos;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determinePosition().then((value) {
        if (mounted) {
          setState(() => _userPos = LatLng(value.latitude, value.longitude));
        }
      });
    });
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (_userPos == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      extendBody: true,
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _userPos!,
          initialZoom: 15,
          keepAlive: true,
        ),
        children: [
          TileLayer(
            urlTemplate: '$_styleUrl?api_key={api_key}',
            additionalOptions: const {'api_key': _apiKey},
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
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              maxZoom: 15,
              markers: const [
                Marker(
                  point: LatLng(28.453511131201953, 77.52568658088984),
                  child: Icon(Icons.location_on, color: Colors.green),
                ),
                Marker(
                  point: LatLng(28.451916602494208, 77.50955442506789),
                  child: Icon(Icons.location_on, color: Colors.green),
                ),
              ],
              builder: (context, markers) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
