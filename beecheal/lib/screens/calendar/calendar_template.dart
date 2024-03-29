import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:beecheal/screens/todo_list/todo_task_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../models/occasion.dart';
import '../../../services/database.dart';
import 'calendar_edit.dart';
import 'occasion/calendar_occasion_tile.dart';
import 'package:hexagon/hexagon.dart';
import 'package:intl/intl.dart';

class CalendarTemplate<T extends Occasion> extends StatefulWidget {
  List<T> snapshotList;
  CalendarTemplate({required this.snapshotList});
  @override
  State<CalendarTemplate<T>> createState() => _CalendarTemplate<T>();
}

class _CalendarTemplate<T extends Occasion> extends State<CalendarTemplate<T>> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late final ValueNotifier<List<T>> _selectedEvents;

  List<T> _getEventsForDay(DateTime day, List<T> genericList) {
    List<T> todaysEvents = [];

    for (int i = 0; i < genericList.length; i++) {
      if (DateUtils.dateOnly(genericList[i].getDate()) ==
          DateUtils.dateOnly(day)) {
        todaysEvents.add(genericList[i]);
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
    bool isWidescreen =
        MediaQuery.of(context).size.width >= MediaQuery.of(context).size.height;
    double width = isWidescreen
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.width;
    Widget calendarFont(String text, bool isOutside, bool isTiny) {
      double fontSize = isWidescreen ? 15 * (width / 500) : 17;
      if (isTiny) {
        fontSize = fontSize * 0.6;
      }
      return Center(
        child: Text(
          text,
          style: TextStyle(
              color: isOutside ? Colors.grey : Colors.black,
              fontSize: fontSize),
        ),
      );
    }

    double outerHexagonSize =
        isWidescreen ? width / 10 : MediaQuery.of(context).size.height / 15;
    double innerHexagonSize =
        isWidescreen ? width / 15 : MediaQuery.of(context).size.height / 20;

    return Stack(children: [
      Flex(
          direction: isWidescreen ? Axis.horizontal : Axis.vertical,
          children: <Widget>[
            SizedBox(
              width: width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
                child: TableCalendar<T>(
                  shouldFillViewport: isWidescreen ? true : false,
                  headerStyle: HeaderStyle(formatButtonVisible: false),
                  focusedDay: _focusedDay,
                  firstDay: DateTime(1900),
                  lastDay: DateTime(2999),
                  calendarFormat: _calendarFormat,
                  eventLoader: (day) =>
                      _getEventsForDay(day, widget.snapshotList),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  availableGestures: AvailableGestures.horizontalSwipe,
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
                          _getEventsForDay(selectedDay, widget.snapshotList);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                      outsideBuilder: (context, day, focusedDay) {
                    return calendarFont(day.day.toString(), true, false);
                  }, defaultBuilder: (context, day, focusedDay) {
                    return calendarFont(day.day.toString(), false, false);
                  }, headerTitleBuilder: ((context, day) {
                    return Center(
                      child: Text(
                          DateFormat('MMMM yyyy').format(day).toString(),
                          style: Theme.of(context).textTheme.headline1),
                    );
                  }), todayBuilder: (context, day, focusedDay) {
                    return HexagonWidget.flat(
                        width: innerHexagonSize,
                        color: Theme.of(context).colorScheme.secondary,
                        child: calendarFont(day.day.toString(), false, false));
                  }, selectedBuilder: ((context, day, selectedDay) {
                    return Align(
                      alignment: Alignment.center,
                      child: HexagonWidget.flat(
                        width: outerHexagonSize,
                        color: Color(0xFFC67C00),
                        child: Center(
                            child: HexagonWidget.flat(
                          width: innerHexagonSize,
                          color: DateUtils.dateOnly(day) ==
                                  DateUtils.dateOnly(DateTime.now())
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.white,
                          child: calendarFont(day.day.toString(), false, false),
                        )),
                      ),
                    );
                  }), markerBuilder: ((context, day, events) {
                    return events.isEmpty
                        ? SizedBox()
                        : Stack(
                            children: [
                              HexagonWidget.flat(
                                width: outerHexagonSize,
                                color: DateUtils.dateOnly(day) ==
                                        DateUtils.dateOnly(
                                            _selectedDay ?? DateTime.now())
                                    ? Color(0xFFC67C00)
                                    : Theme.of(context).colorScheme.primary,
                                child: HexagonWidget.flat(
                                  width: innerHexagonSize,
                                  color: DateUtils.dateOnly(day) ==
                                          DateUtils.dateOnly(DateTime.now())
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  child: calendarFont(
                                      day.day.toString(), false, false),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: isWidescreen
                                        ? MediaQuery.of(context).size.width *
                                            0.029
                                        : 30,
                                    left: isWidescreen
                                        ? MediaQuery.of(context).size.width *
                                            0.015
                                        : 20),
                                child: HexagonWidget.flat(
                                  width: outerHexagonSize / 3,
                                  color: DateUtils.dateOnly(day) ==
                                          DateUtils.dateOnly(
                                              _selectedDay ?? DateTime.now())
                                      ? Color(0xFFC67C00)
                                      : Theme.of(context).colorScheme.primary,
                                  child: HexagonWidget.flat(
                                    width: innerHexagonSize / 3,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    child: Center(
                                      child: calendarFont(
                                          events.length.toString(),
                                          false,
                                          true),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  })),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 4, left: 4),
                child: ValueListenableBuilder<List<T>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      List<T> items = _getEventsForDay(
                          _selectedDay ?? DateTime.now(), widget.snapshotList);
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            if (T.toString() == "Task") {
                              return TaskTile(items[index]);
                            }
                            return OccasionTile(items[index]);
                          });
                    }),
              ),
            )
          ]),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20, bottom: 50),
          child: FloatingActionButton(
              tooltip: "Create New Event",
              key: Key("calendarCreateEventButton"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: HexagonWidget.flat(
                  width: 100,
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.add, size: 30)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (T.toString() == "Task") {
                        return CalendarEditScreen<Task>(
                            occasion: Task(
                                "",
                                "",
                                DateTime(
                                    _selectedDay!.year,
                                    _selectedDay!.month,
                                    _selectedDay!
                                        .day), //passes a date with "blank" timings
                                "",
                                Task.incompletePlaceholder),
                            textPrompt: 'Create',
                            selectedDay: _selectedDay ?? DateTime.now());
                      }
                      return CalendarEditScreen<Occasion>(
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
                        selectedDay: _selectedDay ?? DateTime.now(),
                      );
                    });
              }),
        ),
      )
    ]);
  }
}
