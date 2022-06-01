import 'package:beecheal/models/task.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  // const TaskTile({Key? key}) : super(key: key);

  final Task task;

  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            title: Text(task.getTitle()),
            subtitle: Text(task.getDescription()),
            trailing: Text(task.getDate().toString()),
            onTap: () {},
          ),
        ));
  }
}
