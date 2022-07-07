import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'dart:async';
import 'package:flutter/services.dart';

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
  static const platform = MethodChannel('model.classifier/inference');

  void initState() {
    // Initialize model
    platform
        .invokeMethod("Classify", <String, dynamic>{'string': 'initialize'});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.04)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0.0,
                            MediaQuery.of(context).size.height * 0.005,
                            0.0,
                            0.0),
                        child: Text('Title',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff000000))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: TextFormField(
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff000000)),
                          initialValue: widget.entry.getTitle(),
                          cursorColor: Color(0xff000000),
                          decoration: textInputDecorationFormField,
                          validator: (val) =>
                              val!.isNotEmpty ? null : 'Please enter a title',
                          onChanged: (val) {
                            setState(() => widget.entry.setTitle(val));
                          }),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0.0,
                            MediaQuery.of(context).size.height * 0.005,
                            0.0,
                            0.0),
                        child: Text('Description',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff000000))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: TextFormField(
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff000000)),
                          initialValue: widget.entry.getDescription(),
                          cursorColor: Color(0xff000000),
                          decoration: textInputDecorationFormField,
                          validator: (val) => val!.isNotEmpty
                              ? null
                              : 'Please enter a description',
                          onChanged: (val) {
                            setState(() => widget.entry.setDescription(val));
                            // print(widget.descriptionInitial);
                          }),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0.0,
                            MediaQuery.of(context).size.height * 0.005,
                            0.0,
                            0.0),
                        child: Text('Body',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff000000))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 180.0),
                        child: SingleChildScrollView(
                          child: TextFormField(
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xff000000)),
                              initialValue: widget.entry.getBody(),
                              cursorColor: Color(0xff000000),
                              textAlignVertical: TextAlignVertical.top,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 7,
                              decoration: textInputDecorationFormField,
                              validator: (val) => val!.isNotEmpty
                                  ? null
                                  : 'Please enter a body',
                              onChanged: (val) {
                                setState(() => widget.entry.setBody(val));
                                // print(widget.bodyInitial);
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFFFE98C)),
                              elevation:
                                  MaterialStateProperty.resolveWith<double>(
                                      (states) => 0)),
                          child: Text(widget.textPrompt,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000))),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              int prediction = await Classify();
                              widget.entry.setSentiment(prediction);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 243, 224),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'How are you feeling as you write this entry?',
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4 *
                                                            0.0875),
                                                  ),
                                                ),
                                                SizedBox(height: 20.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(children: [
                                                      Text('Negative'),
                                                      IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              widget.entry
                                                                  .setSentiment(
                                                                      -1);
                                                            });
                                                          }),
                                                          icon: Icon(
                                                              Icons
                                                                  .circle_rounded,
                                                              color: (widget
                                                                          .entry
                                                                          .getSentiment() ==
                                                                      -1)
                                                                  ? Colors.red
                                                                  : Colors.grey[
                                                                      200])),
                                                    ]),
                                                    Column(children: [
                                                      Text('Neutral'),
                                                      IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              widget.entry
                                                                  .setSentiment(
                                                                      0);
                                                            });
                                                          }),
                                                          icon: Icon(
                                                              Icons
                                                                  .circle_rounded,
                                                              color: (widget
                                                                          .entry
                                                                          .getSentiment() ==
                                                                      0)
                                                                  ? Colors.grey
                                                                  : Colors.grey[
                                                                      200])),
                                                    ]),
                                                    Column(children: [
                                                      Text('Positive'),
                                                      IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              widget.entry
                                                                  .setSentiment(
                                                                      1);
                                                            });
                                                          }),
                                                          icon: Icon(
                                                              Icons
                                                                  .circle_rounded,
                                                              color: (widget
                                                                          .entry
                                                                          .getSentiment() ==
                                                                      1)
                                                                  ? Colors.green
                                                                  : Colors.grey[
                                                                      200])),
                                                    ])
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'BzB feels that you are feeling ',
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4 *
                                                                0.0875)),
                                                    Text(
                                                        (prediction == -1
                                                            ? 'negative'
                                                            : prediction == 0
                                                                ? 'neutral'
                                                                : 'positive'),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4 *
                                                                0.0875,
                                                            color: prediction ==
                                                                    -1
                                                                ? Colors.red
                                                                : prediction ==
                                                                        0
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .green))
                                                  ],
                                                ),
                                                SizedBox(height: 20.0),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      202,
                                                                      40))),
                                                  child: Text('Confirm'),
                                                  onPressed: () {
                                                    DatabaseService()
                                                        .updateUserEntry(
                                                            widget.entry
                                                                .getId(),
                                                            widget.entry
                                                                .getTitle(),
                                                            widget.entry
                                                                .getDate(),
                                                            widget.entry
                                                                .getDescription(),
                                                            widget.entry
                                                                .getBody(),
                                                            widget.entry
                                                                .getSentiment());
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return EntryView(
                                                              widget.entry,
                                                              false);
                                                        });
                                                  },
                                                )
                                              ]));
                                    });
                                  });
                            }
                          }),
                    )
                  ],
                ))
          ],
        ));
  }

  // Performs inference on body
  Future<int> Classify() async {
    var sendMap = <String, dynamic>{
      'string': widget.entry.getBody(),
    };
    print(sendMap);
    print("TESTING CLASSIFY");
    print("Prediction:");
    int result = await platform.invokeMethod("Classify", sendMap);
    print(result);
    return result;
  }
}
