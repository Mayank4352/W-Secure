import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/error_retry_view.dart';
import '../data/police_stations_repository.dart';
import '../model/police_station.dart';
import '../view_model/police_stations_view_model.dart';

class PoliceStationsScreen extends ConsumerWidget {
  const PoliceStationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(policeStationsViewModelProvider);
    final viewModel = ref.read(policeStationsViewModelProvider.notifier);
    final radiusKm =
        (PoliceStationsRepository.searchRadiusMeters / 1000).round();

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
        error: (error, _) =>
            ErrorRetryView(error: error, onRetry: viewModel.refresh),
        data: (items) => RefreshIndicator(
          onRefresh: viewModel.refresh,
          child: items.isEmpty
              ? EmptyResultsView(
                  message:
                      'No police stations found within $radiusKm km of you.',
                  onRetry: viewModel.refresh,
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => _StationCard(
                    station: items[index],
                    onTap: () => _openDirections(context, ref, items[index]),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _openDirections(
    BuildContext context,
    WidgetRef ref,
    PoliceStation station,
  ) async {
    try {
      await ref
          .read(policeStationsViewModelProvider.notifier)
          .openDirections(station);
    } on AppException catch (e) {
      if (context.mounted) showAppSnackBar(context, e.message, isError: true);
    }
  }
}

class _StationCard extends StatelessWidget {
  const _StationCard({required this.station, required this.onTap});

  final PoliceStation station;
  final VoidCallback onTap;

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
        onTap: onTap,
        leading: const Icon(Icons.local_police, color: AppColors.primaryPink),
        title: Text(
          station.name,
          style: const TextStyle(
            color: AppColors.primaryPink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          station.address == null
              ? station.distanceLabel
              : '${station.distanceLabel} · ${station.address}',
        ),
        trailing: const Icon(Icons.directions, color: Colors.black54),
      ),
    );
  }
}
