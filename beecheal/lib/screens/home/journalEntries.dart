import 'package:beecheal/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
                },
                child: Icon(
                  Icons.home,
                  size: 26.0,
                ),
              ))
        ],
      ),
      body: Container(
        child: Align(
            alignment: Alignment.center, child: Text('<insert calendar here>')),
      ),
    ));
  }
}
