import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/providers/firebase_providers.dart';
import '../model/user_profile.dart';

part 'generated/profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<UserProfile> fetch() async {
    final user = _auth.currentUser;
    if (user == null) return const UserProfile();

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    final data = snapshot.data() ?? const {};
    return UserProfile(
      name: data['name'] as String? ?? '',
      email: user.email ?? '',
      emergencyContact: data['emergencyContact'] as String? ?? '',
      profilePictureUrl: data['profilePicture'] as String? ?? '',
    );
  }

  Future<void> update({
    required String name,
    required String emergencyContact,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      'emergencyContact': emergencyContact,
    });
  }

  Future<String> uploadProfilePicture(File image) async {
    final user = _auth.currentUser;
    if (user == null) throw const AppException('You must be signed in.');

    final ref = _storage.ref('profilePictures/${user.uid}.jpg');
    await ref.putFile(image);
    final url = await ref.getDownloadURL();
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({'profilePicture': url});
    return url;
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
      auth: ref.watch(firebaseAuthProvider),
      firestore: ref.watch(firestoreProvider),
      storage: ref.watch(firebaseStorageProvider),
    );
