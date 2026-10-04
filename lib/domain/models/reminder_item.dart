import 'dart:convert';
import 'package:remember/domain/models/repeat_rule.dart';

enum ReminderCategory { commitment, task, event, idea, note }
enum ReminderPriority { normal, high }
enum ReminderStatus { pending, done, snoozed, dismissed }

class ReminderItem {
  final int id;
  final String title;
  final String rawText;
  final DateTime? datetimeUtc;
  final bool dateOnly;
  final RepeatRule repeat;
  final String? person;
  final ReminderCategory category;
  final ReminderPriority priority;
  final List<int> leadTimesMinutes; // e.g. [1440, 60]
  final ReminderStatus status;
  final DateTime? snoozedUntil;
  final int escalationCount;
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<int> notificationIds;
  final int? noteId;

  const ReminderItem({
    required this.id,
    required this.title,
    required this.rawText,
    this.datetimeUtc,
    this.dateOnly = false,
    this.repeat = const RepeatRule(),
    this.person,
    this.category = ReminderCategory.task,
    this.priority = ReminderPriority.normal,
    this.leadTimesMinutes = const [],
    this.status = ReminderStatus.pending,
    this.snoozedUntil,
    this.escalationCount = 0,
    required this.createdAt,
    this.completedAt,
    this.notificationIds = const [],
    this.noteId,
  });

  bool get isCommitment => category == ReminderCategory.commitment;
  bool get isHighPriority => priority == ReminderPriority.high || isCommitment;

  ReminderItem copyWith({
    int? id,
    String? title,
    String? rawText,
    DateTime? datetimeUtc,
    bool? dateOnly,
    RepeatRule? repeat,
    String? person,
    ReminderCategory? category,
    ReminderPriority? priority,
    List<int>? leadTimesMinutes,
    ReminderStatus? status,
    DateTime? snoozedUntil,
    int? escalationCount,
    DateTime? createdAt,
    DateTime? completedAt,
    List<int>? notificationIds,
    int? noteId,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      rawText: rawText ?? this.rawText,
      datetimeUtc: datetimeUtc ?? this.datetimeUtc,
      dateOnly: dateOnly ?? this.dateOnly,
      repeat: repeat ?? this.repeat,
      person: person ?? this.person,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      leadTimesMinutes: leadTimesMinutes ?? this.leadTimesMinutes,
      status: status ?? this.status,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      escalationCount: escalationCount ?? this.escalationCount,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      notificationIds: notificationIds ?? this.notificationIds,
      noteId: noteId ?? this.noteId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'raw_text': rawText,
        'datetime_utc': datetimeUtc?.toIso8601String(),
        'date_only': dateOnly,
        'repeat': repeat.toJson(),
        'person': person,
        'category': category.name,
        'priority': priority.name,
        'lead_times_minutes': leadTimesMinutes,
        'status': status.name,
        'snoozed_until': snoozedUntil?.toIso8601String(),
        'escalation_count': escalationCount,
        'created_at': createdAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'notification_ids': notificationIds,
        'note_id': noteId,
      };

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      rawText: json['raw_text'] as String? ?? '',
      datetimeUtc: json['datetime_utc'] != null
          ? DateTime.parse(json['datetime_utc'] as String)
          : null,
      dateOnly: json['date_only'] as bool? ?? false,
      repeat: json['repeat'] != null
          ? RepeatRule.fromJson(json['repeat'] as Map<String, dynamic>)
          : const RepeatRule(),
      person: json['person'] as String?,
      category: ReminderCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ReminderCategory.task,
      ),
      priority: ReminderPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => ReminderPriority.normal,
      ),
      leadTimesMinutes:
          (json['lead_times_minutes'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              [],
      status: ReminderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReminderStatus.pending,
      ),
      snoozedUntil: json['snoozed_until'] != null
          ? DateTime.parse(json['snoozed_until'] as String)
          : null,
      escalationCount: json['escalation_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      notificationIds:
          (json['notification_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      noteId: json['note_id'] as int?,
    );
  }
}
