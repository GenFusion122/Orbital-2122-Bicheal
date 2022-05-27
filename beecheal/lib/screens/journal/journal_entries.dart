import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'journal_entry_list.dart';
import 'journal_entry_edit.dart';

class JournalEntries extends StatefulWidget {
  @override
  State<JournalEntries> createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  // const journalEntries({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: _auth.curruid()).entries,
      initialData: null,
      child: Scaffold(
          appBar: AppBar(
            title: Text('journals skreen'),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.orange[400],
          ),
          body: EntryList(),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.amber[400],
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EntryScreen(textPrompt: 'Create');
                    });
              },
              child: const Icon(Icons.book_rounded))),
    );
  }
}
