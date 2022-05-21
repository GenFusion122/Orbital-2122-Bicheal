import 'package:beecheal/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beecheal/models/userid.dart';

import '../../custom widgets/custombuttons.dart';

class Occasion {
  String title;
  DateTime date;
  String description;
  Occasion(this.title, this.date, this.description);
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  List<Occasion> occassions = [
    Occasion("Do Laundry", DateTime.now(), "use the blue detergent"),
    Occasion("Hang the clothes", DateTime.now(), "open a new packet of pegs"),
    Occasion("Cook dinner", DateTime.now(), "pasta sounds really good")
  ];
  Widget todoListTemplate(Occasion o) {
    return Card(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(o.title, style: TextStyle(fontSize: 18, color: Colors.black)),
            Row(children: [
              Text(o.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              Spacer(),
              Text("${o.date.day}-${o.date.month}-${o.date.year}",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            ])
          ],
        ));
  }

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
              style: TextButton.styleFrom(primary: Colors.brown[500]),
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
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: occassions.map((x) => todoListTemplate(x)).toList(),
                )),
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
