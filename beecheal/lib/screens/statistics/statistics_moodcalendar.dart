import 'package:beecheal/models/entry.dart';
import 'package:beecheal/screens/journal/journal_entry_edit.dart';
import 'package:beecheal/screens/journal/journal_entry_view.dart';
import 'package:beecheal/services/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexagon/hexagon.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/src/intl/date_format.dart';
import '../journal/journal_entry_tile.dart';
import 'legend_widget.dart';

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
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final ValueNotifier<List<Entry>> _selectedEvents;
  List<DateTime> positiveDates = [];
  List<DateTime> neutralDates = [];
  List<DateTime> negativeDates = [];
  static const Color positiveColor = Colors.lightGreen;
  static const Color neutralColor = Colors.grey;
  static const Color negativeColor = Colors.redAccent;
  bool datesAreFilled = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents =
        ValueNotifier(_getEntriesForDay(_selectedDay ?? DateTime.now(), []));
  }

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

  List<Entry> _getEntriesForDay(DateTime day, List<Entry> entryList) {
    List<Entry> todaysEvents = [];

    for (int i = 0; i < entryList.length; i++) {
      if (DateUtils.dateOnly(entryList[i].getDate()) ==
          DateUtils.dateOnly(day)) {
        todaysEvents.add(entryList[i]);
      }
    }
    return todaysEvents;
  }

  Color _boxColor(DateTime day) {
    return positiveDates.contains(DateUtils.dateOnly(day))
        ? Colors.lightGreen
        : negativeDates.contains(DateUtils.dateOnly(day))
            ? Colors.redAccent
            : neutralDates.contains(DateUtils.dateOnly(day))
                ? Colors.grey
                : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().entries,
      builder: (context, AsyncSnapshot<List<Entry>> snapshot) {
        return Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TableCalendar<Entry>(
                  headerStyle: HeaderStyle(formatButtonVisible: false),
                  focusedDay: _focusedDay,
                  firstDay: DateTime(1900),
                  lastDay: DateTime(2999),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  availableGestures: AvailableGestures.horizontalSwipe,
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
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
                          _getEntriesForDay(selectedDay, snapshot.data ?? []);
                    }
                  },
                  calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, focusedDay) {
                    return HexagonWidget.flat(
                      width: 80,
                      color: _boxColor(day),
                      child: Center(
                          child: HexagonWidget.flat(
                        width: 20,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Center(
                            child: Text('${day.day}',
                                style: const TextStyle(color: Colors.black))),
                      )),
                    );
                  }, headerTitleBuilder: ((context, day) {
                    return Center(
                      child: Text(
                          DateFormat('MMMM yyyy').format(day).toString(),
                          style: Theme.of(context).textTheme.headline1),
                    );
                  }), selectedBuilder: ((context, day, selectedDay) {
                    return HexagonWidget.flat(
                      width: 80,
                      color: Color(0xFFC67C00),
                      child: Center(
                          child: HexagonWidget.flat(
                        width: 40,
                        color: DateUtils.dateOnly(day) ==
                                DateUtils.dateOnly(DateTime.now())
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                        child: Text(day.day.toString()),
                      )),
                    );
                  }), markerBuilder: (context, day, focusedDay) {
                    _fillDateLists(snapshot.data ?? []);
                    for (DateTime d in positiveDates) {
                      if (DateUtils.dateOnly(day) == d) {
                        return calendarIndicator(day, positiveColor);
                      }
                    }
                    for (DateTime d in neutralDates) {
                      if (DateUtils.dateOnly(day) == d) {
                        return calendarIndicator(day, neutralColor);
                      }
                    }
                    for (DateTime d in negativeDates) {
                      if (DateUtils.dateOnly(day) == d) {
                        return calendarIndicator(day, negativeColor);
                      }
                    }
                  })),
            ),
            Padding(
              padding: EdgeInsets.only(right: 4, left: 4),
              child: ValueListenableBuilder<List<Entry>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    List<Entry> items = _getEntriesForDay(
                        _selectedDay ?? DateTime.now(), snapshot.data ?? []);
                    return Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return EntryTile(items[index], true);
                          }),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }

  Widget calendarIndicator(DateTime day, Color color) {
    return Stack(
      children: [
        HexagonWidget.flat(
          width: 80,
          color: DateUtils.dateOnly(day) ==
                  DateUtils.dateOnly(_selectedDay ?? DateTime.now())
              ? Color(0xFFC67C00)
              : Theme.of(context).colorScheme.primary,
          child: Center(
              child: HexagonWidget.flat(
            width: 40,
            color: DateUtils.dateOnly(day) == DateUtils.dateOnly(DateTime.now())
                ? Theme.of(context).colorScheme.secondary
                : Colors.white,
            child: Text(day.day.toString()),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 30),
          child: HexagonWidget.flat(
            width: 20,
            color: DateUtils.dateOnly(day) ==
                    DateUtils.dateOnly(_selectedDay ?? DateTime.now())
                ? Color(0xFFC67C00)
                : Theme.of(context).colorScheme.primary,
            child: Center(
                child: HexagonWidget.flat(
              width: 15,
              color: color,
            )),
          ),
        ),
      ],
    );
  }
}
