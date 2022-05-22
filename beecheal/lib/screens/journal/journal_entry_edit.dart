import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/database.dart';

class EntryScreen extends StatefulWidget {
  // const EntryScreen({Key? key}) : super(key: key);

  String? titleInitial;
  String? descriptionInitial;
  String? bodyInitial;
  String? dateTimeInitial;
  String textPrompt;

  EntryScreen(
      {this.titleInitial,
      this.descriptionInitial,
      this.bodyInitial,
      this.dateTimeInitial,
      required this.textPrompt});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

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
                        initialValue: widget.titleInitial,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Title'),
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Please enter a title',
                        onChanged: (val) {
                          setState(() => widget.titleInitial = val);
                          // print(widget.titleInitial);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: TextFormField(
                        initialValue: widget.descriptionInitial,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Description'),
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Please enter a description',
                        onChanged: (val) {
                          setState(() => widget.descriptionInitial = val);
                          // print(widget.descriptionInitial);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 180.0),
                      child: SingleChildScrollView(
                        child: TextFormField(
                            initialValue: widget.bodyInitial,
                            textAlignVertical: TextAlignVertical.top,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 7,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Body'),
                            validator: (val) =>
                                val!.isNotEmpty ? null : 'Please enter a body',
                            onChanged: (val) {
                              setState(() => widget.bodyInitial = val);
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
                            if (widget.dateTimeInitial == null) {
                              DatabaseService(uid: _auth.curruid()).updateUserEntry(
                                  widget.titleInitial,
                                  '${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()} ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}',
                                  widget.descriptionInitial,
                                  widget.bodyInitial);
                              Navigator.of(context).pop();
                            } else {
                              DatabaseService(uid: _auth.curruid())
                                  .updateUserEntry(
                                      widget.titleInitial,
                                      widget.dateTimeInitial,
                                      widget.descriptionInitial,
                                      widget.bodyInitial);
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EntryView(
                                      title: widget.titleInitial,
                                      description: widget.descriptionInitial,
                                      body: widget.bodyInitial,
                                      dateTime: widget.dateTimeInitial,
                                    );
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
