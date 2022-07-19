import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_tile.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import 'journal_entry_edit.dart';

class JournalEntries extends StatefulWidget {
  @override
  State<JournalEntries> createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  // const journalEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFE0B2),
        appBar: AppBar(
          title: Icon(Icons.book_outlined, color: Colors.black, size: 45),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005),
          child: StreamBuilder(
              stream: DatabaseService().entries,
              builder: (context, AsyncSnapshot<List<Entry>> snapshot) {
                return ListView.builder(
                    itemCount: Provider.of<List<Entry>>(context).length,
                    itemBuilder: (context, index) {
                      return EntryTile(
                          Provider.of<List<Entry>>(context)[index], false);
                    });
              }),
        ),
        floatingActionButton: FloatingActionButton(
          key: Key("journalCreateEntryButton"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: HexagonWidget.flat(
              width: 100,
              color: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.add, size: 30)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EntryScreen(
                      entry: Entry("", "", DateTime.now(), "", "", 0),
                      textPrompt: 'Create');
                });
          },
        ));
  }
}
