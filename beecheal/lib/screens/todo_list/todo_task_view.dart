import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/database.dart';

class TaskView extends StatelessWidget {
  // const EntryView({Key? key}) : super(key: key);
  Task task;

  TaskView(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.orange[100],
        content: Stack(children: <Widget>[
          Positioned(
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
                alignment: Alignment.topRight,
                child: Text(task.getDate().toString(),
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold))),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 400.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(task.getTitle(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ),
                  ),
                )),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(task.getDescription(),
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14.0)),
                  ),
                )),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${task.getCompletedOn() == DateTime(2999, 12, 12, 23, 59) ? 'Not completed' : 'Completed on ${task.getCompletedOn()}'}',
                        style: TextStyle(color: Colors.black, fontSize: 14.0)),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 202, 40))),
                    child: Text('Edit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TaskEditScreen(
                                task: task, textPrompt: 'Update');
                          });
                    }),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 202, 40))),
                    child: Text('Delete'),
                    onPressed: () {
                      DatabaseService()
                          .deleteUserTask(task.getId(), task.getTitle());
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });
                            return AlertDialog(
                                title: Text('Deleted ${task.getTitle()}'));
                          });
                    }),
              ],
            )
          ]),
        ]));
    ;
  }
}
