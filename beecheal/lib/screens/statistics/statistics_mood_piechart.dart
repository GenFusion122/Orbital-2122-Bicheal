import 'package:beecheal/services/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../models/entry.dart';
import 'legend_widget.dart';

class EntryMoodPiechart extends StatefulWidget {
  const EntryMoodPiechart({Key? key}) : super(key: key);

  @override
  State<EntryMoodPiechart> createState() => _EntryMoodPiechart();
}

class _EntryMoodPiechart extends State<EntryMoodPiechart> {
  int touchedIndex = -1;
  List<DateTime> positiveDates = [];
  List<DateTime> neutralDates = [];
  List<DateTime> negativeDates = [];
  static const Color positiveColor = Color(0xFF96F355);
  static const Color neutralColor = Colors.grey;
  static const Color negativeColor = Color(0xFFF25849);
  bool datesAreFilled = false;

  void _fillDateLists(List<Entry> entryList) {
    if (datesAreFilled == false && entryList.isNotEmpty) {
      Map<DateTime, List<double>> dateMap = {};
      for (Entry e in entryList) {
        if (dateMap[DateUtils.dateOnly(e.getDate())] == null) {
          dateMap[DateUtils.dateOnly(e.getDate())] = [0, 0];
        }
        dateMap[DateUtils.dateOnly(e.getDate())]![0]++;
        dateMap[DateUtils.dateOnly(e.getDate())]![1] += e.getSentiment();
      }
      for (DateTime date in dateMap.keys) {
        double mood = dateMap[date]![1] / dateMap[date]![0];
        if (mood >= (1 / 3)) {
          positiveDates.add(DateUtils.dateOnly(date));
        } else if (mood > -(1 / 3) && mood < (1 / 3)) {
          neutralDates.add(DateUtils.dateOnly(date));
        } else {
          negativeDates.add(DateUtils.dateOnly(date));
        }
      }
      datesAreFilled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: StreamBuilder(
          stream: DatabaseService().entries,
          builder: (context, AsyncSnapshot<List<Entry>> snapshot) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Overall Mood",
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
                        aspectRatio: 1.64,
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
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Legend(
                          color: positiveColor,
                          text: 'Positive',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Legend(
                          color: neutralColor,
                          text: 'Neutral',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Legend(
                          color: negativeColor,
                          text: 'Negative',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ]),
                ),
              ]),
            ]);
          }),
    );
  }

  List<PieChartSectionData> showingSections(List<Entry> entryList) {
    _fillDateLists(entryList);
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final double positiveCount = positiveDates.length.toDouble();
      final double negativeCount = negativeDates.length.toDouble();
      final double neutralCount = neutralDates.length.toDouble();
      final double total = positiveCount + negativeCount + neutralCount;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: positiveColor,
            value: positiveCount,
            title: isTouched
                ? '${positiveCount.toStringAsFixed(0)} entries'
                : '${(positiveCount / total * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            color: neutralColor,
            value: neutralCount,
            title: isTouched
                ? '${neutralCount.toStringAsFixed(0)} entries'
                : '${(neutralCount / total * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 2:
          return PieChartSectionData(
            color: negativeColor,
            value: negativeCount,
            title: isTouched
                ? '${negativeCount.toStringAsFixed(0)} entries'
                : '${(negativeCount / total * 100).toStringAsFixed(1)}%',
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
