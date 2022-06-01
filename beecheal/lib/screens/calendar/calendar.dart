import 'package:beecheal/custom%20widgets/listtemplate.dart';
import 'package:beecheal/screens/calendar/calendar_edit.dart';
import 'package:beecheal/screens/calendar/calendar_occasion_tile.dart';
import 'package:beecheal/screens/calendar/calendar_occasions_list.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:beecheal/models/occasion.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar skreen'),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
      ),
      body: StreamBuilder(
          stream: DatabaseService().occasion,
          builder: (context, AsyncSnapshot<List<Occasion>> snapshot) {
            return Column(children: <Widget>[
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
                    _selectedEvents.value =
                        _getEventsForDay(selectedDay, snapshot.data ?? []);
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) {
                  return _getEventsForDay(day, snapshot.data ?? []);
                },
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
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[400],
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CalenderEditScreen(
                  occasion:
                      Occasion("", "", _selectedDay ?? DateTime.now(), ""),
                  textPrompt: 'Create',
                  selectedDay: _selectedDay,
                );
              });
        },
      ),
    );
  }
}
