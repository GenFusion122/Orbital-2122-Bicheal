import 'package:beecheal/models/occasion.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';

class TileTemplate extends StatelessWidget {
  // const TileTemplate({Key? key}) : super(key: key);

  var occasion;
  String view;
  TileTemplate(this.occasion, this.view);

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
            title: Text(occasion.title),
            subtitle: Text(occasion.description),
            trailing: Text(occasion.date.toString()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (view == 'TaskView') {
                      return TaskView(occasion);
                    } else if (view == 'EntryView') {
                      return EntryView(occasion);
                    } else {
                      return Container();
                    }
                  });
            },
          ),
        ));
  }
}
