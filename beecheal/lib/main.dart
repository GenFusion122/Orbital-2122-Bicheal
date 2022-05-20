import 'package:beecheal/screens/authenticate/sign_in.dart';
import 'package:beecheal/screens/home/calendar.dart';
import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/screens/home/journalEntries.dart';
import 'package:beecheal/screens/home/statistics.dart';
import 'package:beecheal/screens/wrapper.dart';
import 'package:beecheal/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/userid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserID?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(initialRoute: '/', routes: {
        '/': (context) => Wrapper(),
        '/home': (context) => Home(),
        '/statistics': (context) => Statistics(),
        '/calendar': (context) => calendar(),
        '/journalEntries': (context) => journalEntries(),
      }),
    );
  }
}
