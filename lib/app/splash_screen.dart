import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.cream),
      ),
    );
  }
}
