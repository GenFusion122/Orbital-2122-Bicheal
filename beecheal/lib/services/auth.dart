import 'package:beecheal/models/userid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  // sign in email & password

  // register with email & password

  // sign out
}
