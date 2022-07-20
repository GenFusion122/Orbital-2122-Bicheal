import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/custom%20widgets/hexagonalclipper.dart';
import 'package:beecheal/models/task.dart';
import 'package:beecheal/models/user.dart';
import 'package:beecheal/screens/home/initialize_notifications.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:beecheal/screens/todo_list/todo_task_tile.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import '../../custom widgets/custombuttons.dart';
import 'package:beecheal/services/notifications.dart';
import 'dart:async';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  Timer? _everyMinute;
  // toDoListState
  List<bool> isSelected = [true, false, false];
  // Notifications
  void initState() {
    super.initState();
    if (!kIsWeb) {
      // checks if on mobile
      NotificationService.init(initScheduled: true);
      // On clicked
      NotificationService.onNotifications.stream.listen((String? payload) =>
          Navigator.pushNamed(context, payload.toString()));
    }
  }

  _initializeNotificaitonValues() async {
    if (await NotificationService.getPendingNotifications() <= 0) {
      InitializeNotifications.initializeOccasionNotifications();
      InitializeNotifications.initializeToDoNotifications();
    }
  }

  int numberOfTasksToday = 0;
  int numberOfEventsToday = 0;
  String upcomingTask = "";
  String upcomingEvent = "";
  bool dailyJournalEntry = false;
  bool weeklyReminder = false;

  Future<void> getNumberOfTasksToday() async {
    var itemsList = [];
    DateTime start = DateUtils.dateOnly(DateTime.now());
    DateTime end = start.add(Duration(hours: 23, minutes: 59, seconds: 59));
    final query = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.curruid())
        .collection("tasks")
        .where('dateTime',
            isGreaterThanOrEqualTo: start, isLessThanOrEqualTo: end)
        .where('completedOn', isEqualTo: Task.incompletePlaceholder)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        itemsList.add(element);
      });
    });
    numberOfTasksToday = itemsList.length;
  }

  Future<void> getNumberOfEventsToday() async {
    var itemsList = [];
    DateTime start = DateUtils.dateOnly(DateTime.now());
    DateTime end = start.add(Duration(hours: 23, minutes: 59, seconds: 59));
    final query = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.curruid())
        .collection("occasions")
        .where('dateTime',
            isGreaterThanOrEqualTo: start, isLessThanOrEqualTo: end)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        itemsList.add(element);
      });
    });
    numberOfEventsToday = itemsList.length;
  }

  Future<void> getClosestTask() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.curruid())
          .collection("tasks")
          .where("completedOn", isEqualTo: Task.incompletePlaceholder)
          .orderBy('dateTime')
          .get()
          .then((snapshot) {
        upcomingTask = snapshot.docs[0]['title'];
      });
    } on RangeError {
      upcomingTask = "No upcoming Tasks";
    }
  }

  Future<void> getClosestEvent() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.curruid())
          .collection("occasions")
          .orderBy('dateTime')
          .limit(1)
          .get()
          .then((snapshot) {
        upcomingEvent = snapshot.docs[0]['title'];
      });
    } on RangeError {
      upcomingEvent = "No upcoming Events";
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      getNumberOfTasksToday();
      getNumberOfEventsToday();
      getClosestEvent();
      getClosestTask();
    } on FirebaseException {}
    // refreshes listview
    _everyMinute = Timer.periodic(Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });

    try {
      dailyJournalEntry = Provider.of<User>(context).getDailyJournalEntry();
      weeklyReminder = Provider.of<User>(context).getWeeklyReminder();
    } on ProviderNullException {}

    if (!kIsWeb) {
      //checks if on mobile
      _initializeNotificaitonValues(); //initialize notification objects
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
    }
    final _formkey = GlobalKey<FormState>();
    double scaleMin = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    double scaleMax = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          key: Key("homeBar"),
          leading: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Image.asset(
              'assets/BzB.png',
              height: 40,
              width: 40,
            ),
          ),
          iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary, size: 40),
          title: Icon(Icons.home_outlined,
              color: Theme.of(context).colorScheme.onPrimary, size: 45),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0.0,
        ),
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.45,
          backgroundColor: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.070,
                  color: Theme.of(context).colorScheme.primary,
                  child: TextButton.icon(
                      key: Key("signOutButton"),
                      icon: Icon(Icons.person_outline,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 45),
                      label: Text(
                        'Sign Out',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
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
                  tileColor: Theme.of(context).colorScheme.surface,
                  leading: Icon(Icons.password_rounded,
                      color: Theme.of(context).colorScheme.onPrimary, size: 30),
                  title: Text('Change Password',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String oldPassword = '';
                          String newPassword = '';
                          String confirmNewPassword = '';
                          return ClipPath(
                              clipper: HexagonalClipper(),
                              child: Material(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  child: Center(
                                      child: Container(
                                          alignment:
                                              FractionalOffset(0.5, 0.375),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Form(
                                            key: _formkey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextFormField(
                                                    style: textFormFieldStyle,
                                                    cursorColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                'New Password'),
                                                    validator: (val) => val!
                                                                .length <
                                                            8
                                                        ? 'Enter a password at least 8 characters long'
                                                        : null,
                                                    obscureText: true,
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          newPassword = val);
                                                    }),
                                                TextFormField(
                                                    style: textFormFieldStyle,
                                                    cursorColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                'Confirm New Password'),
                                                    validator: (val) => val !=
                                                            newPassword
                                                        ? 'Passwords don\'t match'
                                                        : null,
                                                    obscureText: true,
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          confirmNewPassword =
                                                              val);
                                                    }),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      minimumSize:
                                                          MaterialStateProperty.all(Size(
                                                              (MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.75),
                                                              (MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.1))),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                      elevation:
                                                          MaterialStateProperty.resolveWith<double>(
                                                              (states) => 0)),
                                                  onPressed: () async {
                                                    // Validation check
                                                    if (_formkey.currentState!
                                                        .validate()) {
                                                      dynamic result =
                                                          await AuthService()
                                                              .changePassword(
                                                                  newPassword);
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0)),
                                                              elevation: 0.0,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                              content: Text(
                                                                'Password changed',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary),
                                                              )));
                                                      if (result == null) {}
                                                    }
                                                  },
                                                  child: Text('Change password',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary)),
                                                ),
                                              ],
                                            ),
                                          )))));
                        });
                  },
                ),
                if (!kIsWeb)
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
                                      0.084,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )),
                        trailing: Transform.scale(
                          scale: MediaQuery.of(context).size.width * 0.003,
                          child: Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
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
                if (!kIsWeb)
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
                                      0.084,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )),
                        trailing: Transform.scale(
                          scale: MediaQuery.of(context).size.width * 0.003,
                          child: Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
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
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: OrangeNavButton(
                        key: Key("homeStatisticsNavButton"),
                        "/statistics",
                        "statistics",
                        context)),
                Expanded(
                    key: Key("homeCalendarNavButton"),
                    child: OrangeNavButton("/calendar", "calendar", context)),
                Expanded(
                    key: Key("homeJournalNavButton"),
                    child:
                        OrangeNavButton("/journalEntries", "journal", context)),
              ],
            ),
          ),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > constraints.maxHeight) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width / 4) /
                              (MediaQuery.of(context).size.height * (1 / 3.8)),
                      children: [
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Text(
                                "Tasks Due \nToday:",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(numberOfTasksToday.toString(),
                                        style: cardContentStyleBig),
                                  ))
                            ],
                          ),
                        )),
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Text("Events Happening \nToday: ",
                                  style: cardHeaderStyle),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(numberOfEventsToday.toString(),
                                        style: cardContentStyleBig),
                                  ))
                            ],
                          ),
                        )),
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upcoming Task:",
                                style: cardHeaderStyle,
                              ),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(upcomingTask,
                                    maxLines: 3, style: cardContentStyleSmall),
                              ))
                            ],
                          ),
                        )),
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upcoming Event:",
                                style: cardHeaderStyle,
                              ),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(upcomingEvent,
                                    maxLines: 3, style: cardContentStyleSmall),
                              ))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      borderColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selectedBorderColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      highlightColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      isSelected: isSelected,
                      color: Theme.of(context).colorScheme.onPrimary,
                      selectedColor: Theme.of(context).colorScheme.onPrimary,
                      constraints: BoxConstraints.expand(
                          width: MediaQuery.of(context).size.width / 3.1,
                          height: MediaQuery.of(context).size.height * 0.05),
                      children: [
                        toggleButtonWidget(
                            MediaQuery.of(context).size.width / 3.1,
                            isSelected[0],
                            "Default"),
                        toggleButtonWidget(
                            MediaQuery.of(context).size.width / 3.1,
                            isSelected[1],
                            "Completed"),
                        toggleButtonWidget(
                            MediaQuery.of(context).size.width / 3.1,
                            isSelected[2],
                            "Incomplete"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Stack(children: [
                    Container(
                        color: Theme.of(context).colorScheme.background,
                        margin: EdgeInsets.all(0.0),
                        child: StreamBuilder(
                          stream: DatabaseService().tasks,
                          builder:
                              (context, AsyncSnapshot<List<Task>> snapshot) {
                            var completed = Provider.of<List<Task>>(context)
                                .where((task) =>
                                    task.getCompletedOn() !=
                                    Task.incompletePlaceholder);
                            var notCompleted = Provider.of<List<Task>>(context)
                                .where((task) =>
                                    task.getCompletedOn() ==
                                    Task.incompletePlaceholder);
                            if (isSelected[0] == true) {
                              return ListView.builder(
                                  key: Key("taskListView"),
                                  itemCount:
                                      Provider.of<List<Task>>(context).length,
                                  itemBuilder: (context, index) {
                                    return TaskTile(Provider.of<List<Task>>(
                                        context)[index]);
                                  });
                            } else if (isSelected[1] == true) {
                              return ListView.builder(
                                  itemCount: completed.length,
                                  itemBuilder: (context, index) {
                                    return TaskTile(completed.toList()[index]);
                                  });
                            } else if (isSelected[2] == true) {
                              return ListView.builder(
                                  itemCount: notCompleted.length,
                                  itemBuilder: (context, index) {
                                    return TaskTile(
                                        notCompleted.toList()[index]);
                                  });
                            } else {
                              return SpinKitFoldingCube(
                                color: Theme.of(context).colorScheme.background,
                              );
                            }
                          },
                        )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FloatingActionButton(
                          key: Key("homeCreateTaskButton"),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          elevation: 0.0,
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
                          },
                          child: HexagonWidget.flat(
                              width: 100,
                              color: Theme.of(context).colorScheme.primary,
                              child: Icon(Icons.add, size: 30)),
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: kIsWeb
                          ? (MediaQuery.of(context).size.width / 2) /
                              (MediaQuery.of(context).size.height * (1 / 5))
                          : 1.35,
                      children: [
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Text(
                                "Tasks Due \nToday:",
                                style: cardHeaderStyle,
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(numberOfTasksToday.toString(),
                                        style: cardContentStyleBig),
                                  ))
                            ],
                          ),
                        )),
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Text("Events Happening \nToday: ",
                                  style: cardHeaderStyle),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(numberOfEventsToday.toString(),
                                        style: cardContentStyleBig),
                                  ))
                            ],
                          ),
                        )),
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upcoming Task:",
                                style: cardHeaderStyle,
                              ),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(upcomingTask,
                                    maxLines: 3, style: cardContentStyleSmall),
                              ))
                            ],
                          ),
                        )),
                        displayCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upcoming Event:",
                                style: cardHeaderStyle,
                              ),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(upcomingEvent,
                                    maxLines: 3, style: cardContentStyleSmall),
                              ))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      borderColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selectedBorderColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      highlightColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      isSelected: isSelected,
                      color: Theme.of(context).colorScheme.onPrimary,
                      selectedColor: Theme.of(context).colorScheme.onPrimary,
                      constraints: BoxConstraints.expand(
                          width: MediaQuery.of(context).size.width / 3.1,
                          height: MediaQuery.of(context).size.height * 0.05),
                      children: [
                        toggleButtonWidget(
                            MediaQuery.of(context).size.width / 3.1,
                            isSelected[0],
                            "Default"),
                        toggleButtonWidget(
                            MediaQuery.of(context).size.width / 3.1,
                            isSelected[1],
                            "Completed"),
                        toggleButtonWidget(
                            MediaQuery.of(context).size.width / 3.1,
                            isSelected[2],
                            "Incomplete"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Stack(children: [
                    Container(
                        color: Theme.of(context).colorScheme.background,
                        margin: EdgeInsets.all(0.0),
                        child: StreamBuilder(
                          stream: DatabaseService().tasks,
                          builder:
                              (context, AsyncSnapshot<List<Task>> snapshot) {
                            var completed = Provider.of<List<Task>>(context)
                                .where((task) =>
                                    task.getCompletedOn() !=
                                    Task.incompletePlaceholder);
                            var notCompleted = Provider.of<List<Task>>(context)
                                .where((task) =>
                                    task.getCompletedOn() ==
                                    Task.incompletePlaceholder);
                            if (isSelected[0] == true) {
                              return ListView.builder(
                                  key: Key("taskListView"),
                                  itemCount:
                                      Provider.of<List<Task>>(context).length,
                                  itemBuilder: (context, index) {
                                    return TaskTile(Provider.of<List<Task>>(
                                        context)[index]);
                                  });
                            } else if (isSelected[1] == true) {
                              return ListView.builder(
                                  itemCount: completed.length,
                                  itemBuilder: (context, index) {
                                    return TaskTile(completed.toList()[index]);
                                  });
                            } else if (isSelected[2] == true) {
                              return ListView.builder(
                                  itemCount: notCompleted.length,
                                  itemBuilder: (context, index) {
                                    return TaskTile(
                                        notCompleted.toList()[index]);
                                  });
                            } else {
                              return SpinKitFoldingCube(
                                color: Theme.of(context).colorScheme.background,
                              );
                            }
                          },
                        )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FloatingActionButton(
                          key: Key("homeCreateTaskButton"),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          elevation: 0.0,
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
                          },
                          child: HexagonWidget.flat(
                              width: 100,
                              color: Theme.of(context).colorScheme.primary,
                              child: Icon(Icons.add, size: 30)),
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget toggleButtonWidget(double width, bool selected, String text) {
    return Container(
        width: width,
        decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onPrimary),
        )));
  }

  Widget displayCard(Widget child) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: child,
    );
  }
}
