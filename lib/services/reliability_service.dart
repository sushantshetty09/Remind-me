import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:remember/data/repositories/reminder_repository.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/scheduler_service.dart';

class ReliabilityStatus {
  final bool notificationPermission;
  final bool exactAlarmPermission;
  final bool batteryOptimizationDisabled;

  const ReliabilityStatus({
    required this.notificationPermission,
    required this.exactAlarmPermission,
    required this.batteryOptimizationDisabled,
  });

  bool get isFullyReliable =>
      notificationPermission && exactAlarmPermission;
}

class ReliabilityService {
  final NotificationService _notificationService;
  final SchedulerService _schedulerService;
  final ReminderRepository _reminderRepo;

  ReliabilityService(
    this._notificationService,
    this._schedulerService,
    this._reminderRepo,
  );

  /// Check all Android permissions & system states
  Future<ReliabilityStatus> getReliabilityStatus() async {
    final notifStatus = await ph.Permission.notification.status;
    final exactAlarmStatus = await ph.Permission.scheduleExactAlarm.status;
    final batteryOptStatus = await ph.Permission.ignoreBatteryOptimizations.status;

    return ReliabilityStatus(
      notificationPermission: notifStatus.isGranted,
      exactAlarmPermission: exactAlarmStatus.isGranted,
      batteryOptimizationDisabled: batteryOptStatus.isGranted,
    );
  }

  /// Request missing permissions
  Future<void> requestNotificationPermission() async {
    await ph.Permission.notification.request();
  }

  Future<void> requestExactAlarmPermission() async {
    await ph.Permission.scheduleExactAlarm.request();
  }

  Future<void> requestIgnoreBatteryOptimization() async {
    await ph.Permission.ignoreBatteryOptimizations.request();
  }

  /// Open Android App Settings
  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  /// Send a test notification in 10 seconds
  Future<void> sendTestNotificationIn10Seconds() async {
    final scheduledTimeUtc = DateTime.now().toUtc().add(const Duration(seconds: 10));
    await _notificationService.scheduleNotification(
      id: 99900,
      title: '🔔 Reliability Test',
      body: 'Your notification system is working reliably!',
      scheduledDateUtc: scheduledTimeUtc,
    );
  }

  /// App Launch Health Check: Compare DB active reminders vs pending notifications and repair
  Future<bool> performHealthCheckAndRepair() async {
    final pendingNotifications = await _notificationService.getPendingNotifications();
    final activeReminders = await _reminderRepo.getActiveReminders();

    final now = DateTime.now().toUtc();
    final futureActiveCount =
        activeReminders.where((r) => r.datetimeUtc != null && r.datetimeUtc!.isAfter(now)).length;

    if (futureActiveCount > 0 && pendingNotifications.isEmpty) {
      await _schedulerService.rebuildAll();
      return true;
    }
    return false;
  }

  /// Brand-specific battery manager optimization tips
  static Map<String, String> getBrandTips() {
    return const {
      'Xiaomi / MIUI': 'Go to Settings > Apps > Manage Apps > Remember. Enable "Autostart" and set Battery Saver to "No restrictions".',
      'Oppo / Realme': 'Go to Settings > Battery > App Battery Management > Remember. Turn on "Allow background activity" and "Allow autostart".',
      'Vivo': 'Go to Settings > Battery > High background power consumption. Enable Remember.',
      'Samsung': 'Go to Settings > Battery > Background usage limits > Never sleeping apps. Add Remember.',
      'OnePlus': 'Go to Settings > Battery > Battery Optimization > Remember > Don\'t optimize.',
    };
  }
}
