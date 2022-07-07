import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/screens/statistics/statistics.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/task.dart';

class TaskStatsStackedBarchart extends StatefulWidget {
  DateTime focusedDate;
  TaskStatsStackedBarchart({required this.focusedDate});
  @override
  State<TaskStatsStackedBarchart> createState() => _TaskStatsStackedBarchart();
}

class _TaskStatsStackedBarchart extends State<TaskStatsStackedBarchart> {
  final Color bottom = Color.fromARGB(255, 150, 243, 85);
  final Color middle = Color.fromARGB(255, 227, 242, 72);
  final Color top = Color.fromARGB(255, 242, 88, 73);

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold);
    String text;
    text = DateFormat('EEEE')
        .format(widget.focusedDate.subtract(Duration(days: value.toInt())))
        .toString()
        .substring(0, 3);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (double.parse(meta.formattedValue) % 1 != 0) {
      return Container();
    }
    const style = TextStyle(
        color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  int touchedIndex = -1;
  BarTouchTooltipData touchToolTips() {
    return BarTouchTooltipData(
        tooltipBgColor: Theme.of(context).colorScheme.primary,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          double from = rod.rodStackItems[touchedIndex].fromY;
          double to = rod.rodStackItems[touchedIndex].toY;
          return BarTooltipItem(
            (to - from).toStringAsFixed(0),
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService().tasks,
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          return Column(
            children: [
              Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Daily Productivity",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: touchToolTips(),
                        touchCallback: (event, touchResponse) {
                          touchedIndex =
                              touchResponse?.spot?.touchedStackItemIndex ?? -1;
                          setState(() {});
                        },
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
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 2 == 0,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey,
                          strokeWidth: 2,
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
            ],
          );
        });
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
          //initialize the list
          dateMapping[DateUtils.dateOnly(taskList[i].getCompletedOn())] = [];
        }
        dateMapping[DateUtils.dateOnly(taskList[i].getCompletedOn())]
            ?.add(taskList[i]);
      } else {
        //uncompleted tasks
        if (dateMapping[DateUtils.dateOnly(taskList[i].getDate())] == null) {
          //initialize the list
          dateMapping[DateUtils.dateOnly(taskList[i].getDate())] = [];
        }
        dateMapping[DateUtils.dateOnly(taskList[i].getDate())]
            ?.add(taskList[i]);
      }
    }
    for (int i = 6; i >= 0; i--) {
      DateTime date =
          DateUtils.dateOnly(widget.focusedDate.subtract(Duration(days: i)));
      double completed = Statistics.countCompleted(dateMapping[date] ?? []);
      double uncompleted = Statistics.countUncompleted(dateMapping[date] ?? []);
      double latecompleted =
          Statistics.countLateCompleted(dateMapping[date] ?? []);
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
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5)))
      ]));
    }

    return barChartList;
  }
}
