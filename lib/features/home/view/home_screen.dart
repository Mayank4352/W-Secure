import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../view_model/home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<bool> _guard(
      BuildContext context, Future<void> Function() action) async {
    try {
      await action();
      return true;
    } on AppException catch (e) {
      if (context.mounted) showAppSnackBar(context, e.message, isError: true);
    } catch (_) {
      if (context.mounted) {
        showAppSnackBar(context, 'Something went wrong.', isError: true);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final isRecording = ref.watch(homeViewModelProvider);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      backgroundColor: AppColors.cream,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'SOS',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () async {
              final started =
                  await _guard(context, viewModel.activateEmergencyMode);
              if (started && context.mounted) {
                context.push(AppRoutes.emergencyLock);
              }
            },
            child: Container(
              height: size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          _SosButton(
            label: 'Call Helpline',
            onTap: () => _guard(context, viewModel.makeEmergencyCall),
            size: size,
          ),
          _SosButton(
            label: 'Share Live Location',
            onTap: () => _guard(context, viewModel.shareLocation),
            size: size,
          ),
          _SosButton(
            label: isRecording ? 'Stop Recording' : 'Take A Video',
            onTap: () => _guard(context, viewModel.toggleRecording),
            size: size,
          ),
          _SosButton(
            label: 'Alerts',
            onTap: () async => context.push(AppRoutes.alerts),
            size: size,
          ),
        ],
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({
    required this.label,
    required this.onTap,
    required this.size,
  });

  final String label;
  final Future<void> Function() onTap;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.07,
      decoration: BoxDecoration(
        color: AppColors.primaryPink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
