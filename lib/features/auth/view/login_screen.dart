import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_background.dart';
import '../view_model/login_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  LoginViewModel get _viewModel => ref.read(loginViewModelProvider.notifier);

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on AppException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, 'Something went wrong.', isError: true);
      }
    }
  }

  Future<void> _loginWithEmail() async {
    if (_email.text.trim().isEmpty || _password.text.trim().isEmpty) {
      showAppSnackBar(context, 'Email and Password cannot be empty',
          isError: true);
      return;
    }
    await _guard(() =>
        _viewModel.signInWithEmail(_email.text.trim(), _password.text.trim()));
  }

  Future<void> _forgotPassword() async {
    if (_email.text.trim().isEmpty) {
      showAppSnackBar(context, 'Enter your email to reset the password',
          isError: true);
      return;
    }
    await _guard(() async {
      await _viewModel.sendPasswordReset(_email.text.trim());
      if (mounted) showAppSnackBar(context, 'Password reset email sent');
    });
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loginViewModelProvider);
    final size = MediaQuery.sizeOf(context);
    final scale = (size.width / 375).clamp(0.85, 1.2);

    return AppBackground(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: size.width * 0.07,
          left: size.width * 0.05,
          right: size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 32 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.cream,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            _field(_email, 'Email', size),
            SizedBox(height: size.height * 0.02),
            _field(_password, 'Password', size, obscure: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: loading ? null : _forgotPassword,
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.cream,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: loading
                      ? null
                      : () => _guard(_viewModel.signInWithGoogle),
                  icon: Image.asset('assets/google_logo.png',
                      height: 24, width: 24),
                  label: Text('Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17 * scale,
                        fontWeight: FontWeight.w600,
                      )),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: AppColors.cream,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: loading ? null : _loginWithEmail,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: AppColors.cream,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                        vertical: size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17 * scale,
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                const Text('New Here? ', style: TextStyle(color: Colors.white)),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.register),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    Size size, {
    bool obscure = false,
  }) {
    final radius = BorderRadius.circular(size.width * 0.04);
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: radius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: radius,
        ),
      ),
    );
  }
}
