import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/occasion.dart';

import '../../../services/database.dart';
import 'calendar_occasion_tile.dart';

class CalendarOccasionTab extends StatefulWidget {
  const CalendarOccasionTab({Key? key}) : super(key: key);

  @override
  State<CalendarOccasionTab> createState() => _CalendarOccasionTab();
}

class _CalendarOccasionTab extends State<CalendarOccasionTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final ValueNotifier<List<Occasion>> _selectedEvents;

  List<Occasion> _getEventsForDay(DateTime day, List<Occasion> occasionList) {
    List<Occasion> todaysEvents = [];

    for (int i = 0; i < occasionList.length; i++) {
      if (DateUtils.dateOnly(occasionList[i].getDate()) ==
          DateUtils.dateOnly(day)) {
        todaysEvents.add(occasionList[i]);
      }
    }
    return todaysEvents;
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents =
        ValueNotifier(_getEventsForDay(_selectedDay ?? DateTime.now(), []));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService().occasion,
        builder: (context, AsyncSnapshot<List<Occasion>> snapshot) {
          return Column(children: <Widget>[
            TableCalendar<Occasion>(
              focusedDay: _focusedDay,
              firstDay: DateTime(1900),
              lastDay: DateTime(2999),
              calendarFormat: _calendarFormat,
              eventLoader: (day) => _getEventsForDay(day, snapshot.data ?? []),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = selectedDay;
                    _rangeStart = null; // Important to clean those
                    _rangeEnd = null;
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  });
                  _selectedEvents.value =
                      _getEventsForDay(selectedDay, snapshot.data ?? []);
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              calendarBuilders:
                  CalendarBuilders(markerBuilder: ((context, day, events) {
                return events.isEmpty
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.only(left: 40),
                        decoration: BoxDecoration(
                            color: Colors.orange[400],
                            border: Border.all(
                                color: Color.fromARGB(255, 255, 167, 38),
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          events.length.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ));
              })),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 5,
              child: ValueListenableBuilder<List<Occasion>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    List<Occasion> items = _getEventsForDay(
                        _selectedDay ?? DateTime.now(), snapshot.data ?? []);
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return OccasionTile(items[index]);
                        });
                  }),
            ),
          ]);
        }
        /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[400],
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CalendarEditScreen(
                  occasion: Occasion(
                      "",
                      "",
                      DateTime(
                          _selectedDay!.year,
                          _selectedDay!.month,
                          _selectedDay!
                              .day), //passes a date with "blank" timings
                      ""),
                  textPrompt: 'Create',
                  selectedDay: _selectedDay,
                );
              });
        },
      )*/
        );
  }
}
