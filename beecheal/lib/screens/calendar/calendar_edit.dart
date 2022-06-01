import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../custom widgets/constants.dart';
import '../../services/database.dart';

class CalenderEditScreen extends StatefulWidget {
  Occasion occasion;
  String textPrompt;
  DateTime? selectedDay;
  CalenderEditScreen(
      {required this.occasion,
      required this.textPrompt,
      required this.selectedDay});
  @override
  State<CalenderEditScreen> createState() => _CalenderEditScreenState();
}

class _CalenderEditScreenState extends State<CalenderEditScreen> {
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
                          if (_formkey.currentState!.validate()) {
                            if (widget.textPrompt == 'Create') {
                              await DatePicker.showTimePicker(
                                context,
                                showTitleActions: true,
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  widget.occasion.setDate(widget.occasion
                                      .getDate()
                                      .add(Duration(
                                          hours: date.hour,
                                          minutes: date.minute)));
                                },
                              );
                              DatabaseService().updateUserOccasion(
                                  '',
                                  widget.occasion.getTitle(),
                                  widget.occasion.getDate(),
                                  widget.occasion.getDescription());
                              Navigator.of(context).pop();
                            } else {
                              await DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  widget.occasion.setDate(date);
                                },
                              );
                              DatabaseService().updateUserOccasion(
                                  widget.occasion.getId(),
                                  widget.occasion.getTitle(),
                                  widget.occasion.getDate(),
                                  widget.occasion.getDescription());
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CalendarView();
                                  });
                            }
                          }
                        }),
                  )
                ],
              ))
        ]));
  }
}
