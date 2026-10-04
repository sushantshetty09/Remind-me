import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember/data/database/app_database.dart';
import 'package:remember/data/repositories/reminder_repository.dart';
import 'package:remember/data/repositories/note_repository.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';

void main() {
  late AppDatabase db;
  late ReminderRepository reminderRepo;
  late NoteRepository noteRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    reminderRepo = ReminderRepository(db);
    noteRepo = NoteRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Insert and retrieve Reminder', () async {
    final now = DateTime.now().toUtc();
    final reminder = ReminderItem(
      id: 0,
      title: 'Call Rahul about rent',
      rawText: 'Call Rahul about rent tomorrow evening',
      datetimeUtc: now.add(const Duration(hours: 24)),
      category: ReminderCategory.commitment,
      priority: ReminderPriority.high,
      createdAt: now,
    );

    final id = await reminderRepo.saveReminder(reminder);
    expect(id, greaterThan(0));

    final fetched = await reminderRepo.getReminderById(id);
    expect(fetched, isNotNull);
    expect(fetched!.title, 'Call Rahul about rent');
    expect(fetched.category, ReminderCategory.commitment);
    expect(fetched.priority, ReminderPriority.high);
    expect(fetched.isCommitment, isTrue);
  });

  test('Insert note and search notes', () async {
    final now = DateTime.now().toUtc();
    final note = NoteItem(
      id: 0,
      body: 'Submit tax documents before deadline',
      summary: 'Submit tax form',
      tags: ['tax', 'finance'],
      createdAt: now,
      updatedAt: now,
    );

    final id = await noteRepo.saveNote(note);
    expect(id, greaterThan(0));

    final results = await noteRepo.searchNotes('tax');
    expect(results.length, 1);
    expect(results.first.summary, 'Submit tax form');
  });
}
