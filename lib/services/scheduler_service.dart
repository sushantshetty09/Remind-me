import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/data/repositories/reminder_repository.dart';
import 'package:remember/data/repositories/settings_repository.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/services/notification_service.dart';

class SchedulerService {
  final ReminderRepository _reminderRepo;
  final SettingsRepository _settingsRepo;
  final NotificationService _notificationService;

  SchedulerService(
    this._reminderRepo,
    this._settingsRepo,
    this._notificationService,
  );

  /// Deterministic ID generator (31-bit integer hash)
  static int generateNotificationId(int reminderId, String kind, int index) {
    final key = '$reminderId:$kind:$index';
    int hash = 0;
    for (int i = 0; i < key.length; i++) {
      hash = (31 * hash + key.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return hash;
  }

  /// Rebuild all scheduled notifications from the database (Single Source of Truth)
  Future<void> rebuildAll() async {
    // 1. Cancel all current scheduled notifications
    await _notificationService.cancelAll();

    // 2. Fetch all active (pending/snoozed) reminders
    final activeReminders = await _reminderRepo.getActiveReminders();
    final nowUtc = DateTime.now().toUtc();

    for (final reminder in activeReminders) {
      await scheduleReminder(reminder, nowUtc: nowUtc);
    }

    // 3. Schedule Morning Briefing and Evening Review
    await scheduleBriefingAndReview();
  }

  /// Schedule notifications for a single reminder item
  Future<List<int>> scheduleReminder(ReminderItem item, {DateTime? nowUtc}) async {
    final now = nowUtc ?? DateTime.now().toUtc();
    final scheduledNotificationIds = <int>[];

    // If completed or dismissed, do not schedule
    if (item.status == ReminderStatus.done || item.status == ReminderStatus.dismissed) {
      return [];
    }

    // Determine primary target time (snoozed time or scheduled datetime)
    final targetTimeUtc = item.status == ReminderStatus.snoozed
        ? item.snoozedUntil
        : item.datetimeUtc;

    if (targetTimeUtc == null) return [];

    // 1. Main Notification
    if (targetTimeUtc.isAfter(now)) {
      final mainId = generateNotificationId(item.id, 'main', 0);
      await _notificationService.scheduleNotification(
        id: mainId,
        title: item.isCommitment ? '⚡ Promise: ${item.title}' : item.title,
        body: item.person != null ? 'With ${item.person}' : item.rawText,
        scheduledDateUtc: targetTimeUtc,
        channelId: item.isHighPriority
            ? AppConstants.channelEscalations
            : AppConstants.channelReminders,
        payload: 'reminder_id:${item.id}',
      );
      scheduledNotificationIds.add(mainId);
    }

    // 2. Pre-reminders (lead times) if item is pending (not snoozed)
    if (item.status == ReminderStatus.pending) {
      if (item.dateOnly) {
        // Date-only pre-reminder: Evening before at 20:00 local time
        final eveningBeforeUtc = DateTime.utc(
          targetTimeUtc.year,
          targetTimeUtc.month,
          targetTimeUtc.day - 1,
          20,
          0,
        );
        if (eveningBeforeUtc.isAfter(now)) {
          final leadId = generateNotificationId(item.id, 'lead', 0);
          await _notificationService.scheduleNotification(
            id: leadId,
            title: 'Tomorrow: ${item.title}',
            body: item.rawText,
            scheduledDateUtc: eveningBeforeUtc,
            payload: 'reminder_id:${item.id}',
          );
          scheduledNotificationIds.add(leadId);
        }
      } else {
        // Timed pre-reminders based on leadTimesMinutes
        for (int i = 0; i < item.leadTimesMinutes.length; i++) {
          final leadMins = item.leadTimesMinutes[i];
          final leadTimeUtc = targetTimeUtc.subtract(Duration(minutes: leadMins));
          if (leadTimeUtc.isAfter(now)) {
            final leadId = generateNotificationId(item.id, 'lead', i);
            await _notificationService.scheduleNotification(
              id: leadId,
              title: 'Upcoming in ${leadMins}m: ${item.title}',
              body: item.rawText,
              scheduledDateUtc: leadTimeUtc,
              payload: 'reminder_id:${item.id}',
            );
            scheduledNotificationIds.add(leadId);
          }
        }
      }
    }

    // 3. Escalation re-alerts for High Priority / Commitment items
    if (item.isHighPriority && targetTimeUtc.isAfter(now)) {
      final escalationOffsets = [5, 15, 30, 60, 120]; // minutes after main time
      for (int i = 0; i < escalationOffsets.length; i++) {
        final offset = escalationOffsets[i];
        final escTimeUtc = targetTimeUtc.add(Duration(minutes: offset));
        if (escTimeUtc.isAfter(now)) {
          final escId = generateNotificationId(item.id, 'escalation', i);
          await _notificationService.scheduleNotification(
            id: escId,
            title: '⚠️ Still pending: ${item.title}',
            body: 'Tap Done or Snooze to stop alerts.',
            scheduledDateUtc: escTimeUtc,
            channelId: AppConstants.channelEscalations,
            payload: 'reminder_id:${item.id}',
          );
          scheduledNotificationIds.add(escId);
        }
      }
    }

    // Update item in database with scheduled notification IDs
    final updatedItem = item.copyWith(notificationIds: scheduledNotificationIds);
    await _reminderRepo.saveReminder(updatedItem);

    return scheduledNotificationIds;
  }

  /// Cancel all scheduled notifications for a specific reminder
  Future<void> cancelReminderNotifications(ReminderItem item) async {
    for (final id in item.notificationIds) {
      await _notificationService.cancel(id);
    }
  }

  /// Schedule daily Morning Briefing and Evening Review
  Future<void> scheduleBriefingAndReview() async {
    final nowLocal = DateTime.now();

    // Morning Briefing (default 08:00)
    final briefingTimeStr =
        await _settingsRepo.getString(AppConstants.keyMorningBriefingTime, defaultValue: '08:00');
    final bParts = briefingTimeStr!.split(':').map((e) => int.parse(e)).toList();
    var nextBriefing = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, bParts[0], bParts[1]);
    if (nextBriefing.isBefore(nowLocal)) {
      nextBriefing = nextBriefing.add(const Duration(days: 1));
    }

    await _notificationService.scheduleNotification(
      id: 99901,
      title: '🌅 Morning Briefing',
      body: 'Tap to view your plan for today.',
      scheduledDateUtc: nextBriefing.toUtc(),
      channelId: AppConstants.channelBriefings,
      payload: 'type:morning_briefing',
    );

    // Evening Review (default 21:00)
    final reviewTimeStr =
        await _settingsRepo.getString(AppConstants.keyEveningReviewTime, defaultValue: '21:00');
    final rParts = reviewTimeStr!.split(':').map((e) => int.parse(e)).toList();
    var nextReview = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, rParts[0], rParts[1]);
    if (nextReview.isBefore(nowLocal)) {
      nextReview = nextReview.add(const Duration(days: 1));
    }

    await _notificationService.scheduleNotification(
      id: 99902,
      title: '🌙 Evening Review',
      body: 'Check remaining open tasks and plan ahead.',
      scheduledDateUtc: nextReview.toUtc(),
      channelId: AppConstants.channelBriefings,
      payload: 'type:evening_review',
    );
  }
}
