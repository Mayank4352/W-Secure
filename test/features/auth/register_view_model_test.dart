import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/error/app_exception.dart';
import 'package:security/features/auth/data/auth_repository.dart';
import 'package:security/features/auth/view_model/register_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _FakeAuthRepository implements AuthRepository {
  int registerCalls = 0;

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String emergencyContact,
  }) async {
    registerCalls++;
  }

  @override
  User? get currentUser => null;

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithEmail(String email, String password) async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async {}
}

Future<void> _expectMessage(Future<void> Function() action, String message) {
  return expectLater(
    action,
    throwsA(
      isA<AppException>().having((e) => e.message, 'message', message),
    ),
  );
}

void main() {
  group('RegisterViewModel.register', () {
    late _FakeAuthRepository repo;
    late ProviderContainer container;
    late RegisterViewModel vm;

    setUp(() {
      repo = _FakeAuthRepository();
      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      vm = container.read(registerViewModelProvider.notifier);
    });

    test('requires agreeing to the terms', () async {
      await _expectMessage(
        () => vm.register(
          name: 'A',
          email: 'a@b.com',
          password: 'secret1',
          confirmPassword: 'secret1',
          emergencyContact: '112',
          agreesToTerms: false,
        ),
        'You must agree to the Terms and Privacy Policy.',
      );
      expect(repo.registerCalls, 0);
    });

    test('requires all fields', () async {
      await _expectMessage(
        () => vm.register(
          name: '',
          email: 'a@b.com',
          password: 'secret1',
          confirmPassword: 'secret1',
          emergencyContact: '112',
          agreesToTerms: true,
        ),
        'All fields are required.',
      );
    });

    test('requires matching passwords', () async {
      await _expectMessage(
        () => vm.register(
          name: 'A',
          email: 'a@b.com',
          password: 'secret1',
          confirmPassword: 'secret2',
          emergencyContact: '112',
          agreesToTerms: true,
        ),
        'Passwords do not match.',
      );
    });

    test('requires a password of at least 6 characters', () async {
      await _expectMessage(
        () => vm.register(
          name: 'A',
          email: 'a@b.com',
          password: 'abc',
          confirmPassword: 'abc',
          emergencyContact: '112',
          agreesToTerms: true,
        ),
        'Password must be at least 6 characters long.',
      );
    });

    test('delegates to the repository when input is valid', () async {
      await vm.register(
        name: 'A',
        email: 'a@b.com',
        password: 'secret1',
        confirmPassword: 'secret1',
        emergencyContact: '112',
        agreesToTerms: true,
      );

      expect(repo.registerCalls, 1);
      expect(container.read(registerViewModelProvider), isFalse);
    });
  });
}
