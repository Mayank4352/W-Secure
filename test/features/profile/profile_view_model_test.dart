import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/profile/data/profile_repository.dart';
import 'package:security/features/profile/model/user_profile.dart';
import 'package:security/features/profile/view_model/profile_view_model.dart';

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this.profile);

  UserProfile profile;
  int updateCalls = 0;
  String? lastName;
  String? lastContact;

  @override
  Future<UserProfile> fetch() async => profile;

  @override
  Future<void> update({
    required String name,
    required String emergencyContact,
  }) async {
    updateCalls++;
    lastName = name;
    lastContact = emergencyContact;
  }

  @override
  Future<String> uploadProfilePicture(File image) async => 'https://img/new.jpg';
}

ProviderContainer _containerWith(_FakeProfileRepository repo) {
  final container = ProviderContainer(
    overrides: [profileRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('ProfileViewModel', () {
    test('build returns the profile fetched from the repository', () async {
      final repo = _FakeProfileRepository(const UserProfile(name: 'Asha'));
      final container = _containerWith(repo);

      final profile = await container.read(profileViewModelProvider.future);

      expect(profile.name, 'Asha');
    });

    test('save persists via the repository and updates state', () async {
      final repo = _FakeProfileRepository(const UserProfile(name: 'Asha'));
      final container = _containerWith(repo);
      await container.read(profileViewModelProvider.future);

      await container
          .read(profileViewModelProvider.notifier)
          .save(name: 'Bina', emergencyContact: '112');

      expect(repo.updateCalls, 1);
      expect(repo.lastName, 'Bina');
      expect(repo.lastContact, '112');

      final state = container.read(profileViewModelProvider).valueOrNull;
      expect(state?.name, 'Bina');
      expect(state?.emergencyContact, '112');
    });
  });
}
