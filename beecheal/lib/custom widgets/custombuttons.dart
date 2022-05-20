import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrangeNavButton extends StatelessWidget {
  final String location;
  final String text;
  final BuildContext context;
  const OrangeNavButton(this.location, this.text, this.context, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
        child: Text(text),
        onPressed: () {
          Navigator.pushNamed(context, location);
        });
  }
}

class OrangeNormalButton extends StatelessWidget {
  final String text;
  const OrangeNormalButton(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
        child: Text(text),
        onPressed: () {});
  }
}
