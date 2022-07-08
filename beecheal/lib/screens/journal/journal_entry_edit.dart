import 'package:beecheal/custom%20widgets/hexagonalclipper.dart';
import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:beecheal/services/database.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';

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
                              List prediction = await Classify();
                              widget.entry.setSentiment(prediction[0]);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return ClipPath(
                                          clipper: HexagonalClipper(),
                                          child: Material(
                                              color: Color(0xFFFFC95C),
                                              child: Center(
                                                  child: Container(
                                                      alignment:
                                                          FractionalOffset(
                                                              0.5, 0.6),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
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
                                                                    color: Color(
                                                                        0xff000000)),
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
                                                                    color: Color(
                                                                        0xff000000)),
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
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.045,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Color(
                                                                          0xff000000)),
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
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.04,
                                                                            fontWeight:
                                                                                FontWeight.w900,
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
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.04,
                                                                            fontWeight:
                                                                                FontWeight.w900,
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
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.04,
                                                                            fontWeight:
                                                                                FontWeight.w900,
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
                                                                      shape: MaterialStateProperty.all<
                                                                              RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      )),
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(Color(
                                                                              0xFFFFE98C)),
                                                                      elevation:
                                                                          MaterialStateProperty.resolveWith<double>((states) =>
                                                                              0)),
                                                              child: Text(
                                                                  'Confirm',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff000000))),
                                                              onPressed: () {
                                                                DatabaseService().updateUserEntry(
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
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return EntryView(
                                                                          widget
                                                                              .entry,
                                                                          false);
                                                                    });
                                                              },
                                                            )
                                                          ])))));
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
    print(sendMap);
    print("TESTING CLASSIFY");
    print("Prediction:");
    List result = await platform.invokeMethod("Classify", sendMap);
    print(result);
    return result;
  }
}
