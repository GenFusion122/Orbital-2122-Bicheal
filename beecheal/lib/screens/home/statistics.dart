import 'package:beecheal/main.dart';
import 'package:beecheal/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('stats skreen'),
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
            body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange)),
                            onPressed: () {},
                            child: Text("mood")),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange)),
                            onPressed: () {},
                            child: Text("productivity")),
                      ]),
                ]))));
  }
}
