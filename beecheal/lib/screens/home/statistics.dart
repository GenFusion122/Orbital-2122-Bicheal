import 'package:beecheal/screens/home/home.dart';
import 'package:flutter/material.dart';

import '../../custom widgets/custombuttons.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('stats skreen'),
          centerTitle: true,
          backgroundColor: Colors.orange[400],
        ),
        body:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OrangeNormalButton("mood"),
                OrangeNormalButton("productivity"),
              ]),
        ]));
  }
}
