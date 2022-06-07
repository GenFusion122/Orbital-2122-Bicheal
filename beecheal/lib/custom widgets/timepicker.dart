import 'package:flutter/material.dart';

class TimePicker {
  static Future<DateTime?> dateTimePicker(
      BuildContext context, DateTime initDate) async {
    DateTime? finalDate = await datePicker(context, initDate);
    if (finalDate == null) {
      Navigator.of(context).pop();
      return null;
    }
    TimeOfDay? finalTime =
        await timePicker(context, TimeOfDay.fromDateTime(initDate));
    if (finalTime == null) {
      Navigator.of(context).pop();
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
              //backgroundColor: Color.fromARGB(255, 255, 202, 0),
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(
                    255, 255, 202, 0), // header background colour
                onPrimary: Colors.black, // header text colour
                onSurface: Colors.black, // body text colour
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 202, 0), //button colour
                  primary: Colors.white,
                ),
              ),
            ),
            child: child!,
          );
        });
    return pickedDate;
  }

  static Future<TimeOfDay?> timePicker(
      BuildContext context, TimeOfDay initTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: initTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              backgroundColor: Color.fromARGB(255, 255, 202, 0),
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(
                    255, 255, 202, 0), // header background colour
                onPrimary: Colors.black, // header text colour
                onSurface: Colors.black, // body text colour
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 202, 0), //button colour
                  primary: Colors.white,
                ),
              ),
            ),
            child: child!,
          );
        });

    return pickedTime;
  }
}