import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../model/nearby_alert.dart';
import '../view_model/alerts_view_model.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsViewModelProvider);
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.creamSurface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nearby Disturbances'),
        backgroundColor: AppColors.creamSurface,
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.connectNearby),
        backgroundColor: AppColors.primaryPink,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
      body: alerts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load alerts.')),
        data: (items) => Padding(
          padding: EdgeInsets.only(top: height * 0.1, left: 8, right: 8),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => _AlertCard(alert: items[index]),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final NearbyAlert alert;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      color: AppColors.creamSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primaryPink),
      ),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: height * 0.02),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined,
            color: AppColors.primaryPink),
        title: const Text(
          'ALERT!!!',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${alert.distanceKm}km, ${alert.time}'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
      ),
    );
  }
}
