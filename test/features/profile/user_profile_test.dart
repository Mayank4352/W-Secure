import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/profile/model/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('defaults every field to an empty string', () {
      const profile = UserProfile();
      expect(profile.name, '');
      expect(profile.email, '');
      expect(profile.emergencyContact, '');
      expect(profile.profilePictureUrl, '');
    });

    test('fromJson reads the expected keys', () {
      final profile = UserProfile.fromJson(const {
        'name': 'Asha',
        'email': 'asha@example.com',
        'emergencyContact': '112',
        'profilePictureUrl': 'https://img/x.jpg',
      });

      expect(profile.name, 'Asha');
      expect(profile.email, 'asha@example.com');
      expect(profile.emergencyContact, '112');
      expect(profile.profilePictureUrl, 'https://img/x.jpg');
    });

    test('toJson round-trips through fromJson', () {
      const original = UserProfile(
        name: 'Asha',
        email: 'asha@example.com',
        emergencyContact: '112',
        profilePictureUrl: 'https://img/x.jpg',
      );

      expect(UserProfile.fromJson(original.toJson()), original);
    });

    test('copyWith replaces only the given fields', () {
      const original = UserProfile(name: 'Asha', email: 'asha@example.com');

      final updated = original.copyWith(name: 'Bina');

      expect(updated.name, 'Bina');
      expect(updated.email, 'asha@example.com');
    });

    test('value equality holds for identical data', () {
      expect(const UserProfile(name: 'x'), const UserProfile(name: 'x'));
    });
  });
}
