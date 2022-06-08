import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';

class StackedBarchart extends StatefulWidget {
  const StackedBarchart({Key? key}) : super(key: key);

  @override
  State<StackedBarchart> createState() => _StackedBarchart();
}

class _StackedBarchart extends State<StackedBarchart> {
  final Color bottom = Color.fromARGB(255, 0, 102, 255);
  final Color middle = Color.fromARGB(251, 255, 230, 0);
  final Color top = Color.fromARGB(255, 172, 1, 1);

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10);
    String text;
    text = DateFormat('EEEE')
        .format(DateTime.now().subtract(Duration(days: value.toInt())))
        .toString()
        .substring(0, 3);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      color: Color(
        0xff939393,
      ),
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService().tasks,
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          return AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    barTouchData: BarTouchData(
                      enabled: true,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: bottomTitles,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: const Color(0xffe7e8ec),
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    groupsSpace: 16,
                    barGroups: getData(snapshot.data ?? []),
                  ),
                ),
              ),
            ),
          );
        });
  }

  double countCompleted(List<Task> taskList) {
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

  double countUncompleted(List<Task> taskList) {
    double i = 0;
    for (Task task in taskList) {
      if (task.getCompletedOn().year == 2999) {
        i++;
      }
    }
    return i;
  }

  double countLateCompleted(List<Task> taskList) {
    double i = 0;
    for (Task task in taskList) {
      if (task.getCompletedOn().isAfter(task.getDate())) {
        i++;
      }
    }
    return i;
  }

  List<BarChartGroupData> getData(List<Task> taskList) {
    List<BarChartGroupData> barChartList = [];
    //A mapping where the bucket is the date and data is the task
    Map<DateTime, List<Task>> dateMapping = {};

    //iterates through all tasks and assigns it to the correct bucket
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].getCompletedOn().year != 2999) {
        //completed tasks
        if (dateMapping[DateUtils.dateOnly(taskList[i].getCompletedOn())] ==
            null) {
          dateMapping[DateUtils.dateOnly(taskList[i].getCompletedOn())] = [];
        }
        dateMapping[DateUtils.dateOnly(taskList[i].getCompletedOn())]
            ?.add(taskList[i]);
      } else {
        //uncompleted tasks
        if (dateMapping[DateUtils.dateOnly(taskList[i].getDate())] == null) {
          dateMapping[DateUtils.dateOnly(taskList[i].getDate())] = [];
        }
        dateMapping[DateUtils.dateOnly(taskList[i].getDate())]
            ?.add(taskList[i]);
      }
    }
    print(dateMapping);
    for (int i = 0; i < 7; i++) {
      DateTime date =
          DateUtils.dateOnly(DateTime.now().subtract(Duration(days: i)));
      double completed = countCompleted(dateMapping[date] ?? []);
      double uncompleted = countUncompleted(dateMapping[date] ?? []);
      double latecompleted = countLateCompleted(dateMapping[date] ?? []);
      print(latecompleted);
      barChartList.add(BarChartGroupData(x: i, barsSpace: 4, barRods: [
        BarChartRodData(
            toY: dateMapping[date]?.length.toDouble() ?? 0.0,
            width: 30,
            rodStackItems: [
              BarChartRodStackItem(0, completed, bottom),
              BarChartRodStackItem(
                  completed, (uncompleted + completed), middle),
              BarChartRodStackItem((uncompleted + completed),
                  dateMapping[date]?.length.toDouble() ?? 0.0, top)
            ])
      ]));
    }

    return barChartList;
  }
}
