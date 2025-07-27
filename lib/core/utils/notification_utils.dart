import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final _logger = Logger();

  static Future<void> init() async {
    _logger.d('Initializing notifications');
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
    // Request notification permissions for Android 13+
    await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    _logger.d('Notifications initialized');
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledDate) async {
    _logger.d('Scheduling notification: id=$id, title=$title, at=$scheduledDate');
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'dose_channel',
          'Dose Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelNotification(int id) async {
    _logger.d('Canceling notification: id=$id');
    await _notifications.cancel(id);
  }
}