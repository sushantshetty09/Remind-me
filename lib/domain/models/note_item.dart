import 'dart:convert';

class NoteItem {
  final int id;
  final String body;
  final String? summary;
  final bool isImportant;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? reminderId;

  const NoteItem({
    required this.id,
    required this.body,
    this.summary,
    this.isImportant = false,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.reminderId,
  });

  NoteItem copyWith({
    int? id,
    String? body,
    String? summary,
    bool? isImportant,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? reminderId,
  }) {
    return NoteItem(
      id: id ?? this.id,
      body: body ?? this.body,
      summary: summary ?? this.summary,
      isImportant: isImportant ?? this.isImportant,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderId: reminderId ?? this.reminderId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'body': body,
        'summary': summary,
        'is_important': isImportant,
        'tags': tags,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'reminder_id': reminderId,
      };

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'] as int? ?? 0,
      body: json['body'] as String? ?? '',
      summary: json['summary'] as String?,
      isImportant: json['is_important'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      reminderId: json['reminder_id'] as int?,
    );
  }
}
