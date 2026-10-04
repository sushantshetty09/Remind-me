import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';

class ParsedItem {
  final String title;
  final DateTime? datetime;
  final bool dateOnly;
  final RepeatRule repeat;
  final String? person;
  final ReminderCategory category;
  final ReminderPriority priority;
  final List<int> leadTimesMinutes;
  final double confidence;
  final List<String> assumptions;
  final String rawText;

  const ParsedItem({
    required this.title,
    this.datetime,
    this.dateOnly = false,
    this.repeat = const RepeatRule(),
    this.person,
    this.category = ReminderCategory.task,
    this.priority = ReminderPriority.normal,
    this.leadTimesMinutes = const [],
    this.confidence = 1.0,
    this.assumptions = const [],
    required this.rawText,
  });

  ParsedItem copyWith({
    String? title,
    DateTime? datetime,
    bool? dateOnly,
    RepeatRule? repeat,
    String? person,
    ReminderCategory? category,
    ReminderPriority? priority,
    List<int>? leadTimesMinutes,
    double? confidence,
    List<String>? assumptions,
    String? rawText,
  }) {
    return ParsedItem(
      title: title ?? this.title,
      datetime: datetime ?? this.datetime,
      dateOnly: dateOnly ?? this.dateOnly,
      repeat: repeat ?? this.repeat,
      person: person ?? this.person,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      leadTimesMinutes: leadTimesMinutes ?? this.leadTimesMinutes,
      confidence: confidence ?? this.confidence,
      assumptions: assumptions ?? this.assumptions,
      rawText: rawText ?? this.rawText,
    );
  }

  ReminderItem toReminderItem({required DateTime nowUtc}) {
    return ReminderItem(
      id: 0,
      title: title,
      rawText: rawText,
      datetimeUtc: datetime?.toUtc(),
      dateOnly: dateOnly,
      repeat: repeat,
      person: person,
      category: category,
      priority: priority,
      leadTimesMinutes: leadTimesMinutes,
      status: ReminderStatus.pending,
      createdAt: nowUtc,
    );
  }
}
