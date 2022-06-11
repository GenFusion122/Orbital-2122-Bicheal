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
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await NotificationService.getNotificationInstance()
          .getNotificationAppLaunchDetails();
  String? initialroute =
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false
          ? notificationAppLaunchDetails?.payload
          : '/';
  runApp(StreamProvider<UserID?>.value(
    initialData: null,
    value: AuthService().user,
    child: StreamProvider<User?>.value(
      initialData: User('', true, true),
      value: DatabaseService().user,
      child: MaterialApp(initialRoute: initialroute, routes: {
        '/': (context) => Wrapper(),
        '/home': (context) => StreamProvider<List<Task>>.value(
            value: DatabaseService().tasks, initialData: [], child: Home()),
        '/statistics': (context) => Statistics(),
        '/calendar': (context) => CalendarView(),
        '/journalEntries': (context) => StreamProvider<List<Entry>>.value(
            value: DatabaseService().entries,
            initialData: [],
            child: JournalEntries()),
      }),
    ),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<UserID?>.value(
//       initialData: null,
//       value: AuthService().user,
//       child: MaterialApp(initialRoute: initialroute, routes: {
//         '/': (context) => Wrapper(),
//         '/home': (context) => StreamProvider<List<Task>>.value(
//             value: DatabaseService().tasks, initialData: [], child: Home()),
//         '/statistics': (context) => Statistics(),
//         '/calendar': (context) => CalendarView(),
//         '/journalEntries': (context) => StreamProvider<List<Entry>>.value(
//             value: DatabaseService().entries,
//             initialData: [],
//             child: JournalEntries()),
//       }),
//     );
//   }
// }
