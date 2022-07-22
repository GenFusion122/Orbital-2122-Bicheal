import 'package:beecheal/custom%20widgets/hexagonalclipper.dart';
import 'package:beecheal/main.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/calendar/calendar_template.dart';
import 'package:beecheal/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexagon/hexagon.dart';
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
  testWidgets('SignIn/SignOut Test', (WidgetTester tester) async {
    await Firebase.initializeApp();
    await tester.pumpWidget(MyApp());
    await signIn(tester, "test1@test.com", "test12345");
    expect(find.byKey(Key("homeBar")), findsOneWidget);
    await signOutFromHomepage(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(Key("signIn")), findsOneWidget);
    await tester.pumpAndSettle();
  });

  group("End-to-end Features test: ", () {
    testWidgets('Registration', (WidgetTester tester) async {
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
    });
    testWidgets('Create, Edit & Deletion, also Testing Filter Buttons ',
        (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await signIn(tester, username, "test12345");
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
      await tester.pumpAndSettle();
      await tester.tap(find.text("A Task Description!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Edit"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("taskTitleField")), "An Edited Task Title!");
      await tester.enterText(find.byKey(Key("taskDescriptionField")),
          "An Edited Task Description!");
      await tester.tap(find.byKey(Key("taskSelectDateButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.text("10"));
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("taskSelectTimeButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Update"));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Description!"), findsOneWidget);
      await tester.tap(find.text("Completed"));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Description!"), findsNothing);
      await tester.tap(find.text("Incomplete"));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Description!"), findsOneWidget);
      await tester.tap(find.text("An Edited Task Description!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Delete"));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Description!"), findsNothing);
      await signOutFromHomepage(tester);
    });

    testWidgets('Create, Edit and Deletion of Journal Entries',
        (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await signIn(tester, username, "test12345");
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("homeJournalNavButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("journalCreateEntryButton")));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("journalTitleField")), "Happy!");
      await tester.enterText(
          find.byKey(Key("journalDescriptionField")), "A Happy Description!");
      await tester.enterText(find.byKey(Key("journalBodyField")),
          "I am very Happy today! It is a wonderful looking day outside today!");
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text("Create"));
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.tap(find.text("Confirm"));
      await tester.pumpAndSettle();
      expect(find.text("Happy!"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Happy!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Edit"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("journalTitleField")), "Sad!");
      await tester.enterText(
          find.byKey(Key("journalDescriptionField")), "A Sad Description!");
      await tester.enterText(find.byKey(Key("journalBodyField")),
          "I am very Sad today! It is a terrible looking day outside today :(");
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(find.text("Update"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Confirm"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Sad!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Delete"));
      await tester.pump(Duration(seconds: 5));
      expect(find.text("I am very Sad today!"), findsNothing);
      await tester.tap(find.byType(BackButtonIcon));
      await tester.pumpAndSettle();
      await signOutFromHomepage(tester);
    });

    testWidgets(
        "Create, Edit, Delete Calendar events and Tasks via Calendar view",
        (WidgetTester tester) async {
      String dateKey =
          "CellContent-${DateFormat('yyyy-M-5').format(DateTime.now())}";
      String editDateKey =
          "CellContent-${DateFormat('yyyy-M-25').format(DateTime.now())}";
      //Calendar Events Test
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await signIn(tester, username, "test12345");
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("homeCalendarNavButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(dateKey)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("calendarCreateEventButton")));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("calendarTitleField")), "An Event Title!");
      await tester.enterText(
          find.byKey(Key("calendarDescriptionField")), "An Event Description!");
      await tester.tap(find.text("Create"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      expect(find.text("An Event Title!"), findsWidgets);
      await tester.pumpAndSettle();
      await tester.tap(find.text("An Event Title!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Edit"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("calendarTitleField")), "An Edited Event Title!");
      await tester.enterText(find.byKey(Key("calendarDescriptionField")),
          "An Edited Event Description!");
      await tester.tap(find.byKey(Key("calendarEditDateButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(Center, '25'));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Update"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(editDateKey)));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Event Title!"), findsWidgets);
      await tester.tap(find.text("An Edited Event Title!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Delete"));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.text("An Edited Event Title!"), findsNothing);
      await tester.pumpAndSettle();

      //Calendar Tasks
      await tester.tap(find.text("Tasks"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(dateKey)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("calendarCreateEventButton")));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("calendarTitleField")), "A Task Title!");
      await tester.enterText(
          find.byKey(Key("calendarDescriptionField")), "A Task Description!");
      await tester.tap(find.text("Create"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      expect(find.text("A Task Title!"), findsWidgets);
      await tester.pumpAndSettle();
      await tester.tap(find.text("A Task Title!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Edit"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("taskTitleField")), "An Edited Task Title!");
      await tester.enterText(find.byKey(Key("taskDescriptionField")),
          "An Edited Task Description!");
      await tester.tap(find.byKey(Key("taskSelectDateButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(Center, '25'));
      await tester.pumpAndSettle();
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Update"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(editDateKey)));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Title!"), findsWidgets);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Completed"));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Title!"), findsNothing);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Incomplete"));
      await tester.pumpAndSettle();
      expect(find.text("An Edited Task Title!"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.text("An Edited Task Title!"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Delete"));
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byType(BackButtonIcon));
      await signOutFromHomepage(tester);
    });
  });
}
