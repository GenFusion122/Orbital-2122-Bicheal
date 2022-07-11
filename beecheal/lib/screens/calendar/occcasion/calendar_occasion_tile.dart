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
      margin: EdgeInsets.symmetric(vertical: 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        title: Text(occasion.getTitle(),
            style: TextStyle(overflow: TextOverflow.ellipsis)),
        subtitle: Text(
          occasion.getDescription(),
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
        trailing: Text(
          DateFormat('yyyy-MM-dd  \nhh:mm a')
              .format(occasion.getDate())
              .toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
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
