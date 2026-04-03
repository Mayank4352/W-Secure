import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../model/police_station.dart';
import '../view_model/police_stations_view_model.dart';

class PoliceStationsScreen extends ConsumerWidget {
  const PoliceStationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(policeStationsViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.cream,
        title: const Text(
          'Police Stations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: stations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Could not load police stations.'),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () =>
              ref.read(policeStationsViewModelProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _StationCard(station: items[index]),
          ),
        ),
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard({required this.station});

  final PoliceStation station;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      color: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primaryPink, width: 2),
      ),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: height * 0.02),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: AppColors.primaryPink),
        title: Text(
          station.name,
          style: const TextStyle(
            color: AppColors.primaryPink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text('${station.distanceKm}km, ${station.contact}'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
      ),
    );
  }
}
