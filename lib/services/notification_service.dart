import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;import 'dart:math';


class NoticiationApi {

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'Detail', importance: Importance.max),
        iOS: IOSNotificationDetails(sound: 'notification_sound.wav'));
  }

  static void cancelAll() {
    _notifications.cancelAll();

}

  static Future showTimedNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {




    _notifications.zonedSchedule(
      Random().nextInt(9000000),
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true ,
    );
  }

  static Future showNotifications(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    var details = await _notificationDetails;

    _notifications.show(id, title, body, await _notificationDetails());
  }
}
