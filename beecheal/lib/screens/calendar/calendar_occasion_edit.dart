import 'dart:ffi';

import 'package:beecheal/custom%20widgets/timepicker.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../custom widgets/constants.dart';
import '../../services/database.dart';

class CalendarEditScreen extends StatefulWidget {
  Occasion occasion;
  String textPrompt;
  DateTime? selectedDay;

  CalendarEditScreen(
      {required this.occasion,
      required this.textPrompt,
      required this.selectedDay});
  @override
  State<CalendarEditScreen> createState() => _CalenderEditScreenState();
}

class _CalenderEditScreenState extends State<CalendarEditScreen> {
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
                        initialValue: widget.occasion.getTitle(),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Title'),
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Please enter a title',
                        onChanged: (val) {
                          setState(() => widget.occasion.setTitle(val));
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
                          setState(() => widget.occasion.setDescription(val));
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
                                  context,
                                  TimeOfDay.fromDateTime(
                                      widget.occasion.getDate()));
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
                              //if both aren't null, then the user didn't cancel
                              DatabaseService().updateUserOccasion(
                                  widget.occasion.getId(),
                                  widget.occasion.getTitle(),
                                  widget.occasion.getDate(),
                                  widget.occasion.getDescription());
                            }
                            Navigator.of(context).pop(); //if he did just pop
                          }
                        }),
                  )
                ],
              ))
        ]));
  }
}
