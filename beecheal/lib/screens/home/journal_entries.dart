import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'journal_entry_list.dart';

class JournalEntries extends StatefulWidget {
  @override
  State<JournalEntries> createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  // const journalEntries({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  final _formkey = GlobalKey<FormState>();

  // text field state
  String? title = '';
  String? description = '';
  String? body = '';
  String? error = '';
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
                      return AlertDialog(
                          backgroundColor: Colors.orange[100],
                          content: Stack(children: <Widget>[
                            Positioned(
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() => title = '');
                                  setState(() => description = '');
                                  setState(() => body = '');
                                },
                              ),
                            ),
                            Form(
                                key: _formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: TextFormField(
                                          decoration: textInputDecoration
                                              .copyWith(hintText: 'Title'),
                                          validator: (val) => val!.isNotEmpty
                                              ? null
                                              : 'Please enter a title',
                                          onChanged: (val) {
                                            setState(() => title = val);
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText: 'Description'),
                                          validator: (val) => val!.isNotEmpty
                                              ? null
                                              : 'Please enter a description',
                                          onChanged: (val) {
                                            setState(() => description = val);
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: Container(
                                        constraints:
                                            BoxConstraints(maxHeight: 180.0),
                                        child: SingleChildScrollView(
                                          child: TextFormField(
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              minLines: 7,
                                              decoration: textInputDecoration
                                                  .copyWith(hintText: 'Body'),
                                              validator: (val) =>
                                                  val!.isNotEmpty
                                                      ? null
                                                      : 'Please enter a body',
                                              onChanged: (val) {
                                                setState(() => body = val);
                                              }),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: ElevatedButton(
                                          child: Text('Create'),
                                          onPressed: () {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              DatabaseService(
                                                      uid: _auth.curruid())
                                                  .updateUserEntry(
                                                      title,
                                                      DateTime.now().toString(),
                                                      description,
                                                      body);
                                              Navigator.of(context).pop();
                                              setState(() => title = '');
                                              setState(() => description = '');
                                              setState(() => body = '');
                                            }
                                          }),
                                    )
                                  ],
                                ))
                          ]));
                    });
              },
              child: const Icon(Icons.book_rounded))),
    );
  }
}
