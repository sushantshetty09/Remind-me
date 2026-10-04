import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:remember/core/theme/app_theme.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/features/reliability/reliability_screen.dart';
import 'package:remember/features/today/item_detail_screen.dart';
import 'package:remember/features/today/history_screen.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/scheduler_service.dart';

final activeRemindersProvider = FutureProvider<List<ReminderItem>>((ref) async {
  final reminderRepo = ref.watch(reminderRepositoryProvider);
  return await reminderRepo.getActiveReminders();
});

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeRemindersProvider);
    final nowUtc = DateTime.now().toUtc();
    final nowLocal = DateTime.now();

    final startOfDayLocal = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final startOfDayUtc = startOfDayLocal.toUtc();
    final endOfDayUtc = startOfDayLocal.add(const Duration(days: 1)).toUtc();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remember Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_outlined),
            tooltip: 'Reliability Check',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReliabilityScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: activeAsync.when(
        data: (reminders) {
          final overdue = <ReminderItem>[];
          final today = <ReminderItem>[];
          final upcoming = <ReminderItem>[];

          for (final item in reminders) {
            final targetUtc = item.status == ReminderStatus.snoozed
                ? item.snoozedUntil
                : item.datetimeUtc;

            if (targetUtc == null) {
              upcoming.add(item);
            } else if (targetUtc.isBefore(nowUtc) && item.status != ReminderStatus.snoozed) {
              overdue.add(item);
            } else if (targetUtc.isAfter(startOfDayUtc) && targetUtc.isBefore(endOfDayUtc)) {
              today.add(item);
            } else if (targetUtc.isBefore(startOfDayUtc)) {
              overdue.add(item);
            } else {
              upcoming.add(item);
            }
          }

          if (reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'All caught up!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + or Mic in Add tab to capture new thoughts.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (overdue.isNotEmpty) ...[
                _buildSectionHeader(context, 'OVERDUE', Colors.red, overdue.length),
                ...overdue.map((item) => _buildDismissibleTile(context, ref, item)),
                const SizedBox(height: 16),
              ],
              if (today.isNotEmpty) ...[
                _buildSectionHeader(context, 'TODAY', AppTheme.primarySeed, today.length),
                ...today.map((item) => _buildDismissibleTile(context, ref, item)),
                const SizedBox(height: 16),
              ],
              if (upcoming.isNotEmpty) ...[
                _buildSectionHeader(context, 'UPCOMING', Colors.teal, upcoming.length),
                ...upcoming.map((item) => _buildDismissibleTile(context, ref, item)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading reminders: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleTile(BuildContext context, WidgetRef ref, ReminderItem item) {
    return Dismissible(
      key: Key('reminder_${item.id}'),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('MARK DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('SNOOZE 1H', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.snooze, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await _markDone(ref, item);
          return true;
        } else {
          await _snooze1Hour(ref, item);
          return true;
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemDetailScreen(reminderId: item.id)),
            );
          },
          leading: Icon(
            item.isCommitment ? Icons.star : Icons.notifications_active_outlined,
            color: item.isCommitment ? AppTheme.commitmentColor : AppTheme.primarySeed,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              fontWeight: item.isHighPriority ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            item.datetimeUtc != null
                ? DateFormat('EEE, d MMM • h:mm a').format(item.datetimeUtc!.toLocal())
                : 'No set time',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (val) async {
              if (val == 'done') await _markDone(ref, item);
              if (val == 'snooze_10m') await _snooze(ref, item, const Duration(minutes: 10));
              if (val == 'snooze_1h') await _snooze(ref, item, const Duration(hours: 1));
              if (val == 'tomorrow') await _snoozeTomorrow(ref, item);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'done', child: Text('Mark Done')),
              const PopupMenuItem(value: 'snooze_10m', child: Text('Snooze 10m')),
              const PopupMenuItem(value: 'snooze_1h', child: Text('Snooze 1h')),
              const PopupMenuItem(value: 'tomorrow', child: Text('Move to Tomorrow')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markDone(WidgetRef ref, ReminderItem item) async {
    final reminderRepo = ref.read(reminderRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final scheduler = SchedulerService(reminderRepo, settingsRepo, NotificationService());

    await scheduler.cancelReminderNotifications(item);
    await reminderRepo.updateStatus(item.id, ReminderStatus.done);
    ref.refresh(activeRemindersProvider);
  }

  Future<void> _snooze1Hour(WidgetRef ref, ReminderItem item) async {
    await _snooze(ref, item, const Duration(hours: 1));
  }

  Future<void> _snooze(WidgetRef ref, ReminderItem item, Duration duration) async {
    final reminderRepo = ref.read(reminderRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final scheduler = SchedulerService(reminderRepo, settingsRepo, NotificationService());

    final snoozedUntil = DateTime.now().toUtc().add(duration);
    await scheduler.cancelReminderNotifications(item);

    final updated = item.copyWith(
      status: ReminderStatus.snoozed,
      snoozedUntil: snoozedUntil,
    );
    await reminderRepo.saveReminder(updated);
    await scheduler.scheduleReminder(updated);
    ref.refresh(activeRemindersProvider);
  }

  Future<void> _snoozeTomorrow(WidgetRef ref, ReminderItem item) async {
    final nowLocal = DateTime.now();
    final tomorrow9amLocal = DateTime(nowLocal.year, nowLocal.month, nowLocal.day + 1, 9, 0);

    final reminderRepo = ref.read(reminderRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final scheduler = SchedulerService(reminderRepo, settingsRepo, NotificationService());

    await scheduler.cancelReminderNotifications(item);

    final updated = item.copyWith(
      status: ReminderStatus.pending,
      datetimeUtc: tomorrow9amLocal.toUtc(),
      dateOnly: false,
    );
    await reminderRepo.saveReminder(updated);
    await scheduler.scheduleReminder(updated);
    ref.refresh(activeRemindersProvider);
  }
}
