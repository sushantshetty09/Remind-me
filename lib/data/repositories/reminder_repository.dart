import 'package:remember/data/database/app_database.dart';
import 'package:remember/data/database/db_mappers.dart';
import 'package:remember/domain/models/reminder_item.dart';

class ReminderRepository {
  final AppDatabase _db;

  ReminderRepository(this._db);

  Future<int> saveReminder(ReminderItem item) async {
    final companion = item.toCompanion();
    if (item.id > 0) {
      final existing = await _db.getReminderById(item.id);
      if (existing != null) {
        await _db.updateReminder(companion);
        return item.id;
      }
    }
    return await _db.insertReminder(companion);
  }

  Future<ReminderItem?> getReminderById(int id) async {
    final reminder = await _db.getReminderById(id);
    return reminder?.toDomain();
  }

  Future<void> deleteReminder(int id) async {
    await _db.deleteReminder(id);
  }

  Future<List<ReminderItem>> getActiveReminders() async {
    final list = await _db.getAllActiveReminders();
    return list.map((r) => r.toDomain()).toList();
  }

  Future<List<ReminderItem>> getOverdueReminders(DateTime nowUtc) async {
    final list = await _db.getOverdueReminders(nowUtc);
    return list.map((r) => r.toDomain()).toList();
  }

  Future<List<ReminderItem>> getTodayReminders(DateTime startOfDayUtc, DateTime endOfDayUtc) async {
    final list = await _db.getTodayReminders(startOfDayUtc, endOfDayUtc);
    return list.map((r) => r.toDomain()).toList();
  }

  Future<List<ReminderItem>> getUpcomingReminders(DateTime startUtc) async {
    final list = await _db.getUpcomingReminders(startUtc);
    return list.map((r) => r.toDomain()).toList();
  }

  Future<List<ReminderItem>> getCompletedReminders() async {
    final list = await _db.getCompletedReminders();
    return list.map((r) => r.toDomain()).toList();
  }

  Future<void> updateStatus(int id, ReminderStatus status, {DateTime? snoozedUntil}) async {
    final reminder = await getReminderById(id);
    if (reminder != null) {
      final updated = reminder.copyWith(
        status: status,
        snoozedUntil: snoozedUntil,
        completedAt: status == ReminderStatus.done ? DateTime.now().toUtc() : reminder.completedAt,
      );
      await saveReminder(updated);
    }
  }
}
