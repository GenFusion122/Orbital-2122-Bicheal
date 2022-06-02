import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../custom widgets/timepicker.dart';

class TaskEditScreen extends StatefulWidget {
  // const EntryScreen({Key? key}) : super(key: key);

  Task task;
  String textPrompt;

  TaskEditScreen({required this.task, required this.textPrompt});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formkey = GlobalKey<FormState>();

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
          Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: TextFormField(
                        initialValue: widget.task.getTitle(),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Title'),
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Please enter a title',
                        onChanged: (val) {
                          setState(() => widget.task.setTitle(val));
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: TextFormField(
                        initialValue: widget.task.getDescription(),
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Description'),
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Please enter a description',
                        onChanged: (val) {
                          setState(() => widget.task.setDescription(val));
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 255, 202, 0))),
                        child: Text(widget.textPrompt),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            DateTime? pickedDateTime =
                                await TimePicker.dateTimePicker(
                                    context, widget.task.getDate());
                            if (pickedDateTime != null) {
                              //if the user didn't cancel
                              widget.task.setDate(pickedDateTime);
                              DatabaseService().updateUserTask(
                                  widget.task.getId(),
                                  widget.task.getTitle(),
                                  widget.task.getDate(),
                                  widget.task.getDescription(),
                                  widget.task.getCompletedOn());
                            }
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskView(widget.task);
                                });
                          }
                        }),
                  )
                ],
              ))
        ]));
  }
}
