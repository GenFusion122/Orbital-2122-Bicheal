import 'package:flutter/material.dart';
import 'journal_entry_view.dart';

class EntryTile extends StatelessWidget {
  // const EntryTile({Key? key}) : super(key: key);

  final entry;

  EntryTile({this.entry});

  @override
  Widget build(BuildContext context) {
    String? title = entry?.get('title');
    String? description = entry?.get('description');
    String? dateTime = entry?.get('dateTime');
    String? body = entry?.get('body');
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            title: Text(title.toString()),
            subtitle: Text(description.toString()),
            trailing: Text(dateTime.toString()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EntryView(
                        title: title,
                        description: description,
                        body: body,
                        dateTime: dateTime);
                  });
            },
          ),
        ));
  }
}
