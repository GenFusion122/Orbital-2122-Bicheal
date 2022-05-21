import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class EntryTile extends StatelessWidget {
  // const EntryTile({Key? key}) : super(key: key);

  final entry;

  EntryTile({this.entry});

  @override
  Widget build(BuildContext context) {
    String? title = entry?.get('title');
    String? description = entry?.get('description');
    String? dateTime = entry?.get('dateTime');
    return Padding(
        padding: EdgeInsets.only(top: 6.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            title: Text(title.toString()),
            subtitle: Text(description.toString()),
            trailing: Text(dateTime.toString()),
            onTap: () {},
          ),
        ));
  }
}
