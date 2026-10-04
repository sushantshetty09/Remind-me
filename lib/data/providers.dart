import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember/data/database/app_database.dart';
import 'package:remember/data/repositories/reminder_repository.dart';
import 'package:remember/data/repositories/note_repository.dart';
import 'package:remember/data/repositories/settings_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReminderRepository(db);
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return NoteRepository(db);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepository(db);
});
