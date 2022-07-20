import 'package:beecheal/custom%20widgets/constants.dart';
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
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.02)),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            DateFormat('yyyy-MM-dd hh:mm a').format(entry.getDate()).toString(),
            style: viewHeaderTextStyle,
          ),
          HexagonWidget.flat(
              width: 35,
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
            child: Text('Title', style: viewHeaderTextStyle),
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(entry.getTitle(),
                    softWrap: true, maxLines: 5, style: viewBodyTextStyle),
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Description', style: viewHeaderTextStyle),
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(entry.getDescription(),
                    softWrap: true, maxLines: 5, style: viewBodyTextStyle),
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.005, 0.0, 0.0),
            child: Text('Body', style: viewHeaderTextStyle),
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
                    child: Text(entry.getBody(), style: viewHeaderTextStyle),
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
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primaryContainer),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        child: Text('Edit', style: buttonTextStyle),
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
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primaryContainer),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        child: Text('Delete', style: buttonTextStyle),
                        onPressed: () {
                          DatabaseService().deleteUserEntry(entry.getId(),
                              entry.getTitle(), entry.getDate().toString());
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              elevation: 0.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              content: Text(
                                'Deleted ${entry.getTitle()} created on ${DateFormat('yyyy-MM-dd hh:mm a').format(entry.getDate()).toString()}',
                                style: popupTextStyle,
                              )));
                        }),
                  )
                ]
              : [],
        )
      ]),
    );
  }
}
