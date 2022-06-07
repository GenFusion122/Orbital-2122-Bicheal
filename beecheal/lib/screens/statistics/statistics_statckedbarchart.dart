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
  final Color dark = Color.fromARGB(255, 0, 102, 255);
  final Color normal = Color.fromARGB(251, 255, 230, 0);
  final Color light = Color.fromARGB(255, 172, 1, 1);

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10);
    String text;
    text = DateFormat('EEEE')
        .format(DateTime.now().subtract(Duration(days: value.toInt())))
        .toString();
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
            child: Expanded(
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
            ),
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
        dateMapping[taskList[i].getCompletedOn()]?.add(taskList[i]);
      } else {
        //uncompleted tasks
        dateMapping[taskList[i].getDate()]?.add(taskList[i]);
      }
    }

    for (int i = 0; i < 7; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
    }
    return barChartList; //TODO: REFLECT THE PROPER DATA USING THE MAP
    /*return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: 50,
              width: 50,
              rodStackItems: [
                BarChartRodStackItem(0, 13, dark),
                BarChartRodStackItem(13, 25, normal),
                BarChartRodStackItem(25, 50, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
    ];*/
  }
}
