import 'package:beecheal/screens/home/calendar.dart';
import 'package:beecheal/screens/home/journalEntries.dart';
import 'package:beecheal/screens/home/statistics.dart';
import 'package:beecheal/screens/wrapper.dart';
import 'package:beecheal/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beecheal/models/userid.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final uid = _auth.curruid();

    return MaterialApp(
        home: Scaffold(
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                  child: Text("statistics"),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Statistics()));
                  }),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                  child: Text("calendar"),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => calendar()));
                  }),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                  child: Text("journal"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => journalEntries()));
                  })
            ],
          ),
        ],
      ),
    ));
  }

  signoutAndRedirect(context) async {
    await _auth.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Wrapper()));
  }
}
