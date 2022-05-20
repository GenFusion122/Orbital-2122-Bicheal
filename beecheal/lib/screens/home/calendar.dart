import 'package:flutter/material.dart';

class calendar extends StatelessWidget {
  const calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar skreen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Align(
            alignment: Alignment.center, child: Text('<insert calendar here>')),
      ),
    );
  }
}
