import 'package:beecheal/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class calendar extends StatelessWidget {
  const calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('calendar skreen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(MaterialPageRoute(builder: (context) => Home()));
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
