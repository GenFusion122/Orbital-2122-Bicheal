import 'package:beecheal/models/entry.dart';
import 'package:flutter/material.dart';
import 'journal_entry_view.dart';

class EntryTile extends StatelessWidget {
  // const EntryTile({Key? key}) : super(key: key);

  final Entry entry;
  EntryTile(this.entry);

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
            title: Text(entry.title),
            subtitle: Text(entry.description),
            trailing: Text(entry.date.toString()),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EntryView(entry);
                  });
            },
          ),
        ));
  }
}
