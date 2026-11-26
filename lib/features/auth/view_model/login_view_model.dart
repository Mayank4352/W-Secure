import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'generated/login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  bool build() => false;

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signInWithGoogle() => _run(_repo.signInWithGoogle);

  Future<void> signInWithEmail(String email, String password) =>
      _run(() => _repo.signInWithEmail(email, password));

  Future<void> sendPasswordReset(String email) =>
      _repo.sendPasswordReset(email);

  Future<void> _run(Future<void> Function() action) async {
    state = true;
    try {
      await action();
    } finally {
      state = false;
    }
  }
}
