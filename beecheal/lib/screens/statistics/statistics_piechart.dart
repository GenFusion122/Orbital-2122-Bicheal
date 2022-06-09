import 'package:beecheal/screens/statistics/statistics.dart';
import 'package:beecheal/services/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../../models/task.dart';

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
          return Row(children: [
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1,
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
                    color: Color.fromARGB(255, 48, 255, 65),
                    text: 'On Time',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Legend(
                    color: Color.fromARGB(250, 255, 242, 60),
                    text: 'Uncompleted',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Legend(
                    color: Color.fromARGB(255, 255, 1, 1),
                    text: 'Late',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ]),
          ]);
        });
  }

  List<PieChartSectionData> showingSections(List<Task> taskList) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      int total = taskList.length;
      double completed = ((Statistics.countCompleted(taskList) / total) * 100);
      double uncompleted =
          ((Statistics.countUncompleted(taskList) / total) * 100);
      double lateCompleted =
          ((Statistics.countLateCompleted(taskList) / total) * 100);

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color.fromARGB(255, 48, 255, 65),
            value: completed,
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
            color: Color.fromARGB(250, 255, 242, 60),
            value: uncompleted,
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
            color: Color.fromARGB(255, 255, 1, 1),
            value: lateCompleted,
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

class Legend extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Legend({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
