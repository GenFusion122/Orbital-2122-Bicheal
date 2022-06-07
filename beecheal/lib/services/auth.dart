import 'package:beecheal/models/userid.dart';
import 'package:beecheal/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future forgotPassword(email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
