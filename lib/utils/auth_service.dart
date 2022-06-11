import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String get userId => _firebaseAuth.currentUser!.uid;

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
      return 'Sign in successful';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return 'Something went wrong';
    }
  }

  Future<String> signOut() async {
    try {
      _firebaseAuth.signOut();
      return 'Signed out';
    } catch (e) {
      return 'Something went wrong';
    }
  }
}
