import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_tile.dart';
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
    final entries = Provider.of<List<Entry>>(context);
    return ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return EntryTile(entries[index]);
        });
  }
}
