import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:beecheal/models/occasion.dart';

class calendar extends StatefulWidget {
  const calendar({Key? key}) : super(key: key);

  @override
  State<calendar> createState() => _calendarState();
}

class _calendarState extends State<calendar> {
  List<Occasion> occassions = [
    Occasion("Do Laundry", DateTime.now().add(const Duration(days: 5)),
        "use the blue detergent"),
    Occasion("Hang the clothes", DateTime.now().add(const Duration(days: 10)),
        "open a new packet of pegs"),
    Occasion("Cook dinner", DateTime.now().add(const Duration(days: 2)),
        "pasta sounds really good")
  ];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final ValueNotifier<List<Occasion>> _selectedEvents;
  List<Occasion> _getEventsForDay(DateTime day) {
    List<Occasion> o = [];
    for (int i = 0; i < occassions.length; i++) {
      if (DateUtils.dateOnly(occassions[i].date) == DateUtils.dateOnly(day)) {
        o.add(occassions[i]);
      }
    }
    return o;
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('calendar skreen'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: <Widget>[
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(1900),
              lastDay: DateTime(2050),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _rangeStart = null; // Important to clean those
                    _rangeEnd = null;
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  });
                  _selectedEvents.value = _getEventsForDay(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 5,
              child: ValueListenableBuilder<List<Occasion>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print('${value[index]}'),
                              title: Text('${value[index].title}'),
                            ),
                          );
                        });
                  }),
            )
          ],
        ));
  }
}
