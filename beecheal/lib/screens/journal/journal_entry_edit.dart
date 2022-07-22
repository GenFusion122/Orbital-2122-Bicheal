import 'package:beecheal/custom%20widgets/hexagonalclipper.dart';
import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';

class EntryScreen extends StatefulWidget {
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
    if (!kIsWeb) {
      // Initialize sentiment analysis model
      platform
          .invokeMethod("Classify", <String, dynamic>{'string': 'initialize'});
    }
  }

  @override
  Widget build(BuildContext context) {
    // dialog for editing entries
    return AlertDialog(
        contentPadding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.02)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // entry title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0.0,
                            MediaQuery.of(context).size.height * 0.005,
                            0.0,
                            0.0),
                        child: Text('Title', style: viewHeaderTextStyle),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: TextFormField(
                          key: Key("journalTitleField"),
                          maxLength: 50,
                          style: viewBodyTextStyle,
                          initialValue: widget.entry.getTitle(),
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          decoration: textInputDecorationFormField,
                          validator: (val) =>
                              val!.isNotEmpty ? null : 'Please enter a title',
                          onChanged: (val) {
                            setState(() => widget.entry.setTitle(val));
                          }),
                    ),
                    // entry description
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0.0,
                            MediaQuery.of(context).size.height * 0.005,
                            0.0,
                            0.0),
                        child: Text('Description', style: viewHeaderTextStyle),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: TextFormField(
                          key: Key("journalDescriptionField"),
                          maxLength: 100,
                          style: viewBodyTextStyle,
                          initialValue: widget.entry.getDescription(),
                          cursorColor: Theme.of(context).colorScheme.onPrimary,
                          decoration: textInputDecorationFormField,
                          validator: (val) => val!.isNotEmpty
                              ? null
                              : 'Please enter a description',
                          onChanged: (val) {
                            setState(() => widget.entry.setDescription(val));
                          }),
                    ),
                    // entry body
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0.0,
                            MediaQuery.of(context).size.height * 0.005,
                            0.0,
                            0.0),
                        child: Text('Body', style: viewHeaderTextStyle),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 180.0),
                        child: SingleChildScrollView(
                          child: TextFormField(
                              key: Key("journalBodyField"),
                              style: viewBodyTextStyle,
                              initialValue: widget.entry.getBody(),
                              cursorColor:
                                  Theme.of(context).colorScheme.onPrimary,
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
                              }),
                        ),
                      ),
                    ),
                    // buttons
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              elevation:
                                  MaterialStateProperty.resolveWith<double>(
                                      (states) => 0)),
                          child:
                              Text(widget.textPrompt, style: buttonTextStyle),
                          onPressed: () async {
                            // conducts sentiment analysis on entry body
                            if (_formkey.currentState!.validate()) {
                              List prediction = [0, 0];
                              if (!kIsWeb) {
                                // mobile version
                                prediction = await Classify();
                              }
                              widget.entry.setSentiment(prediction[0]);
                              // dialog for confirming/changing sentiment predicted
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      if (!kIsWeb) {
                                        return ClipPath(
                                            clipper: HexagonalClipper(),
                                            child: Material(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                child: Center(
                                                    child: Container(
                                                        alignment:
                                                            FractionalOffset(
                                                                0.5, 0.6),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'BzB thinks that you are feeling:',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.045,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    (prediction[0] ==
                                                                            -1
                                                                        ? 'Negative'
                                                                        : prediction[0] ==
                                                                                0
                                                                            ? 'Neutral'
                                                                            : 'Positive'),
                                                                    style: TextStyle(
                                                                        fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                        fontWeight: FontWeight.w900,
                                                                        color: prediction[0] == -1
                                                                            ? Colors.red
                                                                            : prediction[0] == 0
                                                                                ? Colors.grey
                                                                                : Colors.green)),
                                                              ),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'with ${prediction[1]}% confidence',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.045,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10.0),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'I feel:',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.045,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onPrimary),
                                                                  )),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                      children: [
                                                                        Text(
                                                                            'Negative',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.04,
                                                                              fontWeight: FontWeight.w900,
                                                                            )),
                                                                        IconButton(
                                                                            onPressed:
                                                                                (() {
                                                                              setState(() {
                                                                                widget.entry.setSentiment(-1);
                                                                              });
                                                                            }),
                                                                            icon: HexagonWidget.flat(
                                                                                width: MediaQuery.of(context).size.width * 0.2,
                                                                                elevation: 0.0,
                                                                                color: (widget.entry.getSentiment() == -1) ? Colors.red : Colors.grey.withOpacity(0.4))),
                                                                      ]),
                                                                  Column(
                                                                      children: [
                                                                        Text(
                                                                            'Neutral',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.04,
                                                                              fontWeight: FontWeight.w900,
                                                                            )),
                                                                        IconButton(
                                                                            onPressed:
                                                                                (() {
                                                                              setState(() {
                                                                                widget.entry.setSentiment(0);
                                                                              });
                                                                            }),
                                                                            icon: HexagonWidget.flat(
                                                                                width: MediaQuery.of(context).size.width * 0.2,
                                                                                elevation: 0.0,
                                                                                color: (widget.entry.getSentiment() == 0) ? Colors.grey : Colors.grey.withOpacity(0.4))),
                                                                      ]),
                                                                  Column(
                                                                      children: [
                                                                        Text(
                                                                            'Positive',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.04,
                                                                              fontWeight: FontWeight.w900,
                                                                            )),
                                                                        IconButton(
                                                                            onPressed:
                                                                                (() {
                                                                              setState(() {
                                                                                widget.entry.setSentiment(1);
                                                                              });
                                                                            }),
                                                                            icon: HexagonWidget.flat(
                                                                                width: MediaQuery.of(context).size.width * 0.2,
                                                                                elevation: 0.0,
                                                                                color: (widget.entry.getSentiment() == 1) ? Colors.green : Colors.grey.withOpacity(0.4))),
                                                                      ])
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(18.0),
                                                                        )),
                                                                        backgroundColor: MaterialStateProperty.all(Theme.of(context)
                                                                            .colorScheme
                                                                            .primaryContainer),
                                                                        elevation:
                                                                            MaterialStateProperty.resolveWith<double>((states) =>
                                                                                0)),
                                                                child: Text(
                                                                    'Confirm',
                                                                    style:
                                                                        buttonTextStyle),
                                                                onPressed: () {
                                                                  // updates entry in database
                                                                  DatabaseService().updateUserEntry(
                                                                      widget
                                                                          .entry
                                                                          .getId(),
                                                                      widget
                                                                          .entry
                                                                          .getTitle(),
                                                                      widget
                                                                          .entry
                                                                          .getDate(),
                                                                      widget
                                                                          .entry
                                                                          .getDescription(),
                                                                      widget
                                                                          .entry
                                                                          .getBody(),
                                                                      widget
                                                                          .entry
                                                                          .getSentiment());
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              )
                                                            ])))));
                                      } else {
                                        // web version
                                        // dialog for choosing sentiment
                                        return AlertDialog(
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Let BzB know how you are feeling:',
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary),
                                                  ),
                                                ),
                                                SizedBox(height: 10.0),
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'I feel:',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.045,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary),
                                                    )),
                                                SizedBox(height: 5.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(children: [
                                                      Text('Negative',
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          )),
                                                      IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              widget.entry
                                                                  .setSentiment(
                                                                      -1);
                                                            });
                                                          }),
                                                          icon: HexagonWidget.flat(
                                                              width: 35,
                                                              elevation: 0.0,
                                                              color: (widget
                                                                          .entry
                                                                          .getSentiment() ==
                                                                      -1)
                                                                  ? Colors.red
                                                                  : Colors.grey
                                                                      .withOpacity(
                                                                          0.4))),
                                                    ]),
                                                    Column(children: [
                                                      Text('Neutral',
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          )),
                                                      IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              widget.entry
                                                                  .setSentiment(
                                                                      0);
                                                            });
                                                          }),
                                                          icon: HexagonWidget.flat(
                                                              width: 35,
                                                              elevation: 0.0,
                                                              color: (widget
                                                                          .entry
                                                                          .getSentiment() ==
                                                                      0)
                                                                  ? Colors.grey
                                                                  : Colors.grey
                                                                      .withOpacity(
                                                                          0.4))),
                                                    ]),
                                                    Column(children: [
                                                      Text('Positive',
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          )),
                                                      IconButton(
                                                          onPressed: (() {
                                                            setState(() {
                                                              widget.entry
                                                                  .setSentiment(
                                                                      1);
                                                            });
                                                          }),
                                                          icon: HexagonWidget.flat(
                                                              width: 35,
                                                              elevation: 0.0,
                                                              color: (widget
                                                                          .entry
                                                                          .getSentiment() ==
                                                                      1)
                                                                  ? Colors.green
                                                                  : Colors.grey
                                                                      .withOpacity(
                                                                          0.4))),
                                                    ])
                                                  ],
                                                ),
                                                SizedBox(height: 5.0),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                      elevation:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                      double>(
                                                                  (states) =>
                                                                      0)),
                                                  child: Text('Confirm',
                                                      style: buttonTextStyle),
                                                  onPressed: () {
                                                    // updates entry in database
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
                                                  },
                                                )
                                              ]),
                                        );
                                      }
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
  Future<List> Classify() async {
    var sendMap = <String, dynamic>{
      'string': widget.entry.getBody(),
    };
    List result = await platform.invokeMethod("Classify", sendMap);
    return result;
  }
}
