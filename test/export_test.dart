import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember/data/database/app_database.dart';
import 'package:remember/data/repositories/note_repository.dart';
import 'package:remember/data/repositories/reminder_repository.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/services/export_service.dart';

void main() {
  late AppDatabase db;
  late NoteRepository noteRepo;
  late ReminderRepository reminderRepo;
  late ExportService exportService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    noteRepo = NoteRepository(db);
    reminderRepo = ReminderRepository(db);
    exportService = ExportService(noteRepo, reminderRepo);
  });

  tearDown(() async {
    await db.close();
  });

  test('Export backup to JSON and Import backup from JSON', () async {
    final now = DateTime.now().toUtc();
    final note = NoteItem(
      id: 0,
      body: 'Call dentist for teeth cleaning',
      summary: 'Dentist appointment',
      isImportant: true,
      tags: ['health'],
      createdAt: now,
      updatedAt: now,
    );

    await noteRepo.saveNote(note);

    final jsonStr = await exportService.exportBackupToJson();
    expect(jsonStr, contains('Dentist appointment'));

    // Clear db and re-import
    final db2 = AppDatabase(NativeDatabase.memory());
    final noteRepo2 = NoteRepository(db2);
    final reminderRepo2 = ReminderRepository(db2);
    final exportService2 = ExportService(noteRepo2, reminderRepo2);

    final count = await exportService2.importBackupFromJson(jsonStr);
    expect(count, greaterThan(0));

    final notes = await noteRepo2.getAllNotes();
    expect(notes.length, 1);
    expect(notes.first.summary, 'Dentist appointment');

    await db2.close();
  });
}
