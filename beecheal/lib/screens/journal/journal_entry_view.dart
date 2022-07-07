import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_edit.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/database.dart';
import 'package:hexagon/hexagon.dart';
import 'package:intl/intl.dart';

class EntryView extends StatelessWidget {
  // const EntryView({Key? key}) : super(key: key);
  Entry entry;
  bool viewOnly;

  EntryView(this.entry, this.viewOnly);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.04)),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            DateFormat('yyyy-MM-dd hh:mm a').format(entry.getDate()).toString(),
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
                color: Color(0xff000000)),
          ),
          HexagonWidget.flat(
              width: MediaQuery.of(context).size.width * 0.075,
              elevation: 0.0,
              color: entry.getSentiment() == 1
                  ? Colors.green
                  : entry.getSentiment() == -1
                      ? Colors.red
                      : Colors.grey)
        ]),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Title',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Card(
            clipBehavior: Clip.none,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(entry.getTitle(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000))),
                ),
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Description',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Card(
            clipBehavior: Clip.none,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(entry.getDescription(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff000000))),
                ),
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Body',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff000000))),
          ),
        ),
        Expanded(
          child: Card(
              clipBehavior: Clip.none,
              margin: EdgeInsets.symmetric(vertical: 1.0),
              color: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Text(entry.getBody(),
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff000000))),
                  ),
                ),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: !viewOnly
              ? [
                  SizedBox(
                    width: 100.0,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFFFE98C)),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        child: Text('Edit',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000))),
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
                  ),
                  SizedBox(
                    width: 100.0,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFFFE98C)),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        child: Text('Delete',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000))),
                        onPressed: () {
                          DatabaseService().deleteUserEntry(entry.getId(),
                              entry.getTitle(), entry.getDate().toString());
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.of(context).pop();
                                });
                                return AlertDialog(
                                    title: Text(
                                        'Deleted ${entry.getTitle()} created on ${entry.getDate().toString()}'));
                              });
                        }),
                  )
                ]
              : [],
        )
      ]),
    );
  }
}
