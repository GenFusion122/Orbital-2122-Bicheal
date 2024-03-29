import 'package:beecheal/models/task.dart';
import 'package:beecheal/models/user.dart';
import 'package:beecheal/screens/calendar/calendar.dart';
import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/screens/journal/journal_entries.dart';
import 'package:beecheal/screens/statistics/statistics.dart';
import 'package:beecheal/screens/wrapper.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'models/userid.dart';
import 'models/entry.dart';
import 'services/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBIibnRKB9ozo0BSSMAIWYUtTFR-aB2Bes",
        authDomain: "beecheal-17e08.firebaseapp.com",
        projectId: "beecheal-17e08",
        storageBucket: "beecheal-17e08.appspot.com",
        messagingSenderId: "59725859836",
        appId: "1:59725859836:web:782ce210bcb673089cc079",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

String? initialroute;
Future<void> initializeEverything() async {
  tz.initializeTimeZones();
  initialroute = '/';
  if (!kIsWeb) {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await NotificationService.getNotificationInstance()
            .getNotificationAppLaunchDetails();
    initialroute =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false
            ? notificationAppLaunchDetails?.payload
            : '/';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeEverything();

    return ChangeNotifierProvider(
        create: (context) => AuthService(),
        child: StreamProvider<UserID?>.value(
          catchError: ((context, error) {}),
          initialData: null,
          value: AuthService().user,
          child: StreamProvider<User?>.value(
            catchError: ((context, error) {}),
            initialData: User('', true, true),
            value: DatabaseService().user,
            child: MaterialApp(
              title: 'BzB',
              initialRoute: initialroute,
              routes: {
                '/': (context) => Wrapper(),
                '/home': (context) => StreamProvider<List<Task>?>.value(
                    catchError: ((context, error) {}),
                    value: DatabaseService().tasks,
                    initialData: [],
                    child: Home()),
                '/statistics': (context) => Statistics(),
                '/calendar': (context) => CalendarView(),
                '/journalEntries': (context) =>
                    StreamProvider<List<Entry>>.value(
                        value: DatabaseService().entries,
                        initialData: [],
                        child: JournalEntries()),
              },
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                      backgroundColor: Color(0xFFFFAB00), centerTitle: true),
                  colorScheme: ColorScheme(
                      background: Color(0xFFFFE0B2),
                      primary: Color(0xFFFFAB00),
                      secondary: Color(0xFFFFDD4B),
                      tertiary: Color(0xFFFFC95C),
                      primaryContainer: Color(0xFFFFE98C),
                      secondaryContainer: Colors.transparent,
                      error: Colors.red,
                      surface: Colors.white,
                      onPrimary: Colors.black,
                      onSurface: Colors.black,
                      onBackground: Colors.black,
                      onSecondary: Colors.black,
                      onError: Colors.black,
                      brightness: Brightness.light),
                  dialogBackgroundColor: Color(0xFFFFC95C),
                  bottomAppBarColor: Color(0xFFFFAB00),
                  fontFamily: "Rubik",
                  textTheme: TextTheme(
                      headline1: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      button: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ),
          ),
        ));
  }
}
