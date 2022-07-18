import 'package:beecheal/main.dart';
import 'package:beecheal/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

Future<void> signIn(
    WidgetTester tester, String username, String password) async {
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(Key("emailField")), username);
  await tester.enterText(find.byKey(Key("passwordField")), password);
  await tester.tap(find.byKey(Key("signIn")));
  await tester.pumpAndSettle();
}

Future<void> signOutFromHomepage(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip("Open navigation menu"));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key("signOutButton")));
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  String username =
      "testacc${DateFormat('ddMMyyhhmmss').format(DateTime.now())}@test.com";
  /*testWidgets('SignIn/SignOut Test', (WidgetTester tester) async {
    await Firebase.initializeApp();
    await tester.pumpWidget(MyApp());
    await signIn(tester, "test1@test.com", "test12345");
    expect(find.byKey(Key("homeBar")), findsOneWidget);
    await signOutFromHomepage(tester);
    expect(find.byKey(Key("signIn")), findsOneWidget);
    await tester.pumpAndSettle();
  });*/

  group("Features Test", () {
    /*testWidgets('Register', (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("signUp")));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("registerEmailField")), username);
      await tester.enterText(
          find.byKey(Key("registerPasswordField")), "test12345");
      await tester.enterText(
          find.byKey(Key("registerConfirmPasswordField")), "test12345");
      await tester.tap(find.byKey(Key("confirmButton")));
      await tester.pumpAndSettle();
      await signOutFromHomepage(tester);
    });*/
    testWidgets('Create Task from Homepage', (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await signIn(tester, "testacc180722065333@test.com", "test12345");
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("homeCreateTaskButton")));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("taskTitleField")), "A Task Title!");
      await tester.enterText(
          find.byKey(Key("taskDescriptionField")), "A Task Description!");
      await tester.pumpAndSettle();
      await tester.tap(find.text("Create"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      expect(find.text("A Task Title!"), findsWidgets);
    });
  });
}
