import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/database.dart';
import 'package:intl/intl.dart';
import '../../services/notifications.dart';
import '../home/initialize_notifications.dart';

class TaskView extends StatelessWidget {
  // const EntryView({Key? key}) : super(key: key);
  Task task;

  TaskView(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.04)),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Title',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Card(
            clipBehavior: Clip.none,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(task.getTitle(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000))),
                ),
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Description',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Card(
            clipBehavior: Clip.none,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(task.getDescription(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000))),
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Card(
              clipBehavior: Clip.none,
              margin: EdgeInsets.symmetric(vertical: 1.0),
              color: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${task.getCompletedOn() == Task.incompletePlaceholder ? 'Incomplete' : 'Completed on: ${DateFormat('yyyy-MM-dd hh:mm a').format(task.getCompletedOn())}'}',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    child: Text('Date:',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Text(
                        '${DateFormat('yyyy-MM-dd').format(task.getDate())}',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    child: Text('Time:',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Text(DateFormat('hh:mm a').format(task.getDate()),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ],
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFFFE98C)),
                      elevation: MaterialStateProperty.resolveWith<double>(
                          (states) => 0)),
                  child: Text('Edit',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000000))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TaskEditScreen(
                              task: task, textPrompt: 'Update');
                        });
                  }),
            ),
            if (task.getCompletedOn() == Task.incompletePlaceholder)
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFFE98C)),
                        elevation: MaterialStateProperty.resolveWith<double>(
                            (states) => 0)),
                    child: Text('Delete',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000))),
                    onPressed: () async {
                      await NotificationService.getNotificationInstance()
                          .cancelAll();
                      InitializeNotifications.initializeToDoNotifications();
                      DatabaseService()
                          .deleteUserTask(task.getId(), task.getTitle());
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          elevation: 0.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          content: Text(
                            'Deleted ${task.getTitle()}',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff000000)),
                          )));
                    }),
              ),
          ],
        )
      ]),
    );
    ;
  }
}
