import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsAPI {
  static final notification = FlutterLocalNotificationsPlugin();

  static Future _notificationsDetail() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_1',
        'channel_name_1',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/todo_icon');
    const setting = InitializationSettings(android: android);

    await notification.initialize(
      setting,
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notification.show(
      id,
      title,
      body,
      await _notificationsDetail(),
      payload: payload,
    );
  }

  static Future showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    try {
      await notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationsDetail(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    } on Exception catch (e) {
      throw Exception("Error on scheduled: $e");
    }
  }
}
