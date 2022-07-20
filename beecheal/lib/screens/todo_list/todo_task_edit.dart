import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/home/initialize_notifications.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'package:intl/intl.dart';
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
  DateTime? newDate;
  TimeOfDay? newTime;
  String? newTitle;
  String? newDescription;
  @override
  Widget build(BuildContext context) {
    String dateLabel =
        DateFormat('yyyy-MM-dd').format(newDate ?? widget.task.getDate());
    String timeLabel =
        (newTime ?? TimeOfDay.fromDateTime(widget.task.getDate()))
            .format(context);
    return AlertDialog(
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.04)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0,
                        MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
                    child: Text('Title',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: TextFormField(
                      key: Key("taskTitleField"),
                      maxLength: 50,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000)),
                      cursorColor: Color(0xff000000),
                      initialValue: widget.task.getTitle(),
                      decoration: textInputDecorationFormField.copyWith(
                          counterText: "", hintText: 'Title'),
                      validator: (val) =>
                          val!.isNotEmpty ? null : 'Please enter a title',
                      onChanged: (val) {
                        setState(() => newTitle = val);
                      }),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0,
                        MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
                    child: Text('Description',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: TextFormField(
                      key: Key("taskDescriptionField"),
                      maxLength: 100,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000)),
                      cursorColor: Color(0xff000000),
                      initialValue: widget.task.getDescription(),
                      decoration: textInputDecorationFormField.copyWith(
                          counterText: "", hintText: 'Description'),
                      validator: (val) =>
                          val!.isNotEmpty ? null : 'Please enter a description',
                      onChanged: (val) {
                        setState(() => newDescription = val);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.001,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                if (widget.textPrompt != 'Create')
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 50.0,
                                  child: Text('Date:',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff000000))),
                                ),
                                Text(dateLabel,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xff000000))),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: SizedBox(
                                width: 100.0,
                                child: ElevatedButton(
                                    key: Key("taskSelectDateButton"),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFFFFE98C)),
                                        elevation:
                                            MaterialStateProperty.resolveWith<
                                                double>((states) => 0)),
                                    child: Text('Edit',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000))),
                                    onPressed: () async {
                                      {
                                        DateTime tempDate =
                                            await TimePicker.datePicker(
                                                    context,
                                                    newDate ??
                                                        widget.task
                                                            .getDate()) ??
                                                widget.task.getDate();
                                        setState(() {
                                          newDate = tempDate;
                                        });
                                      }
                                    }),
                              ),
                            )
                          ],
                        )),
                  ),
                if (widget.textPrompt != 'Create')
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 50.0,
                                  child: Text('Time:',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff000000))),
                                ),
                                Text(timeLabel,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xff000000))),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: SizedBox(
                                width: 100.0,
                                child: ElevatedButton(
                                    key: Key("taskSelectTimeButton"),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFFFFE98C)),
                                        elevation:
                                            MaterialStateProperty.resolveWith<
                                                double>((states) => 0)),
                                    child: Text('Edit',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000))),
                                    onPressed: () async {
                                      {
                                        TimeOfDay tempTime;
                                        if (kIsWeb) {
                                          tempTime =
                                              await TimePicker.webTimePicker(
                                                      context,
                                                      newDate ??
                                                          widget.task
                                                              .getDate()) ??
                                                  TimeOfDay.fromDateTime(
                                                      widget.task.getDate());
                                        } else {
                                          tempTime =
                                              await TimePicker.timePicker(
                                                      context,
                                                      newDate ??
                                                          widget.task
                                                              .getDate()) ??
                                                  TimeOfDay.fromDateTime(
                                                      widget.task.getDate());
                                        }
                                        setState(() {
                                          newTime = tempTime;
                                        });
                                      }
                                    }),
                              ),
                            )
                          ],
                        )),
                  ),
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: SizedBox(
                    width: 100.0,
                    child: ElevatedButton(
                        key: Key("taskCreateEditButton"),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFFFE98C)),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        child: Text(widget.textPrompt,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000))),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (widget.textPrompt == "Create") {
                              DateTime? pickedDateTime =
                                  await TimePicker.dateTimePicker(
                                      context, widget.task.getDate());
                              if (pickedDateTime != null) {
                                //if the user didn't cancel
                                widget.task.setTitle(
                                    newTitle ?? widget.task.getTitle());
                                widget.task.setDescription(newDescription ??
                                    widget.task.getDescription());
                                widget.task.setDate(pickedDateTime);
                                DatabaseService().updateUserTask(
                                    widget.task.getId(),
                                    widget.task.getTitle(),
                                    widget.task.getDate(),
                                    widget.task.getDescription(),
                                    widget.task.getCompletedOn());
                                InitializeNotifications
                                    .initializeToDoNotifications();
                                Navigator.of(context).pop();
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return TaskView(widget.task);
                                //     });
                              }
                            } else {
                              widget.task
                                  .setTitle(newTitle ?? widget.task.getTitle());
                              widget.task.setDescription(newDescription ??
                                  widget.task.getDescription());
                              DateTime originalDateTime = widget.task.getDate();
                              DateTime combinedDateTime = (newDate ??
                                      DateTime(
                                          originalDateTime.year,
                                          originalDateTime.month,
                                          originalDateTime.day))
                                  .add(Duration(
                                      hours: (newTime ??
                                              TimeOfDay.fromDateTime(
                                                  originalDateTime))
                                          .hour,
                                      minutes: (newTime ??
                                              TimeOfDay.fromDateTime(
                                                  originalDateTime))
                                          .minute));
                              newDate != null
                                  ? widget.task.setDate(combinedDateTime)
                                  : null;
                              DatabaseService().updateUserTask(
                                  widget.task.getId(),
                                  widget.task.getTitle(),
                                  widget.task.getDate(),
                                  widget.task.getDescription(),
                                  Task.incompletePlaceholder);
                              InitializeNotifications
                                  .initializeToDoNotifications();
                              Navigator.of(context).pop();
                            }
                          }
                        }),
                  ),
                )
              ],
            )));
  }
}
