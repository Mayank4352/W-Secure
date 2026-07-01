import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/secure_pin_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../view_model/home_view_model.dart';

class EmergencyLockScreen extends ConsumerStatefulWidget {
  const EmergencyLockScreen({super.key});

  @override
  ConsumerState<EmergencyLockScreen> createState() =>
      _EmergencyLockScreenState();
}

class _EmergencyLockScreenState extends ConsumerState<EmergencyLockScreen> {
  static const _defaultPin = '1234';
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final storedPin = await ref.read(securePinStoreProvider).read();
    final expected =
        (storedPin?.isNotEmpty ?? false) ? storedPin! : _defaultPin;
    if (!mounted) return;

    if (_password.text == expected) {
      ref.read(homeViewModelProvider.notifier).stopEmergencyMode();
      context.pop();
    } else {
      showAppSnackBar(context, 'Incorrect Password', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.sizeOf(context).width / 375).clamp(0.85, 1.2);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Emergency Mode Activated',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cream,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Enter Password to Exit',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cream,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _unlock,
                    child: const Text(
                      'Unlock',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
