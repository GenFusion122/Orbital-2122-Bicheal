import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/screens/wrapper.dart';
import 'package:beecheal/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:provider/provider.dart';

class journalEntries extends StatelessWidget {
  const journalEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('journals skreen'),
              centerTitle: true,
              backgroundColor: Colors.orange,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Icon(
                        Icons.home,
                        size: 26.0,
                      ),
                    ))
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orange)),
                        child: Text("create journal entry"),
                        onPressed: () async {}),
                  ],
                ),
              ],
            )));
  }
}
