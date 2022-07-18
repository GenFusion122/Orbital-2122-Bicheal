import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class TimePicker {
  static Future<DateTime?> dateTimePicker(
      BuildContext context, DateTime initDate) async {
    DateTime? finalDate = await datePicker(context, initDate);
    if (finalDate == null) {
      Navigator.of(context).pop();
      return null;
    }
    TimeOfDay? finalTime = await timePicker(context, initDate);
    if (finalTime == null) {
      return null;
    }
    finalDate = finalDate
        .add(Duration(hours: finalTime.hour, minutes: finalTime.minute));
    return finalDate;
  }

  static Future<DateTime?> datePicker(
      BuildContext context, DateTime initDate) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(3000),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                tertiary: Colors.white,
                primary: Theme.of(context)
                    .colorScheme
                    .primary, // header background colour
                onPrimary: Colors.black, // header text colour
                onSurface: Colors.black, // body text colour
              ),
              dialogBackgroundColor: Colors.white,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary, //button colour
                  primary: Colors.black,
                ),
              ),
            ),
            child: child!,
          );
        });
    return pickedDate;
  }

  static Future<TimeOfDay?> timePicker(
      BuildContext context, DateTime initTime) async {
    TimeOfDay? pickedTime =
        TimeOfDay(hour: initTime.hour, minute: initTime.minute);
    await showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 1 / 6,
                  MediaQuery.of(context).size.height * 1 / 3,
                  MediaQuery.of(context).size.width * 1 / 6,
                  MediaQuery.of(context).size.height * 1 / 3),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      height: MediaQuery.of(context).size.height * 1 / 6,
                      child: CupertinoDatePicker(
                          minimumDate: DateTime(1990),
                          maximumDate: DateTime(3000),
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: initTime,
                          onDateTimeChanged: (value) {
                            pickedTime = TimeOfDay(
                                hour: value.hour, minute: value.minute);
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Theme.of(context).colorScheme.secondary)),
                            onPressed: () {
                              pickedTime = null;
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
                        SizedBox(width: 10),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Theme.of(context).colorScheme.secondary)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK")),
                      ],
                    ),
                  ],
                ),
              ),
            ));
    return pickedTime;
  }
}
