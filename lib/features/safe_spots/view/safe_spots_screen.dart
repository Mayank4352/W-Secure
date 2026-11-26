import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/error_retry_view.dart';
import '../data/safe_spots_repository.dart';
import '../model/safe_spot.dart';
import '../model/safe_spot_category.dart';
import '../view_model/safe_spots_view_model.dart';

extension SafeSpotCategoryStyle on SafeSpotCategory {
  IconData get icon => switch (this) {
        SafeSpotCategory.hospital => Icons.local_hospital,
        SafeSpotCategory.fireStation => Icons.local_fire_department,
        SafeSpotCategory.policeStation => Icons.local_police,
        SafeSpotCategory.pharmacy => Icons.local_pharmacy,
        SafeSpotCategory.shoppingMall => Icons.storefront,
        SafeSpotCategory.other => Icons.location_on_outlined,
      };

  Color get color => switch (this) {
        SafeSpotCategory.hospital => Colors.red.shade600,
        SafeSpotCategory.fireStation => Colors.deepOrange,
        SafeSpotCategory.policeStation => Colors.indigo,
        SafeSpotCategory.pharmacy => Colors.teal,
        SafeSpotCategory.shoppingMall => Colors.purple,
        SafeSpotCategory.other => Colors.blueGrey,
      };
}

class SafeSpotsScreen extends ConsumerWidget {
  const SafeSpotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(safeSpotsViewModelProvider);
    final viewModel = ref.read(safeSpotsViewModelProvider.notifier);
    final radiusKm = (SafeSpotsRepository.searchRadiusMeters / 1000).round();

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
        error: (error, _) =>
            ErrorRetryView(error: error, onRetry: viewModel.refresh),
        data: (items) => RefreshIndicator(
          onRefresh: viewModel.refresh,
          child: items.isEmpty
              ? EmptyResultsView(
                  message: 'No safe spots found within $radiusKm km of you.',
                  onRetry: viewModel.refresh,
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => _SafeSpotCard(
                    spot: items[index],
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
    SafeSpot spot,
  ) async {
    try {
      await ref.read(safeSpotsViewModelProvider.notifier).openDirections(spot);
    } on AppException catch (e) {
      if (context.mounted) showAppSnackBar(context, e.message, isError: true);
    }
  }
}

class _SafeSpotCard extends StatelessWidget {
  const _SafeSpotCard({required this.spot, required this.onTap});

  final SafeSpot spot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final accent = spot.category.color;

    return Card(
      color: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accent, width: 2),
      ),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: height * 0.02),
      child: ListTile(
        onTap: onTap,
        leading: Icon(spot.category.icon, color: accent),
        title: Text(
          spot.name,
          style: const TextStyle(
            color: AppColors.primaryPink,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          spot.address == null
              ? spot.distanceLabel
              : '${spot.distanceLabel} · ${spot.address}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              spot.category.label,
              style: TextStyle(color: accent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.directions, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
