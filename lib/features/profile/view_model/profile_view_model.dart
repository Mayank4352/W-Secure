import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../../auth/data/auth_repository.dart';
import '../data/profile_repository.dart';
import '../model/user_profile.dart';

part 'generated/profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<UserProfile> build() {
    return ref.watch(profileRepositoryProvider).fetch();
  }

  Future<void> save({
    required String name,
    required String emergencyContact,
  }) async {
    await ref
        .read(profileRepositoryProvider)
        .update(name: name, emergencyContact: emergencyContact);
    final current = state.valueOrNull ?? const UserProfile();
    state = AsyncData(
      current.copyWith(name: name, emergencyContact: emergencyContact),
    );
  }

  Future<void> pickProfilePicture() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) throw const AppException('No image selected.');

    final url = await ref
        .read(profileRepositoryProvider)
        .uploadProfilePicture(File(picked.path));
    final current = state.valueOrNull ?? const UserProfile();
    state = AsyncData(current.copyWith(profilePictureUrl: url));
  }

  Future<void> signOut() => ref.read(authRepositoryProvider).signOut();
}
