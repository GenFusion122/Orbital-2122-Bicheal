import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:hexagon/hexagon.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  // const EntryTile({Key? key}) : super(key: key);

  var occasion;

  EntryTile(this.occasion);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005),
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.04)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            title: Text(occasion.getTitle(),
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
            subtitle: Text(occasion.getDescription(),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                )),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd\nhh:mm a')
                        .format(occasion.getDate())
                        .toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff000000)),
                  )
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HexagonWidget.flat(
                      width: MediaQuery.of(context).size.width * 0.075,
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
                    return EntryView(occasion, false);
                  });
            },
          ),
        ));
  }
}
