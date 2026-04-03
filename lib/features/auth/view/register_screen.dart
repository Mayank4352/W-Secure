import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../view_model/register_view_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _emergencyContact = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _agreesToTerms = false;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () => showAppSnackBar(context, 'Terms and Conditions');
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => showAppSnackBar(context, 'Privacy Policy');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _emergencyContact.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    try {
      await ref.read(registerViewModelProvider.notifier).register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text.trim(),
            confirmPassword: _confirmPassword.text.trim(),
            emergencyContact: _emergencyContact.text.trim(),
            agreesToTerms: _agreesToTerms,
          );
    } on AppException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, 'Could not create the account.',
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(registerViewModelProvider);
    final size = MediaQuery.sizeOf(context);
    final scale = (size.width / 375).clamp(0.85, 1.2);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox.expand(),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: size.height * 0.15,
                    child: Image.asset('assets/logo.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.03),
                    child: Text(
                      'Sign up',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.deepPink,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  _field(_name, 'Name', Icons.person, scale),
                  SizedBox(height: size.height * 0.02),
                  _field(_email, 'Email Address', Icons.email, scale),
                  SizedBox(height: size.height * 0.02),
                  _field(_emergencyContact, 'Emergency Contact',
                      Icons.contact_phone, scale,
                      keyboardType: TextInputType.phone),
                  SizedBox(height: size.height * 0.02),
                  _passwordField(
                    controller: _password,
                    label: 'Create a password',
                    icon: Icons.lock,
                    scale: scale,
                    visible: _passwordVisible,
                    onToggle: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                  ),
                  SizedBox(height: size.height * 0.02),
                  _passwordField(
                    controller: _confirmPassword,
                    label: 'Confirm password',
                    icon: Icons.lock_outline,
                    scale: scale,
                    visible: _confirmVisible,
                    onToggle: () =>
                        setState(() => _confirmVisible = !_confirmVisible),
                  ),
                  SizedBox(height: size.height * 0.02),
                  _termsRow(scale),
                  SizedBox(height: size.height * 0.04),
                  SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.creamButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator()
                          : Text('Proceed',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.bold,
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _termsRow(double scale) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: _agreesToTerms,
            onChanged: (value) =>
                setState(() => _agreesToTerms = value ?? false),
            fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? AppColors.deepPink
                  : Colors.white54,
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 12 * scale),
              children: [
                const TextSpan(text: "I've read and agree with the "),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: _termsTap,
                ),
                const TextSpan(text: ' and the '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: _privacyTap,
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    double scale, {
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 16 * scale),
        decoration: _decoration(label, icon, scale),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required double scale,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: TextField(
        controller: controller,
        obscureText: !visible,
        style: TextStyle(color: Colors.white, fontSize: 16 * scale),
        decoration: _decoration(label, icon, scale).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white54,
              size: 20 * scale,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon, double scale) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white54, fontSize: 14 * scale),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.white54, size: 20 * scale),
    );
  }
}
