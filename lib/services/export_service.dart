import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:remember/data/repositories/note_repository.dart';
import 'package:remember/data/repositories/reminder_repository.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/domain/models/reminder_item.dart';

class ExportService {
  final NoteRepository _noteRepo;
  final ReminderRepository _reminderRepo;

  ExportService(this._noteRepo, this._reminderRepo);

  /// Share a single note via Android Share Sheet ("Send to Notes")
  Future<void> sendNoteToShareSheet(NoteItem note) async {
    final text = 'Note: ${note.summary ?? note.body}\n\n${note.body}\n\nCreated: ${DateFormat('yyyy-MM-dd HH:mm').format(note.createdAt.toLocal())}';
    await Share.share(text, subject: note.summary ?? 'Note from Remember');
  }

  /// Export all notes and reminders to JSON
  Future<String> exportBackupToJson() async {
    final notes = await _noteRepo.getAllNotes();
    final reminders = await _reminderRepo.getActiveReminders();
    final completed = await _reminderRepo.getCompletedReminders();

    final backup = {
      'app': 'Remember',
      'version': '1.0.0',
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'reminders': [...reminders, ...completed].map((r) => r.toJson()).toList(),
    };

    return jsonEncode(backup);
  }

  /// Import backup from JSON string
  Future<int> importBackupFromJson(String jsonStr) async {
    final Map<String, dynamic> data = jsonDecode(jsonStr);
    int importedCount = 0;

    if (data.containsKey('notes')) {
      final list = data['notes'] as List<dynamic>;
      for (final item in list) {
        final note = NoteItem.fromJson(item as Map<String, dynamic>);
        await _noteRepo.saveNote(note);
        importedCount++;
      }
    }

    if (data.containsKey('reminders')) {
      final list = data['reminders'] as List<dynamic>;
      for (final item in list) {
        final reminder = ReminderItem.fromJson(item as Map<String, dynamic>);
        await _reminderRepo.saveReminder(reminder);
        importedCount++;
      }
    }

    return importedCount;
  }

  /// Write daily Markdown files for auto-export folder
  Future<String> exportDailyMarkdownFile(String folderPath, DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-DD').format(date);
    final filePath = '$folderPath/$dateStr.md';
    final file = File(filePath);

    final notes = await _noteRepo.getAllNotes();
    final dayNotes = notes.where((n) {
      final d = n.createdAt.toLocal();
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();

    final buffer = StringBuffer();
    buffer.writeln('# Remember Notes - $dateStr\n');

    for (final note in dayNotes) {
      buffer.writeln('## ${note.summary ?? "Note"}');
      buffer.writeln('- **Created:** ${DateFormat('HH:mm').format(note.createdAt.toLocal())}');
      if (note.isImportant) buffer.writeln('- **Priority:** Important ⭐');
      if (note.tags.isNotEmpty) buffer.writeln('- **Tags:** ${note.tags.join(", ")}');
      buffer.writeln('\n${note.body}\n---');
    }

    await file.writeAsString(buffer.toString());
    return filePath;
  }
}
