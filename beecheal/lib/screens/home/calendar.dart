import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class calendar extends StatelessWidget {
  const calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar skreen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SfCalendar(
        view: CalendarView.month,
      ),
    );
  }
}
