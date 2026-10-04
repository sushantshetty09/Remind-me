import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:remember/core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  Future<void> initialize({
    Future<void> Function(NotificationResponse response)? onNotificationResponse,
  }) async {
    if (_initialized) return;

    // 1. Initialize timezones
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // 2. Android Initialization Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // 3. Initialize plugin with action callbacks
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (onNotificationResponse != null) {
          onNotificationResponse(response);
        }
        selectNotificationStream.add(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // 4. Create Notification Channels
    await _createNotificationChannels();

    _initialized = true;
  }

  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel remindersChannel = AndroidNotificationChannel(
      AppConstants.channelReminders,
      'Reminders',
      description: 'Main scheduled reminder notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel escalationsChannel = AndroidNotificationChannel(
      AppConstants.channelEscalations,
      'Escalating Alerts',
      description: 'Persistent re-alerts for commitments and high-priority reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel briefingsChannel = AndroidNotificationChannel(
      AppConstants.channelBriefings,
      'Briefings & Reviews',
      description: 'Daily morning briefing and evening review notifications',
      importance: Importance.defaultImportance,
    );

    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(remindersChannel);
      await androidImplementation.createNotificationChannel(escalationsChannel);
      await androidImplementation.createNotificationChannel(briefingsChannel);
    }
  }

  /// Schedule exact local notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateUtc,
    String channelId = AppConstants.channelReminders,
    String? payload,
    List<AndroidNotificationAction>? actions,
    bool fullScreenIntent = false,
  }) async {
    final tz.TZDateTime tzScheduledDate =
        tz.TZDateTime.from(scheduledDateUtc, tz.local);

    if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return; // Never schedule in past
    }

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == AppConstants.channelEscalations
          ? 'Escalating Alerts'
          : 'Reminders',
      channelDescription: 'Reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: fullScreenIntent,
      actions: actions ??
          const [
            AndroidNotificationAction('ACTION_DONE', 'Done'),
            AndroidNotificationAction('ACTION_SNOOZE_10M', 'Snooze 10m'),
            AndroidNotificationAction('ACTION_SNOOZE_1H', 'Snooze 1h'),
            AndroidNotificationAction('ACTION_TOMORROW', 'Tomorrow'),
          ],
    );

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Cancel notification by ID
  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get pending notification requests
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Show immediate test notification
  Future<void> showTestNotification({required int id, required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.channelReminders,
      'Test Channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Background handler for notification action button taps
}
