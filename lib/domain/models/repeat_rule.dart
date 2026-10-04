import 'dart:convert';

enum RepeatType { none, daily, weekly, monthly, interval }

class RepeatRule {
  final RepeatType type;
  final List<int> days; // 0=Mon, 1=Tue, ..., 6=Sun
  final int? dayOfMonth; // 1-31
  final int? every; // Interval count e.g. 2 for every 2 weeks
  final String? unit; // "minutes", "hours", "days", "weeks", "months"

  const RepeatRule({
    this.type = RepeatType.none,
    this.days = const [],
    this.dayOfMonth,
    this.every,
    this.unit,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'days': days,
        'day_of_month': dayOfMonth,
        'every': every,
        'unit': unit,
      };

  factory RepeatRule.fromJson(Map<String, dynamic> json) {
    return RepeatRule(
      type: RepeatType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RepeatType.none,
      ),
      days: (json['days'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      dayOfMonth: json['day_of_month'] as int?,
      every: json['every'] as int?,
      unit: json['unit'] as String?,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory RepeatRule.fromJsonString(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return const RepeatRule();
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return RepeatRule.fromJson(map);
    } catch (_) {
      return const RepeatRule();
    }
  }
}
