import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_edit.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/database.dart';
import 'package:beecheal/services/auth.dart';

class EntryView extends StatelessWidget {
  // const EntryView({Key? key}) : super(key: key);
  Entry entry;

  EntryView(this.entry);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return AlertDialog(
        backgroundColor: Colors.orange[100],
        content: Stack(children: <Widget>[
          Positioned(
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
                alignment: Alignment.topRight,
                child: Text(entry.date.toString(),
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold))),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: 400.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(entry.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ),
                  ),
                )),
            Card(
                clipBehavior: Clip.none,
                margin: EdgeInsets.symmetric(vertical: 1.0),
                color: Color.fromARGB(255, 255, 243, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(entry.description,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14.0)),
                  ),
                )),
            Expanded(
              child: Card(
                  clipBehavior: Clip.none,
                  margin: EdgeInsets.symmetric(vertical: 1.0),
                  color: Color.fromARGB(255, 255, 243, 224),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child:
                            Text(entry.body, style: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 202, 0))),
                    child: Text('Edit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EntryScreen(
                              entry: entry,
                              textPrompt: 'Update',
                            );
                          });
                    }),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 202, 0))),
                    child: Text('Delete'),
                    onPressed: () {
                      DatabaseService()
                          .deleteUserEntry(entry.title, entry.date.toString());
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });
                            return AlertDialog(
                                title: Text(
                                    'Deleted ${entry.title} created on ${entry.date.toString()}'));
                          });
                    })
              ],
            )
          ]),
        ]));
    ;
  }
}
