import 'package:beecheal/screens/statistics/statistics.dart';
import 'package:beecheal/services/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'legend_widget.dart';

class TaskStatsPieChart extends StatefulWidget {
  const TaskStatsPieChart({Key? key}) : super(key: key);

  @override
  State<TaskStatsPieChart> createState() => _TaskStatsPieChart();
}

class _TaskStatsPieChart extends State<TaskStatsPieChart> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService().tasks,
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // if you need this
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Overall Productivity",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Row(children: [
              Expanded(
                  child: AspectRatio(
                      aspectRatio: 1.4,
                      child: PieChart(
                        PieChartData(
                            pieTouchData: PieTouchData(touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(snapshot.data ?? [])),
                      ))),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Legend(
                      color: Color.fromARGB(255, 150, 243, 85),
                      text: 'On Time',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Legend(
                      color: Color.fromARGB(255, 227, 242, 72),
                      text: 'Uncompleted',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Legend(
                      color: Color.fromARGB(255, 242, 88, 73),
                      text: 'Late',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    )
                  ])
            ])
          ]);
        });
  }

  List<PieChartSectionData> showingSections(List<Task> taskList) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      double total = taskList.length.toDouble();
      double completed = ((Statistics.countCompleted(taskList) / total) * 100);
      double uncompleted =
          ((Statistics.countUncompleted(taskList) / total) * 100);
      double lateCompleted =
          ((Statistics.countLateCompleted(taskList) / total) * 100);

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color.fromARGB(255, 150, 243, 85),
            value: Statistics.countCompleted(taskList),
            title: isTouched
                ? '${Statistics.countCompleted(taskList).toStringAsFixed(0)} tasks'
                : '${completed.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            color: Color.fromARGB(255, 227, 242, 72),
            value: Statistics.countUncompleted(taskList),
            title: isTouched
                ? '${Statistics.countUncompleted(taskList).toStringAsFixed(0)} tasks'
                : '${uncompleted.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 2:
          return PieChartSectionData(
            color: Color.fromARGB(255, 242, 88, 73),
            value: Statistics.countLateCompleted(taskList),
            title: isTouched
                ? '${Statistics.countLateCompleted(taskList).toStringAsFixed(0)} tasks'
                : '${lateCompleted.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        default:
          throw Error();
      }
    });
  }
}
