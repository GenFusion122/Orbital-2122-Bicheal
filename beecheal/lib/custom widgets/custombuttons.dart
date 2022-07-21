import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

// for page navigation
class OrangeNavButton extends StatelessWidget {
  final String location;
  final String text;
  final BuildContext context;
  const OrangeNavButton(this.location, this.text, this.context, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: HexagonWidget.flat(
            width: 60,
            color: Color(0xFFFFDD4B),
            child: Transform.rotate(
              angle: text == 'statistics' ? 350 * pi / 180 : 0,
              child: Icon(
                  text == 'statistics'
                      ? Icons.pie_chart_outline_rounded
                      : text == 'calendar'
                          ? Icons.calendar_month_outlined
                          : text == 'journal'
                              ? Icons.book_outlined
                              : Icons.circle_outlined,
                  color: Colors.black,
                  size: 45),
            )),
        onPressed: () {
          Navigator.pushNamed(context, location);
        });
  }
}
