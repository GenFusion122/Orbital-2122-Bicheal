import 'package:beecheal/models/task.dart';
import 'package:beecheal/services/database.dart';
import 'package:collection/collection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/occasion.dart';
import '../../services/notifications.dart';

class InitializeNotifications {
  static void initializeOccasionNotifications() async {
    List<Occasion> occList = await DatabaseService().occasion.first;
    for (Occasion o in occList) {
      String title = o.getTitle();
      String summedId = o.getId().codeUnits.join("");
      summedId = summedId.substring(0, 8);
      if (o.getDate().subtract(Duration(hours: 24)).isAfter(DateTime.now())) {
        NotificationService.showScheduledNotification(
            //day before
            id: int.parse('${summedId}0'),
            title: 'Event upcoming!',
            body: '$title is in 24 hours!',
            payload: '/calendar',
            scheduledDate: o.getDate().subtract(Duration(days: 1)));
      }
      if (o.getDate().isAfter(DateTime.now())) {
        NotificationService.showScheduledNotification(
            //on the dot
            id: int.parse('${summedId}1'),
            title: 'Event happening now!',
            body: '$title is happening now!',
            payload: '/calendar',
            scheduledDate: o.getDate());
      }
    }
  }

  static void initializeToDoNotifications() async {
    List<Task> taskList = await DatabaseService().tasks.first;
    for (Task t in taskList) {
      String title = t.getTitle();
      String summedId = t.getId().codeUnits.join("");
      summedId = summedId.substring(0, 8);
      if (t.getDate().subtract(Duration(hours: 24)).isAfter(DateTime.now())) {
        NotificationService.showScheduledNotification(
            id: int.parse('${summedId}0'),
            title: 'Task due soon!',
            body: '$title is in 24 hours!',
            payload: '/calendar',
            scheduledDate: t.getDate().subtract(Duration(days: 1)));
      }
      if (t.getDate().isAfter(DateTime.now())) {
        NotificationService.showScheduledNotification(
            id: int.parse('${summedId}1'),
            title: 'Task due now!',
            body: '$title is due right now!',
            payload: '/home',
            scheduledDate: t.getDate());
      }
    }
  }

  static Future<bool> notificationIsEmpty() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(pendingNotificationRequests.length);
    return pendingNotificationRequests.isEmpty;
  }
}
