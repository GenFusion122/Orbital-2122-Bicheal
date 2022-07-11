import 'package:beecheal/custom%20widgets/timepicker.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/home/initialize_notifications.dart';
import 'package:flutter/material.dart';
import '../../custom widgets/constants.dart';

import 'package:beecheal/services/notifications.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../services/database.dart';

class CalendarEditScreen<T extends Occasion> extends StatefulWidget {
  T occasion;
  String textPrompt;
  DateTime? selectedDay;

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

  @override
  Widget build(BuildContext context) {
    String newTitle = widget.occasion.getTitle();
    String newDescription = widget.occasion.getDescription();

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
                        initialValue: widget.occasion.getTitle(),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Title'),
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Please enter a title',
                        onChanged: (val) {
                          newTitle = val;
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: TextFormField(
                        initialValue: widget.occasion.getDescription(),
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Description'),
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Please enter a description',
                        onChanged: (val) {
                          newDescription = val;
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
                          TimeOfDay? pickedTime;
                          DateTime? pickedDateTime;
                          if (_formkey.currentState!.validate()) {
                            if (widget.textPrompt == 'Create') {
                              pickedTime = await TimePicker.timePicker(
                                  context, DateTime.now());
                              if (pickedTime != null) {
                                //if the user didn't cancel
                                widget.occasion.setDate(widget.occasion
                                    .getDate()
                                    .add(Duration(
                                        hours: pickedTime.hour,
                                        minutes: pickedTime.minute)));
                              }
                            } else {
                              //else its 'update'
                              pickedDateTime = await TimePicker.dateTimePicker(
                                  context, widget.occasion.getDate());
                              if (pickedDateTime != null) {
                                //if the user didn't cancel
                                widget.occasion.setDate(pickedDateTime);
                              }
                            }

                            if (!(pickedDateTime == null &&
                                pickedTime == null)) {
                              widget.occasion.setTitle(newTitle);
                              widget.occasion.setDescription(newDescription);
                              //if both aren't null, then the user didn't cancel
                              if (T.toString() == "Task") {
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
                                  .initializeOccasionNotifications();
                            }
                            Navigator.of(context).pop();
                          }
                        }),
                  )
                ],
              ))
        ]));
  }
}
