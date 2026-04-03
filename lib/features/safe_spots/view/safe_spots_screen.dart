import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../model/safe_spot.dart';
import '../view_model/safe_spots_view_model.dart';

class SafeSpotsScreen extends ConsumerWidget {
  const SafeSpotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(safeSpotsViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.creamSurface,
      appBar: AppBar(
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.15,
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.cream,
        title: const Text(
          'Safe Spots',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: spots.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Could not load safe spots.')),
        data: (items) => RefreshIndicator(
          onRefresh: () =>
              ref.read(safeSpotsViewModelProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => _SafeSpotCard(spot: items[index]),
          ),
        ),
      ),
    );
  }
}

class _SafeSpotCard extends StatelessWidget {
  const _SafeSpotCard({required this.spot});

  final SafeSpot spot;

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final isOpen = spot.isOpenAt(now.hour * 60 + now.minute);
    final statusColor = isOpen ? Colors.green : Colors.red;
    final height = MediaQuery.sizeOf(context).height;

    return Card(
      color: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor, width: 2),
      ),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: height * 0.02),
      child: ListTile(
        leading: Icon(Icons.location_on_outlined, color: statusColor),
        title: Text(
          spot.name,
          style: const TextStyle(
            color: AppColors.primaryPink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text('${spot.distanceKm}km, ${spot.contact}'),
        trailing: Text(
          isOpen ? 'Open' : 'Closed',
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
