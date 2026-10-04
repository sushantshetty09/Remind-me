import 'package:remember/data/database/app_database.dart';
import 'package:remember/data/database/db_mappers.dart';
import 'package:remember/domain/models/note_item.dart';

class NoteRepository {
  final AppDatabase _db;

  NoteRepository(this._db);

  Future<int> saveNote(NoteItem note) async {
    final companion = note.toCompanion();
    if (note.id > 0) {
      final existing = await _db.getNoteById(note.id);
      if (existing != null) {
        await _db.updateNote(companion);
        return note.id;
      }
    }
    return await _db.insertNote(companion);
  }

  Future<NoteItem?> getNoteById(int id) async {
    final note = await _db.getNoteById(id);
    return note?.toDomain();
  }

  Future<NoteItem?> getNoteByReminderId(int reminderId) async {
    final note = await _db.getNoteByReminderId(reminderId);
    return note?.toDomain();
  }

  Future<void> deleteNote(int id) async {
    await _db.deleteNote(id);
  }

  Future<List<NoteItem>> getAllNotes() async {
    final list = await _db.getAllNotes();
    return list.map((n) => n.toDomain()).toList();
  }

  Future<List<NoteItem>> searchNotes(String query) async {
    if (query.trim().isEmpty) {
      return getAllNotes();
    }
    final list = await _db.searchNotes(query.trim());
    return list.map((n) => n.toDomain()).toList();
  }

  Future<void> toggleImportant(int id) async {
    final note = await getNoteById(id);
    if (note != null) {
      final updated = note.copyWith(
        isImportant: !note.isImportant,
        updatedAt: DateTime.now().toUtc(),
      );
      await saveNote(updated);
    }
  }
}
