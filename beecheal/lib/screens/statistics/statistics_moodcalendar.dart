import 'package:beecheal/models/entry.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:table_calendar/table_calendar.dart';

class EntryMoodCalendar extends StatefulWidget {
  const EntryMoodCalendar({Key? key}) : super(key: key);

  @override
  State<EntryMoodCalendar> createState() => _EntryMoodCalendar();
}

class _EntryMoodCalendar extends State<EntryMoodCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime> positiveDates = [];
  List<DateTime> neutralDates = [];
  List<DateTime> negativeDates = [];
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _fillDateLists(List<Entry> entryList) {
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
      if (mood == 1.0) {
        positiveDates.add(date);
      } else if (mood == 0.0) {
        neutralDates.add(date);
      } else {
        negativeDates.add(date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().entries,
      builder: (context, AsyncSnapshot<List<Entry>> snapshot) {
        return TableCalendar<Entry>(
            focusedDay: _focusedDay,
            firstDay: DateTime(1900),
            lastDay: DateTime(2999),
            calendarFormat: _calendarFormat,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarBuilders: CalendarBuilders(
                prioritizedBuilder: (context, day, focusedDay) {
              _fillDateLists(snapshot.data ?? []);
              for (DateTime d in positiveDates) {
                if (DateUtils.dateOnly(day) == DateUtils.dateOnly(d)) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }
              for (DateTime d in neutralDates) {
                if (DateUtils.dateOnly(day) == DateUtils.dateOnly(d)) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }
              for (DateTime d in negativeDates) {
                if (DateUtils.dateOnly(day) == DateUtils.dateOnly(d)) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }
            }));
      },
    );
  }
}
