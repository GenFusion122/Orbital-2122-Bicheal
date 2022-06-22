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
  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(text: "Productivity"),
          Tab(text: "Mood"),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Text('stats skreen'),
              centerTitle: true,
              backgroundColor: Colors.orange[400],
              bottom: PreferredSize(
                preferredSize: _tabBar.preferredSize,
                child: Material(
                  color: Color.fromARGB(255, 255, 202, 40),
                  child: _tabBar,
                ),
              )),
          body: TabBarView(children: [
            ListView(children: [
              Card(child: TaskStatsPieChart()),
              Card(
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.amber[400])),
                            onPressed: () {
                              setState(() {
                                focusedDate =
                                    focusedDate.subtract(Duration(days: 7));
                              });
                            },
                            child: Icon(Icons.arrow_back)),
                        Text(
                            "Focused Date: ${DateFormat('yy-MM-dd').format(focusedDate)}"),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.amber[400])),
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
            ListView(
              children: [
                Card(child: EntryMoodPiechart()),
                Card(child: EntryMoodCalendar()),
              ],
            ),
          ])),
    );
  }
}
