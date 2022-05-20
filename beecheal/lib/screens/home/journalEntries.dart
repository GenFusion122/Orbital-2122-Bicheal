import 'package:flutter/material.dart';

class journalEntries extends StatelessWidget {
  const journalEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('journals skreen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Align(
            alignment: Alignment.center,
            child: Text('<insert journal list here>')),
      ),
    );
  }
}
