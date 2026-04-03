import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const _items = <({IconData icon, String path, String label})>[
    (
      icon: Icons.local_police_outlined,
      path: AppRoutes.policeStations,
      label: 'Police Stations'
    ),
    (
      icon: Icons.health_and_safety_sharp,
      path: AppRoutes.safeSpots,
      label: 'Safe Spots'
    ),
    (icon: Icons.home_outlined, path: AppRoutes.home, label: 'Home'),
    (icon: Icons.map_outlined, path: AppRoutes.map, label: 'Map'),
    (icon: Icons.person_outline, path: AppRoutes.profile, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final location = GoRouterState.of(context).matchedLocation;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      decoration: const BoxDecoration(
        color: AppColors.primaryPink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final item in _items)
            _NavItem(
              icon: item.icon,
              label: item.label,
              selected: location == item.path,
              onTap: () => context.go(item.path),
              diameter: size.width * 0.06,
              padding: size.width * 0.03,
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.diameter,
    required this.padding,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double diameter;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: AppColors.cream,
            shape: BoxShape.circle,
            border:
                selected ? Border.all(color: Colors.black26, width: 2) : null,
          ),
          child: Icon(
            icon,
            size: diameter,
            color: selected ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    );
  }
}
