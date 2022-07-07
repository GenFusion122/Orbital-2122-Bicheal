import 'dart:math';

import 'package:beecheal/screens/statistics/statistics_mood_piechart.dart';
import 'package:beecheal/screens/statistics/statistics_moodcalendar.dart';
import 'package:beecheal/screens/statistics/statistics_productivity_piechart.dart';
import 'package:beecheal/screens/statistics/statistics_statckedbarchart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
  static double countCompleted(List<Task> taskList) {
    double i = 0;
    for (Task task in taskList) {
      if (task.getCompletedOn().isBefore(task.getDate()) ||
          DateUtils.dateOnly(task.getCompletedOn()) ==
              DateUtils.dateOnly(task.getDate())) {
        i++;
      }
    }
    return i;
  }

  static double countUncompleted(List<Task> taskList) {
    double i = 0;
    for (Task task in taskList) {
      if (task.getCompletedOn().year == 2999) {
        i++;
      }
    }
    return i;
  }

  static double countLateCompleted(List<Task> taskList) {
    double i = 0;
    for (Task task in taskList) {
      if (task.getCompletedOn().isAfter(task.getDate()) &&
          task.getCompletedOn().year != 2999) {
        i++;
      }
    }
    return i;
  }
}

class _StatisticsState extends State<Statistics> {
  DateTime focusedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Transform.rotate(
                  angle: 350 * pi / 180,
                  child: Icon(Icons.pie_chart_rounded,
                      color: Colors.black, size: 45)),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Theme.of(context).colorScheme.secondary),
                  tabs: [
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Productivity",
                              style: Theme.of(context).textTheme.headline1)),
                    ),
                    Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Mood",
                                style: Theme.of(context).textTheme.headline1)))
                  ])),
          body: TabBarView(children: [
            Container(
              color: Theme.of(context).colorScheme.secondary,
              child: ListView(children: [
                TaskStatsPieChart(),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      TaskStatsStackedBarchart(
                        focusedDate: focusedDate,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)),
                              onPressed: () {
                                setState(() {
                                  focusedDate =
                                      focusedDate.subtract(Duration(days: 7));
                                });
                              },
                              child: Icon(Icons.arrow_back)),
                          Text(
                              "Focused Date: ${DateFormat('dd MMMM').format(focusedDate)}"),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)),
                              onPressed: () {
                                setState(() {
                                  focusedDate =
                                      focusedDate.add(Duration(days: 7));
                                });
                              },
                              child: Icon(Icons.arrow_forward)),
                        ],
                      )
                    ]),
                  ),
                )
              ]),
            ),
            Container(
              color: Theme.of(context).colorScheme.secondary,
              child: ListView(
                children: [
                  EntryMoodPiechart(),
                  EntryMoodCalendar(),
                ],
              ),
            ),
          ])),
    );
  }
}
