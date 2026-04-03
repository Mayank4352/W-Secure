import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/providers/firebase_providers.dart';

part 'generated/auth_repository.g.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // cancelled by user
    final googleAuth = await googleUser.authentication;
    await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AppException(_message(e.code));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AppException(_message(e.code));
    }
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String emergencyContact,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'name': name,
        'email': email,
        'emergencyContact': emergencyContact,
        'phone': '',
        'profilePicture': '',
      });
    } on FirebaseAuthException catch (e) {
      throw AppException(_message(e.code));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  String _message(String code) => switch (code) {
        'user-not-found' => 'No user found with this email.',
        'wrong-password' => 'Wrong password provided.',
        'invalid-email' => 'The email address is badly formatted.',
        'user-disabled' => 'This user account has been disabled.',
        'email-already-in-use' => 'An account already exists for this email.',
        'weak-password' => 'Password is too weak.',
        _ => 'Something went wrong. Please try again.',
      };
}

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
      auth: ref.watch(firebaseAuthProvider),
      googleSignIn: ref.watch(googleSignInProvider),
      firestore: ref.watch(firestoreProvider),
    );
