import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/firebase_providers.dart';
import '../../features/alerts/view/alerts_screen.dart';
import '../../features/alerts/view/connect_nearby_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/auth/view/set_pin_screen.dart';
import '../../features/home/view/emergency_lock_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/map/view/map_screen.dart';
import '../../features/police_stations/view/police_stations_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/safe_spots/view/safe_spots_screen.dart';
import '../splash_screen.dart';
import 'app_routes.dart';

part 'generated/app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refresh = ValueNotifier<AsyncValue<User?>>(const AsyncLoading());
  ref.onDispose(refresh.dispose);
  ref.listen(
    authStateProvider,
    (_, next) => refresh.value = next,
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = refresh.value;
      if (auth.isLoading) {
        return state.matchedLocation == AppRoutes.splash
            ? null
            : AppRoutes.splash;
      }

      final loggedIn = auth.valueOrNull != null;
      final inAuthFlow = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!loggedIn) return inAuthFlow ? null : AppRoutes.login;
      if (inAuthFlow || state.matchedLocation == AppRoutes.splash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.setPin,
        builder: (_, __) => const SetPinScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (_, __) => const MapScreen(),
      ),
      GoRoute(
        path: AppRoutes.policeStations,
        builder: (_, __) => const PoliceStationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.safeSpots,
        builder: (_, __) => const SafeSpotsScreen(),
      ),
      GoRoute(
        path: AppRoutes.alerts,
        builder: (_, __) => const AlertsScreen(),
      ),
      GoRoute(
        path: AppRoutes.connectNearby,
        builder: (_, __) => const ConnectNearbyScreen(),
      ),
      GoRoute(
        path: AppRoutes.emergencyLock,
        builder: (_, __) => const EmergencyLockScreen(),
      ),
    ],
  );
}
