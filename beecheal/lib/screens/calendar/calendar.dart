import 'package:beecheal/models/task.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:intl/intl.dart';
import 'calendar_template.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<bool> isSelected = [true, false, false];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              elevation: 0,
              title: Icon(Icons.calendar_month_outlined,
                  color: Colors.black, size: 45),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Theme.of(context).colorScheme.secondary),
                  tabs: [
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Events",
                              style: Theme.of(context).textTheme.headline1)),
                    ),
                    Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Tasks",
                                style: Theme.of(context).textTheme.headline1)))
                  ])),
          body: TabBarView(children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              body: StreamBuilder(
                stream: DatabaseService().occasion,
                builder: (context, AsyncSnapshot<List<Occasion>> snapshot) {
                  return CalendarTemplate<Occasion>(
                      snapshotList: snapshot.data ?? []);
                },
              ),
            ),
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              body: StreamBuilder(
                stream: DatabaseService().tasks,
                builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                  List<Task> currentValue = snapshot.data ?? [];
                  List<Task> completedList = [];
                  List<Task> inCompletedList = [];
                  for (int i = 0; i < (snapshot.data ?? []).length; i++) {
                    if (snapshot.data![i].getCompletedOn() ==
                        Task.incompletePlaceholder) {
                      inCompletedList.add(snapshot.data![i]);
                    } else {
                      completedList.add(snapshot.data![i]);
                    }
                  }
                  if (isSelected[0]) {
                    currentValue = snapshot.data ?? [];
                  } else if (isSelected[1]) {
                    currentValue = completedList;
                  } else {
                    currentValue = inCompletedList;
                  }
                  return Column(
                    children: [
                      SizedBox(height: 2),
                      Expanded(
                        flex: 1,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            color: Theme.of(context).colorScheme.secondary,
                            child: ToggleButtons(
                              onPressed: (int index) {
                                setState(() {
                                  for (int buttonIndex = 0;
                                      buttonIndex < isSelected.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      isSelected[buttonIndex] = true;
                                    } else {
                                      isSelected[buttonIndex] = false;
                                    }
                                  }
                                });
                              },
                              borderColor: Colors.transparent,
                              selectedBorderColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              isSelected: isSelected,
                              color: Colors.black,
                              selectedColor: Colors.black,
                              constraints: BoxConstraints.expand(
                                  width: constraints.maxWidth / 3.1),
                              children: [
                                toggleButtonWidget(constraints.maxWidth / 3.1,
                                    isSelected[0], "Default"),
                                toggleButtonWidget(constraints.maxWidth / 3.1,
                                    isSelected[1], "Completed"),
                                toggleButtonWidget(constraints.maxWidth / 3.1,
                                    isSelected[2], "Incompleted"),
                              ],
                            ),
                          );
                        }),
                      ),
                      Expanded(
                          flex: 20,
                          child: CalendarTemplate<Task>(
                              snapshotList: currentValue)),
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }

  Widget toggleButtonWidget(double width, bool selected, String text) {
    return Container(
        width: width,
        decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(child: Text(text)));
  }
}
