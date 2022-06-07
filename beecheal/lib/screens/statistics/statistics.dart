import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/screens/statistics/statistics_statckedbarchart.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('stats skreen'),
          centerTitle: true,
          backgroundColor: Colors.orange[400],
        ),
        body: Center(
            child: Column(
          children: <Widget>[StackedBarchart()],
        )));
  }
}
