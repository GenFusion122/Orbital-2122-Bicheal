import 'package:beecheal/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beecheal/models/userid.dart';

import '../../custom widgets/custombuttons.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final uid = _auth.curruid();
    return Scaffold(
        appBar: AppBar(
        title: Text('Home!'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign Out'),
              onPressed: () async {
                await _auth.signOut();
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Card(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("To do list here"),
            ),
          ),
          Expanded(
              flex: 2,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                  ])),
          Expanded(
              flex: 2,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                  ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OrangeNavButton("/statistics", "statistics", context),
              OrangeNavButton("/calendar", "calendar", context),
              OrangeNavButton("/journalEntries", "journal", context),
            ],
          ),
        ],
      ),
    );
  }
}
