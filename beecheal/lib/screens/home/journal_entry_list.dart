import 'package:beecheal/screens/home/journal_entry_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EntryList extends StatefulWidget {
  // const EntryList({Key? key}) : super(key: key);

  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<QuerySnapshot?>(context);
    return ListView.builder(
        itemCount: entries?.docs.toList().length,
        itemBuilder: (context, index) {
          return EntryTile(entry: entries?.docs.toList()[index]);
        });
  }
}
