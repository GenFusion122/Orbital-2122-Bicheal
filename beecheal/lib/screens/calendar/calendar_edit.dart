import 'package:beecheal/custom%20widgets/timepicker.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/calendar/occasion/calendar_occasion_view.dart';
import 'package:beecheal/screens/home/initialize_notifications.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:flutter/material.dart';
import '../../custom widgets/constants.dart';
import 'package:intl/intl.dart';
import 'package:beecheal/services/notifications.dart';
import '../../models/occasion.dart';
import '../../services/database.dart';

class CalendarEditScreen<T extends Occasion> extends StatefulWidget {
  T occasion;
  String textPrompt;
  DateTime selectedDay;

  CalendarEditScreen(
      {required this.occasion,
      required this.textPrompt,
      required this.selectedDay});
  @override
  State<CalendarEditScreen<T>> createState() => _CalenderEditScreen<T>();
}

class _CalenderEditScreen<T extends Occasion>
    extends State<CalendarEditScreen<T>> {
  final _formkey = GlobalKey<FormState>();
  DateTime? newDate;
  TimeOfDay? newTime;
  String? newTitle;
  String? newDescription;
  @override
  Widget build(BuildContext context) {
    String dateLabel =
        DateFormat('yyyy-MM-dd').format(newDate ?? widget.occasion.getDate());
    String timeLabel =
        (newTime ?? TimeOfDay.fromDateTime(widget.occasion.getDate()))
            .format(context);
    return AlertDialog(
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.02)),
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
                      key: Key("calendarTitleField"),
                      maxLength: 50,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000)),
                      cursorColor: Color(0xff000000),
                      initialValue: widget.occasion.getTitle(),
                      decoration: textInputDecorationFormField.copyWith(
                          hintText: 'Title'),
                      validator: (val) =>
                          val!.isNotEmpty ? null : 'Please enter a title',
                      onChanged: (val) {
                        setState(() => newTitle = val);
                        ;
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
                      key: Key("calendarDescriptionField"),
                      maxLength: 100,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000)),
                      cursorColor: Color(0xff000000),
                      initialValue: widget.occasion.getDescription(),
                      decoration: textInputDecorationFormField.copyWith(
                          hintText: 'Description'),
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
                                    key: Key("calendarEditDateButton"),
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
                                                        widget.occasion
                                                            .getDate()) ??
                                                widget.occasion.getDate();
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
                                    key: Key("calendarEditTimeButton"),
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
                                        TimeOfDay tempTime =
                                            await TimePicker.timePicker(
                                                    context,
                                                    newDate ??
                                                        widget.occasion
                                                            .getDate()) ??
                                                TimeOfDay.fromDateTime(
                                                    widget.occasion.getDate());
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
                              TimeOfDay? pickedDateTime =
                                  await TimePicker.timePicker(
                                      context, DateTime.now());
                              if (pickedDateTime != null) {
                                //if the user didn't cancel
                                widget.occasion.setTitle(
                                    newTitle ?? widget.occasion.getTitle());
                                widget.occasion.setDescription(newDescription ??
                                    widget.occasion.getDescription());
                                widget.occasion.setDate(widget.occasion
                                    .getDate()
                                    .add(Duration(
                                        hours: pickedDateTime.hour,
                                        minutes: pickedDateTime.minute)));
                                if (T.toString() == "Task") {
                                  //Task uses this view when creating
                                  DatabaseService().updateUserTask(
                                      widget.occasion.getId(),
                                      widget.occasion.getTitle(),
                                      widget.occasion.getDate(),
                                      widget.occasion.getDescription(),
                                      Task.incompletePlaceholder);
                                } else {
                                  DatabaseService().updateUserOccasion(
                                      widget.occasion.getId(),
                                      widget.occasion.getTitle(),
                                      widget.occasion.getDate(),
                                      widget.occasion.getDescription());
                                }
                                InitializeNotifications
                                    .initializeToDoNotifications();
                                Navigator.of(context).pop();
                              }
                            } else {
                              widget.occasion.setTitle(
                                  newTitle ?? widget.occasion.getTitle());
                              widget.occasion.setDescription(newDescription ??
                                  widget.occasion.getDescription());
                              DateTime originalDateTime =
                                  widget.occasion.getDate();
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
                                  ? widget.occasion.setDate(combinedDateTime)
                                  : null;
                              DatabaseService().updateUserOccasion(
                                  widget.occasion.getId(),
                                  widget.occasion.getTitle(),
                                  widget.occasion.getDate(),
                                  widget.occasion.getDescription());
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
