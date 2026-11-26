import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/auth/data/auth_repository.dart';
import 'package:security/features/auth/view_model/login_view_model.dart';

class _FakeAuthRepository implements AuthRepository {
  int emailSignIns = 0;
  int resets = 0;
  String? lastResetEmail;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    emailSignIns++;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    resets++;
    lastResetEmail = email;
  }

  @override
  User? get currentUser => null;

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String emergencyContact,
  }) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  group('LoginViewModel', () {
    late _FakeAuthRepository repo;
    late ProviderContainer container;
    late LoginViewModel vm;

    setUp(() {
      repo = _FakeAuthRepository();
      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      vm = container.read(loginViewModelProvider.notifier);
    });

    test('starts idle', () {
      expect(container.read(loginViewModelProvider), isFalse);
    });

    test('signInWithEmail delegates and resets the busy flag', () async {
      await vm.signInWithEmail('a@b.com', 'secret1');

      expect(repo.emailSignIns, 1);
      expect(container.read(loginViewModelProvider), isFalse);
    });

    test('sendPasswordReset forwards the email', () async {
      await vm.sendPasswordReset('a@b.com');

      expect(repo.resets, 1);
      expect(repo.lastResetEmail, 'a@b.com');
    });
  });
}
