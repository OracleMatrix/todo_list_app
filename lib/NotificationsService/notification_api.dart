import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsAPI {
  // شناسایی و ساخت نمونه
  static final notification = FlutterLocalNotificationsPlugin();

  // شنود کردن به تغییرات استرینگی با پکیج rxdart
  // static final onNotifications = BehaviorSubject<String?>();

  // برای دانلود لینک عکس ها
  // static Future _downloadFile(String uri) async => (await get(Uri.parse(uri)));

  static Future _notificationsDetail() async {
    // برای نمایش عکس هست bigicon برای کنار body هست و large icon برای عکس بزرگ زیر نوتیف هست
    // const _url1 =
    //     'https://cdn.bama.ir/uploads//BamaImages/News/a7edbd4d-9b76-4164-94eb-b173c729f3fa/Content/FotoJet%20-%202024-07-03T112228.498%20(1)638556026565441031.jpg';
    // const _url2 =
    //     'https://cdn.bama.ir/uploads//BamaImages/News/a7edbd4d-9b76-4164-94eb-b173c729f3fa/Content/saipa638590503219418241.jpg';
    //
    // final bigIcon = await _downloadFile(_url1);
    // final largeIcon = await _downloadFile(_url2);
    //
    // final styleInformation = BigPictureStyleInformation(
    //     ByteArrayAndroidBitmap(bigIcon),
    //     largeIcon: ByteArrayAndroidBitmap(largeIcon));

    // دیتیل های نوتیف ها مثل نمایش عکس یا دکمه و...
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_1',
        'channel_name_1',
        importance: Importance.high,
        priority: Priority.high,
        // styleInformation: styleInformation,
        // actions: [
        //   AndroidNotificationAction('id_open', 'Open',
        //       showsUserInterface: true),
        //   AndroidNotificationAction('id_close', 'Close',
        //       showsUserInterface: true),
        // ],
      ),
    );
  }

  // شناسایی دکمه ها و آیدی هاشون
  // static void _receiveNotification(NotificationResponse? payload) {
  //   String? _actionId = payload!.actionId;
  //   String _actionResult = ' actionID => ';
  //   if (_actionId != null) {
  //     _actionResult += _actionId;
  //   } else {
  //     _actionResult += 'Null';
  //   }
  //
  //   onNotifications.add(payload.payload! + _actionResult);
  // }

  // برای راه اندازی نوتیف ها و تنظیمات اولیه
  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/todo_icon');
    const setting = InitializationSettings(android: android);

    await notification.initialize(
      setting,
      // برای واکنش به کلیک شدن نوتیف
      // onDidReceiveNotificationResponse: _receiveNotification,
    );
  }

  // نمایش لحظه ای نوتیف با تایتل و بادی مشخص payload هم برای واکنش به کلیک هست
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

//   نمایش نوتیف زمانی و کاستوم شده
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
