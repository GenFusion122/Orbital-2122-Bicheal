import 'dart:ui';

import 'package:beecheal/main.dart';
import 'package:beecheal/screens/authenticate/sign_in.dart';
import 'package:beecheal/screens/wrapper.dart';
import 'package:beecheal/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver.dart';
import 'package:beecheal/main.dart' as app;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('SignIn test', (WidgetTester tester) async {
    await Firebase.initializeApp();
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("signIn")));
  });
}
