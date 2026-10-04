import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:remember/data/database/tables/reminders_table.dart';
import 'package:remember/data/database/tables/notes_table.dart';
import 'package:remember/data/database/tables/settings_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Reminders, Notes, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'remember_app_db');
  }

  // --- Reminders CRUD & Queries ---
  Future<int> insertReminder(RemindersCompanion companion) =>
      into(reminders).insert(companion);

  Future<bool> updateReminder(RemindersCompanion companion) =>
      update(reminders).replace(companion);

  Future<int> deleteReminder(int id) =>
      (delete(reminders)..where((t) => t.id.equals(id))).go();

  Future<Reminder?> getReminderById(int id) =>
      (select(reminders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Reminder>> getAllPendingReminders() =>
      (select(reminders)..where((t) => t.status.equals('pending'))).get();

  Future<List<Reminder>> getAllActiveReminders() =>
      (select(reminders)..where((t) => t.status.isIn(['pending', 'snoozed']))).get();

  Future<List<Reminder>> getOverdueReminders(DateTime nowUtc) {
    return (select(reminders)
          ..where((t) =>
              t.status.isIn(['pending', 'snoozed']) &
              t.datetimeUtc.isSmallerThanValue(nowUtc)))
        .get();
  }

  Future<List<Reminder>> getTodayReminders(DateTime startOfDayUtc, DateTime endOfDayUtc) {
    return (select(reminders)
          ..where((t) =>
              t.status.isIn(['pending', 'snoozed']) &
              t.datetimeUtc.isBiggerOrEqualValue(startOfDayUtc) &
              t.datetimeUtc.isSmallerThanValue(endOfDayUtc)))
        .get();
  }

  Future<List<Reminder>> getUpcomingReminders(DateTime startUtc) {
    return (select(reminders)
          ..where((t) =>
              t.status.isIn(['pending', 'snoozed']) &
              t.datetimeUtc.isBiggerOrEqualValue(startUtc)))
        .get();
  }

  Future<List<Reminder>> getCompletedReminders() {
    return (select(reminders)
          ..where((t) => t.status.equals('done'))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  // --- Notes CRUD & Search ---
  Future<int> insertNote(NotesCompanion companion) =>
      into(notes).insert(companion);

  Future<bool> updateNote(NotesCompanion companion) =>
      update(notes).replace(companion);

  Future<int> deleteNote(int id) =>
      (delete(notes)..where((t) => t.id.equals(id))).go();

  Future<Note?> getNoteById(int id) =>
      (select(notes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Note?> getNoteByReminderId(int reminderId) =>
      (select(notes)..where((t) => t.reminderId.equals(reminderId))).getSingleOrNull();

  Future<List<Note>> getAllNotes() {
    return (select(notes)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<List<Note>> searchNotes(String query) {
    final searchPattern = '%$query%';
    return (select(notes)
          ..where((t) =>
              t.body.like(searchPattern) |
              t.summary.like(searchPattern) |
              t.tagsJson.like(searchPattern))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // --- Settings CRUD ---
  Future<String?> getSetting(String key) async {
    final result = await (select(settings)..where((t) => t.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  Future<void> setSetting(String key, String value) {
    return into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<Map<String, String>> getAllSettings() async {
    final list = await select(settings).get();
    return {for (var item in list) item.key: item.value};
  }
}
