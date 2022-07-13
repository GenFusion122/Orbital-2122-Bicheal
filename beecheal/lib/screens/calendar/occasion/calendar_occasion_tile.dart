import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/calendar/calendar.dart';
import 'package:flutter/material.dart';
import '../calendar_edit.dart';
import 'package:intl/intl.dart';

import 'calendar_occasion_view.dart';

class OccasionTile extends StatelessWidget {
  final Occasion occasion;
  OccasionTile(this.occasion);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.04),
      ),
      child: ListTile(
        title: Text(occasion.getTitle(),
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                overflow: TextOverflow.ellipsis,
                color: Color(0xff000000))),
        subtitle: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              occasion.getDescription(),
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  overflow: TextOverflow.ellipsis),
            )),
        trailing: Text(
          DateFormat('yyyy-MM-dd  \nhh:mm a')
              .format(occasion.getDate())
              .toString(),
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 60, 60, 60)),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return OccasionView(occasion);
              });
        },
      ),
    );
  }
}
