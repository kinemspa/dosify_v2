import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz; // New import

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledDate) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(android: AndroidNotificationDetails('dose_channel', 'Dose Reminders', importance: Importance.high)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    ); // Removed uiLocalNotificationDateInterpretation (deprecated/removed in v17+)
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}