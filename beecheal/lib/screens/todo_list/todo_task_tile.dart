import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/database.dart';
import 'package:beecheal/models/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  // const TileTemplate({Key? key}) : super(key: key);

  var occasion;
  TaskTile(this.occasion);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.02)),
          child: ListTile(
            title: Text(
              occasion.getTitle(),
              style: tileTitleStyle,
            ),
            subtitle: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    occasion.getDescription(),
                    style: tileDescriptionStyle,
                  )),
              Align(
                  alignment: Alignment.centerRight,
                  // changes text color based on current completedOn status and time relative to due date
                  child: Text(
                      DateFormat('yyyy-MM-dd   hh:mm a')
                          .format(occasion.getDate())
                          .toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: (occasion
                                .getCompletedOn()
                                .isBefore(occasion.getDate()))
                            ? Colors.green
                            : ((DateTime.now()
                                        .difference(occasion.getDate())
                                        .inDays <
                                    -7))
                                ? Color.fromARGB(255, 60, 60, 60)
                                : (DateTime.now().isBefore(occasion.getDate()))
                                    ? Color.fromARGB(255, 255, 237, 70)
                                    : Color.fromARGB(255, 255, 92, 80),
                      ))),
            ]),
            trailing: IconButton(
                iconSize: 30.0,
                icon: occasion.getCompletedOn() == Task.incompletePlaceholder
                    ? Icon(Icons.check_box_outline_blank_rounded,
                        color: Colors.red)
                    : Icon(Icons.check_box_rounded, color: Colors.green),
                onPressed: () {
                  if (occasion.getCompletedOn() == Task.incompletePlaceholder) {
                    DatabaseService().updateUserTask(
                        occasion.getId(),
                        occasion.getTitle(),
                        occasion.getDate(),
                        occasion.getDescription(),
                        DateTime.now());
                  } else {
                    DatabaseService().updateUserTask(
                        occasion.getId(),
                        occasion.getTitle(),
                        occasion.getDate(),
                        occasion.getDescription(),
                        Task.incompletePlaceholder);
                  }
                }),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TaskView(occasion);
                  });
            },
          ),
        ));
  }
}
