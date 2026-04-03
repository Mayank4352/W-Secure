import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class SecurityApp extends ConsumerWidget {
  const SecurityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'W-Secure',
      theme: buildAppTheme(),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
