import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/models/task.dart';
import 'package:beecheal/models/user.dart';
import 'package:beecheal/screens/home/initialize_notifications.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:beecheal/screens/todo_list/todo_task_tile.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../custom widgets/custombuttons.dart';
import 'package:beecheal/services/notifications.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  Timer? _everyMinute;
  String toDoListState = 'Default';
  // Notifications
  void initState() {
    super.initState();
    NotificationService.init(initScheduled: true);
    // On clicked
    NotificationService.onNotifications.stream.listen(
        (String? payload) => Navigator.pushNamed(context, payload.toString()));
  }

  _initializeNotificaitonValues() async {
    if (await NotificationService.getPendingNotifications() <= 0) {
      InitializeNotifications.initializeOccasionNotifications();
      InitializeNotifications.initializeToDoNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    // refreshes listview
    _everyMinute = Timer.periodic(Duration(minutes: 1), (Timer t) {
      // print('Rebuilt at ${DateTime.now()}');
      if (mounted) {
        setState(() {});
      }
    });
    _initializeNotificaitonValues(); //initialize notification objects
    bool dailyJournalEntry = Provider.of<User>(context).getDailyJournalEntry();
    bool weeklyReminder = Provider.of<User>(context).getWeeklyReminder();
    // Daily journal entry notification
    if (dailyJournalEntry) {
      NotificationService.showDailyScheduledNotification(
          id: 0,
          title: 'Daily journal entry',
          body: 'show journal entries',
          payload: '/journalEntries',
          time: Time(20),
          scheduledDate: DateTime.now());
    } else {
      NotificationService.getNotificationInstance().cancel(0);
    }

    // Weekly notification
    if (weeklyReminder) {
      NotificationService.showWeeklyScheduledNotification(
          id: 1,
          title: 'Weekly reminder',
          body: 'It\'s a new week!',
          payload: '/home',
          time: Time(8),
          days: [DateTime.monday],
          scheduledDate: DateTime.now());
    } else {
      NotificationService.getNotificationInstance().cancel(1);
    }

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 243, 224),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.brown[500]),
            title: Text(
              'Home!',
              style: TextStyle(color: Colors.brown[500]),
            ),
            centerTitle: true,
            backgroundColor: Colors.orange[400],
            elevation: 0.0,
          ),
          endDrawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.45,
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.070,
                    color: Colors.orange[400],
                    child: TextButton.icon(
                        icon: Icon(Icons.person),
                        style: TextButton.styleFrom(primary: Colors.brown[500]),
                        label: Text('Sign Out'),
                        onPressed: () async {
                          // clear all notifications
                          _everyMinute?.cancel();
                          await NotificationService.getNotificationInstance()
                              .cancelAll();
                          await _auth.signOut();
                          final provider =
                              Provider.of<AuthService>(context, listen: false);
                          provider.signOut();
                          setState(() {});
                        }),
                  ),
                  ListTile(
                    minLeadingWidth: 0.0,
                    tileColor: Colors.white,
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                  ),
                  ListTile(
                    minLeadingWidth: 0.0,
                    tileColor: Colors.white,
                    leading: Icon(Icons.pie_chart),
                    title: Text('Achievements'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('Achievements'),
                            );
                          });
                    },
                  ),
                  ListTile(
                    minLeadingWidth: 0.0,
                    tileColor: Colors.white,
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    minLeadingWidth: 0.0,
                    tileColor: Colors.white,
                    leading: Icon(Icons.password_rounded),
                    title: Text('Change Password'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String oldPassword = '';
                            String newPassword = '';
                            String confirmNewPassword = '';
                            final _formkey = GlobalKey<FormState>();
                            return AlertDialog(
                                contentPadding:
                                    EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                                backgroundColor: Colors.orange[100],
                                content: Form(
                                  key: _formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText: 'New Password'),
                                          validator: (val) => val!.length < 8
                                              ? 'Enter a password at least 8 characters long'
                                              : null,
                                          obscureText: true,
                                          onChanged: (val) {
                                            setState(() => newPassword = val);
                                          }),
                                      TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText:
                                                      'Confirm New Password'),
                                          validator: (val) => val != newPassword
                                              ? 'Passwords don\'t match'
                                              : null,
                                          obscureText: true,
                                          onChanged: (val) {
                                            setState(
                                                () => confirmNewPassword = val);
                                          }),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.amber[400])),
                                        onPressed: () async {
                                          // Validation check
                                          if (_formkey.currentState!
                                              .validate()) {
                                            dynamic result = await AuthService()
                                                .changePassword(newPassword);
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                  return AlertDialog(
                                                      title: Text(
                                                          'Password changed'));
                                                });
                                            if (result == null) {}
                                          }
                                        },
                                        child: Text('Change password',
                                            style: TextStyle(
                                                color: Colors.brown[500])),
                                      ),
                                    ],
                                  ),
                                ));
                          });
                    },
                  ),
                  MergeSemantics(
                    child: ListTile(
                        leading: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.4 * 0.5,
                            child: Text(
                              'Daily Journal Reminder',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.4 *
                                    0.08,
                              ),
                            )),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.amber[400],
                            value: dailyJournalEntry,
                            onChanged: (bool value) {
                              setState(() {
                                DatabaseService()
                                    .updateUserDailyReminderPreference(value);
                              });
                            },
                          ),
                        )),
                  ),
                  MergeSemantics(
                    child: ListTile(
                        leading: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.4 * 0.5,
                            child: Text(
                              'Weekly Reminder',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.4 *
                                    0.08,
                              ),
                            )),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Colors.amber[400],
                            value: weeklyReminder,
                            onChanged: (bool value) {
                              setState(() {
                                DatabaseService()
                                    .updateUserWeeklyReminderPreference(value);
                              });
                            },
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Stack(children: [
                  Container(
                      color: Color.fromARGB(255, 255, 243, 224),
                      margin: EdgeInsets.all(2.0),
                      child: StreamBuilder(
                        stream: DatabaseService().tasks,
                        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                          var completed = Provider.of<List<Task>>(context)
                              .where((task) =>
                                  task.getCompletedOn() !=
                                  Task.incompletePlaceholder);
                          var notCompleted = Provider.of<List<Task>>(context)
                              .where((task) =>
                                  task.getCompletedOn() ==
                                  Task.incompletePlaceholder);
                          if (toDoListState == 'Default') {
                            return ListView.builder(
                                itemCount:
                                    Provider.of<List<Task>>(context).length,
                                itemBuilder: (context, index) {
                                  return TaskTile(
                                      Provider.of<List<Task>>(context)[index]);
                                });
                          } else if (toDoListState == 'Not Completed') {
                            return ListView.builder(
                                itemCount: notCompleted.length,
                                itemBuilder: (context, index) {
                                  return TaskTile(notCompleted.toList()[index]);
                                });
                          } else if (toDoListState == 'Completed') {
                            return ListView.builder(
                                itemCount: completed.length,
                                itemBuilder: (context, index) {
                                  return TaskTile(completed.toList()[index]);
                                });
                          } else {
                            return SpinKitFoldingCube(
                                color: Colors.white, size: 50.0);
                          }
                        },
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: FloatingActionButton(
                            child: Icon(Icons.add),
                            backgroundColor: Colors.amber[400],
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TaskEditScreen(
                                        task: Task(
                                          "",
                                          "",
                                          DateTime.now(),
                                          "",
                                          Task.incompletePlaceholder,
                                        ),
                                        textPrompt: 'Create');
                                  });
                            }),
                      ),
                    ),
                  )
                ]),
              ),
              Expanded(
                flex: 1,
                child: Row(children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 202, 40)),
                          // side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          //     color: Color.fromARGB(255, 121, 85, 72),
                          //     width: 3.0))
                        ),
                        child: Text('Default'),
                        onPressed: () {
                          setState(() {
                            toDoListState = 'Default';
                          });
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 255, 202, 40))),
                        child: Text('Not Completed'),
                        onPressed: () {
                          setState(() {
                            toDoListState = 'Not Completed';
                          });
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 255, 202, 40))),
                        child: Text('Completed'),
                        onPressed: () {
                          setState(() {
                            toDoListState = 'Completed';
                          });
                        }),
                  ),
                ]),
              ),
              Expanded(
                  flex: 8,
                  child: Center(
                    child: Image.asset(
                      'assets/BzB.png',
                      height: 250,
                      width: 250,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: OrangeNavButton(
                            "/statistics", "statistics", context)),
                    Expanded(
                        child:
                            OrangeNavButton("/calendar", "calendar", context)),
                    Expanded(
                        child: OrangeNavButton(
                            "/journalEntries", "journal", context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
