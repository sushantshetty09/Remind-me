import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:remember/data/database/app_database.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';

extension ReminderDataMapper on Reminder {
  ReminderItem toDomain() {
    List<int> leadTimes = [];
    if (leadTimesJson != null && leadTimesJson!.isNotEmpty) {
      try {
        leadTimes = (jsonDecode(leadTimesJson!) as List<dynamic>)
            .map((e) => e as int)
            .toList();
      } catch (_) {}
    }

    List<int> notificationIds = [];
    if (notificationIdsJson != null && notificationIdsJson!.isNotEmpty) {
      try {
        notificationIds = (jsonDecode(notificationIdsJson!) as List<dynamic>)
            .map((e) => e as int)
            .toList();
      } catch (_) {}
    }

    return ReminderItem(
      id: id,
      title: title,
      rawText: rawText,
      datetimeUtc: datetimeUtc,
      dateOnly: dateOnly,
      repeat: RepeatRule.fromJsonString(repeatJson),
      person: person,
      category: ReminderCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ReminderCategory.task,
      ),
      priority: ReminderPriority.values.firstWhere(
        (e) => e.name == priority,
        orElse: () => ReminderPriority.normal,
      ),
      leadTimesMinutes: leadTimes,
      status: ReminderStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ReminderStatus.pending,
      ),
      snoozedUntil: snoozedUntil,
      escalationCount: escalationCount,
      createdAt: createdAt,
      completedAt: completedAt,
      notificationIds: notificationIds,
      noteId: noteId,
    );
  }
}

extension ReminderDomainMapper on ReminderItem {
  RemindersCompanion toCompanion() {
    return RemindersCompanion(
      id: id > 0 ? Value(id) : const Value.absent(),
      title: Value(title),
      rawText: Value(rawText),
      datetimeUtc: Value(datetimeUtc),
      dateOnly: Value(dateOnly),
      repeatJson: Value(repeat.toJsonString()),
      person: Value(person),
      category: Value(category.name),
      priority: Value(priority.name),
      leadTimesJson: Value(jsonEncode(leadTimesMinutes)),
      status: Value(status.name),
      snoozedUntil: Value(snoozedUntil),
      escalationCount: Value(escalationCount),
      createdAt: Value(createdAt),
      completedAt: Value(completedAt),
      notificationIdsJson: Value(jsonEncode(notificationIds)),
      noteId: Value(noteId),
    );
  }
}

extension NoteDataMapper on Note {
  NoteItem toDomain() {
    List<String> tags = [];
    if (tagsJson != null && tagsJson!.isNotEmpty) {
      try {
        tags = (jsonDecode(tagsJson!) as List<dynamic>).map((e) => e.toString()).toList();
      } catch (_) {}
    }

    return NoteItem(
      id: id,
      body: body,
      summary: summary,
      isImportant: isImportant,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      reminderId: reminderId,
    );
  }
}

extension NoteDomainMapper on NoteItem {
  NotesCompanion toCompanion() {
    return NotesCompanion(
      id: id > 0 ? Value(id) : const Value.absent(),
      body: Value(body),
      summary: Value(summary),
      isImportant: Value(isImportant),
      tagsJson: Value(jsonEncode(tags)),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      reminderId: Value(reminderId),
    );
  }
}
