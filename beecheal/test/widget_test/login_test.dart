import 'package:beecheal/screens/authenticate/authenticate.dart';
import 'package:beecheal/screens/authenticate/sign_in.dart';
import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/*import 'setup_mocks.dart';

class MockUserRepository extends Mock implements AuthService {
  final MockFirebaseAuth auth;
  MockUserRepository({required this.auth});
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

Future<void> main() async {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  MockUserRepository _repo;
  _repo = MockUserRepository(auth: _auth);

  Widget _makeTestable(Widget child) {
    return ChangeNotifierProvider<AuthService>.value(
        value: _repo, child: MaterialApp(home: child));
  }

  var emailField = find.byKey(Key("emailField"));
  var passwordField = find.byKey(Key("passwordField"));
  var signInButton = find.text("Sign In");
  group("login page test", () {
    testWidgets("finding email, password and login button", ((tester) async {
      await tester.pumpWidget(_makeTestable(Authenticate()));
      expect(emailField, findsOneWidget);
    }));
  });
}*/
