import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../data/auth_repository.dart';

part 'generated/register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  bool build() => false;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String emergencyContact,
    required bool agreesToTerms,
  }) async {
    if (!agreesToTerms) {
      throw const AppException(
          'You must agree to the Terms and Privacy Policy.');
    }
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        emergencyContact.isEmpty) {
      throw const AppException('All fields are required.');
    }
    if (password != confirmPassword) {
      throw const AppException('Passwords do not match.');
    }
    if (password.length < 6) {
      throw const AppException('Password must be at least 6 characters long.');
    }

    state = true;
    try {
      await ref.read(authRepositoryProvider).registerWithEmail(
            name: name,
            email: email,
            password: password,
            emergencyContact: emergencyContact,
          );
    } finally {
      state = false;
    }
  }
}
