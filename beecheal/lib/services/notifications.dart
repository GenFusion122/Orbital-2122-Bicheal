import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as timeZone;
import 'package:timezone/timezone.dart' as timeZone;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
    ));
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
    if (initScheduled) {
      timeZone.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      timeZone.setLocalLocation(timeZone.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static void showScheduledNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime scheduledDate}) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        timeZone.TZDateTime.from(scheduledDate, timeZone.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

  static void showDailyScheduledNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required Time time,
          required DateTime scheduledDate}) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(time),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static void showWeeklyScheduledNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required Time time,
          required List<int> days,
          required DateTime scheduledDate}) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(time, days: days),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static timeZone.TZDateTime _scheduleDaily(Time time) {
    final now = timeZone.TZDateTime.now(timeZone.local);
    final scheduleDate = timeZone.TZDateTime(timeZone.local, now.year,
        now.month, now.day, time.hour, time.minute, time.second);
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  static timeZone.TZDateTime _scheduleWeekly(Time time,
      {required List<int> days}) {
    timeZone.TZDateTime scheduleDate = _scheduleDaily(time);
    while (!days.contains(scheduleDate.weekday)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate;
  }
}
