import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:beecheal/screens/todo_list/todo_task_tile.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/database.dart';
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
  String toDoListState = 'Default';
  Timer? _everyMinute;

  // To test notifications
  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.pushNamed(context, '/journalEntries');

  void initState() {
    super.initState();
    NotificationService.init(initScheduled: true);
    listenNotifications();

    // Daily journal entry notification
    NotificationService.showDailyScheduledNotification(
        title: 'Daily journal entry',
        body: 'bruh',
        payload: 'just do eet',
        time: Time(20),
        scheduledDate: DateTime.now());

    // Weekly notification
    NotificationService.showWeeklyScheduledNotification(
        title: 'Weekly reminder',
        body: 'It\'s a new week!',
        payload: 'idk',
        time: Time(8),
        days: [DateTime.monday],
        scheduledDate: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // refreshes listview
    _everyMinute = Timer.periodic(Duration(minutes: 1), (Timer t) {
      // print('Rebuilt at ${DateTime.now()}');
      setState(() {});
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 243, 224),
      appBar: AppBar(
        title: Text('Home!'),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              icon: Icon(Icons.person),
              style: TextButton.styleFrom(primary: Colors.brown[500]),
              label: Text('Sign Out'),
              onPressed: () async {
                await _auth.signOut();
                setState(() {});
              })
        ],
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
                      var completed = Provider.of<List<Task>>(context).where(
                          (task) =>
                              task.getCompletedOn() !=
                              Task.incompletePlaceholder);
                      var notCompleted = Provider.of<List<Task>>(context).where(
                          (task) =>
                              task.getCompletedOn() ==
                              Task.incompletePlaceholder);
                      if (toDoListState == 'Default') {
                        return ListView.builder(
                            itemCount: Provider.of<List<Task>>(context).length,
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
              flex: 4,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                  ])),
          Expanded(
              flex: 4,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                  ])),
          // To test notifications
          Expanded(
            flex: 1,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 202, 40))),
                child: Text('Notification'),
                onPressed: () {
                  NotificationService.showNotification(
                    title: 'Ding dONG',
                    body: 'Time for your daily journal entry dickhead',
                    payload: 'test.abs',
                  );
                }),
          ),
          //testing Scheduled Noti's
          Expanded(
            flex: 1,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 202, 40))),
                child: Text('Scheduled Notification'),
                onPressed: () {
                  NotificationService.showScheduledNotification(
                    title: 'WHAT THE HELL IS EVEN THAT',
                    body: 'MY PP BIG SIAL',
                    payload: 'test.abs',
                    scheduledDate: DateTime.now().add(Duration(seconds: 10)),
                  );
                }),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child:
                        OrangeNavButton("/statistics", "statistics", context)),
                Expanded(
                    child: OrangeNavButton("/calendar", "calendar", context)),
                Expanded(
                    child:
                        OrangeNavButton("/journalEntries", "journal", context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
