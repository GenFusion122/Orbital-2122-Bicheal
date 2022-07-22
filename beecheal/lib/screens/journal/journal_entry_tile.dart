import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:hexagon/hexagon.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  // const EntryTile({Key? key}) : super(key: key);

  var occasion;
  bool viewOnly;

  EntryTile(this.occasion, this.viewOnly);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.02)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            // entry title
            title: Text(occasion.getTitle(), style: tileTitleStyle),
            // entry description
            subtitle:
                Text(occasion.getDescription(), style: tileDescriptionStyle),
            // entry date
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd\nhh:mm a')
                        .format(occasion.getDate())
                        .toString(),
                    style: tileDateStyle,
                  )
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              // entry sentiment
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HexagonWidget.flat(
                      width: 35,
                      elevation: 0.0,
                      color: occasion.getSentiment() == 1
                          ? Colors.green
                          : occasion.getSentiment() == -1
                              ? Colors.red
                              : Colors.grey),
                ],
              )
            ]),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EntryView(occasion, viewOnly);
                  });
            },
          ),
        ));
  }
}
