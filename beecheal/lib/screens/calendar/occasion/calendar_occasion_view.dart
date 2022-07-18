import 'package:beecheal/models/occasion.dart';
import 'package:flutter/material.dart';
import '../../../services/database.dart';
import '../../../services/notifications.dart';
import '../../home/initialize_notifications.dart';
import '../calendar_edit.dart';
import 'package:intl/intl.dart';

class OccasionView extends StatelessWidget {
  Occasion occasion;
  OccasionView(this.occasion);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.02)),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Title',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Card(
            clipBehavior: Clip.none,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(occasion.getTitle(),
                    softWrap: true,
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff000000))),
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Description',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Card(
            clipBehavior: Clip.none,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(occasion.getDescription(),
                      softWrap: true,
                      maxLines: 5,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000))),
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    child: Text('Date:',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Text(
                        '${DateFormat('yyyy-MM-dd').format(occasion.getDate())}',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    child: Text('Time:',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Text(
                        DateFormat('hh:mm a').format(occasion.getDate()),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ],
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFFFE98C)),
                      elevation: MaterialStateProperty.resolveWith<double>(
                          (states) => 0)),
                  child: Text('Edit',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000000))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CalendarEditScreen(
                              occasion: occasion,
                              textPrompt: 'Update',
                              selectedDay: occasion.getDate());
                        });
                  }),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFFFE98C)),
                      elevation: MaterialStateProperty.resolveWith<double>(
                          (states) => 0)),
                  child: Text('Delete',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000000))),
                  onPressed: () async {
                    await NotificationService.getNotificationInstance()
                        .cancelAll();
                    InitializeNotifications.initializeToDoNotifications();
                    DatabaseService().deleteUserOccasion(
                        occasion.getId(), occasion.getTitle());
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        elevation: 0.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        content: Text(
                          'Deleted ${occasion.getTitle()}',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff000000)),
                        )));
                  }),
            ),
          ],
        )
      ]),
    );
  }
}
