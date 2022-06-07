import 'package:beecheal/models/occasion.dart';
import 'package:beecheal/screens/calendar/calendar.dart';
import 'package:beecheal/screens/calendar/calendar_occasion_view.dart';
import 'package:flutter/material.dart';
import 'calendar_occasion_edit.dart';
import 'package:intl/intl.dart';

class OccasionTile extends StatelessWidget {
  final Occasion occasion;
  OccasionTile(this.occasion);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            title: Text(occasion.getTitle()),
            subtitle: Text(occasion.getDescription()),
            trailing: Text(DateFormat('yyyy-MM-dd   hh:mm a')
                .format(occasion.getDate())
                .toString()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return OccasionView(occasion);
                  });
            },
          ),
        ));
  }
}
