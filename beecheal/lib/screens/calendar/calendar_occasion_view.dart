import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/calendar/calendar_occasion_edit.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';

class OccasionView extends StatelessWidget {
  Occasion occasion;
  OccasionView(this.occasion);

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
          Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
                alignment: Alignment.topRight,
                child: Text(occasion.getDate().toString(),
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold))),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 400.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(occasion.getTitle(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ),
                  ),
                )),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(occasion.getDescription(),
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14.0)),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 202, 0))),
                    child: Text('Edit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CalendarEditScreen(
                                occasion: occasion,
                                textPrompt: "Update",
                                selectedDay: occasion.getDate());
                          });
                    }),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 202, 0))),
                    child: Text('Delete'),
                    onPressed: () {
                      DatabaseService().deleteUserOccasion(
                          occasion.getId(), occasion.getTitle());
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(const Duration(seconds: 1), () {});
                            return AlertDialog(
                                title: Text('Deleted ${occasion.getTitle()}'));
                          });
                    }),
              ],
            )
          ]),
        ]));
  }
}
