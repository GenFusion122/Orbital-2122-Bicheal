import 'package:beecheal/models/userid.dart';
import 'package:beecheal/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  String? curruid() {
    final curruser = _auth.currentUser;
    final uid = curruser?.uid;
    return uid;
  }

  // creates user object based on User
  UserID? _userfromUser(User? user) {
    return user != null ? UserID(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserID?> get user {
    return _auth.authStateChanges().map(_userfromUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      return _userfromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userfromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create uid document
      await DatabaseService().updateUserID();
      await DatabaseService().updateUserDailyReminderPreference(true);
      await DatabaseService().updateUserWeeklyReminderPreference(true);

      return _userfromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with google
  Future googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      return null;
    }
    notifyListeners();
  }

  // sign out
  Future signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future forgotPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future changePassword(String newPassword) async {
    try {
      return await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      (e.toString());
      return null;
    }
  }
}
