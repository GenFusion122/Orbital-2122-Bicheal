import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';

import 'package:beecheal/services/database.dart';

class EntryScreen extends StatefulWidget {
  // const EntryScreen({Key? key}) : super(key: key);

  Entry entry;
  String textPrompt;

  EntryScreen({required this.entry, required this.textPrompt});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: TextFormField(
                        initialValue: widget.entry.title,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Title'),
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Please enter a title',
                        onChanged: (val) {
                          setState(() => widget.entry.title = val);
                          // print(widget.titleInitial);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: TextFormField(
                        initialValue: widget.entry.description,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Description'),
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Please enter a description',
                        onChanged: (val) {
                          setState(() => widget.entry.description = val);
                          // print(widget.descriptionInitial);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 180.0),
                      child: SingleChildScrollView(
                        child: TextFormField(
                            initialValue: widget.entry.body,
                            textAlignVertical: TextAlignVertical.top,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 7,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Body'),
                            validator: (val) =>
                                val!.isNotEmpty ? null : 'Please enter a body',
                            onChanged: (val) {
                              setState(() => widget.entry.body = val);
                              // print(widget.bodyInitial);
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 255, 202, 0))),
                        child: Text(widget.textPrompt),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            if (widget.textPrompt == 'Create') {
                              DatabaseService().updateUserEntry(
                                  widget.entry.title,
                                  DateTime.now(),
                                  widget.entry.description,
                                  widget.entry.body);
                              print(DateTime.now());
                              Navigator.of(context).pop();
                            } else {
                              DatabaseService().updateUserEntry(
                                  widget.entry.title,
                                  widget.entry.date,
                                  widget.entry.description,
                                  widget.entry.body);
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EntryView(widget.entry);
                                  });
                            }
                          }
                        }),
                  )
                ],
              ))
        ]));
  }
}
