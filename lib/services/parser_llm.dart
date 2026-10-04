import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/data/repositories/settings_repository.dart';
import 'package:remember/domain/models/parsed_item.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';
import 'package:remember/services/parser_rule_based.dart';

class LlmParserService {
  final SettingsRepository _settingsRepo;
  final RuleBasedParser _ruleBasedParser;
  final FlutterSecureStorage _secureStorage;

  LlmParserService(
    this._settingsRepo,
    this._ruleBasedParser, {
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<List<ParsedItem>> parse(String rawText, {DateTime? referenceTime}) async {
    final now = referenceTime ?? DateTime.now();

    // Check if Layer 2 LLM Parser is enabled
    final isEnabled = await _settingsRepo.getBool(AppConstants.keyEnableLlmParser);
    if (!isEnabled) {
      return _fallbackLayer1(rawText, now);
    }

    final apiKey = await _secureStorage.read(key: AppConstants.secureKeyLlmApiKey);
    if (apiKey == null || apiKey.trim().isEmpty) {
      return _fallbackLayer1(rawText, now);
    }

    final endpoint = await _settingsRepo.getString(
      AppConstants.keyLlmEndpoint,
      defaultValue: 'https://api.openai.com/v1/chat/completions',
    );

    try {
      final items = await _queryLlm(rawText, now, apiKey, endpoint!).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return _fallbackLayer1(rawText, now);
        },
      );
      if (items.isNotEmpty) return items;
    } catch (_) {
      // On network or parsing failure, silently fallback to Layer 1
    }

    return _fallbackLayer1(rawText, now);
  }

  List<ParsedItem> _fallbackLayer1(String rawText, DateTime now) {
    final splitList = _ruleBasedParser.splitInput(rawText);
    return splitList.map((t) => _ruleBasedParser.parseSingle(t, referenceTime: now)).toList();
  }

  Future<List<ParsedItem>> _queryLlm(
    String rawText,
    DateTime now,
    String apiKey,
    String endpoint,
  ) async {
    final nowIso = now.toIso8601String();
    final tzStr = DateTime.now().timeZoneName;
    final weekdayStr = DateFormat('EEEE').format(now);

    final prompt = '''
You convert a person's spoken or typed note into reminder items.
Current local datetime: $nowIso. Timezone: $tzStr. Weekday: $weekdayStr.

Return ONLY valid JSON, no prose, no markdown fences:
{"items":[{
  "title": "string (max 8 words, starts with a verb when possible)",
  "datetime": "YYYY-MM-DDTHH:mm:ss" or null,
  "date_only": boolean,
  "repeat": {"type":"none|daily|weekly|monthly|interval",
             "days":[0-6], "day_of_month": number|null,
             "every": number|null, "unit":"minutes|hours|days|null"},
  "person": string|null,
  "category": "commitment|task|event|idea|note",
  "priority": "normal|high",
  "lead_times_minutes": [number],
  "confidence": number (0 to 1),
  "assumptions": [string]
}]}

Rules:
- Split the input into separate items when it contains several tasks.
- Resolve relative words (tomorrow, Friday, next week, tonight) from the current datetime. Never return a datetime in the past.
- If only a date is given, set date_only=true and time to 09:00.
- Defaults: morning 09:00, afternoon 14:00, evening 18:00, tonight 20:00.
- Mark category "commitment" when the user promised something to another person. Mark priority "high" for words like important, urgent, must, don't forget, or for commitments.
- List every guess you made in "assumptions".
- If there is no time-related meaning, set datetime null and category "note".

Input: "$rawText"
''';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': 'You are a JSON date parser.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.1,
      }),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String;
    final cleanedJson = content.replaceAll(RegExp(r'^```json\s*|\s*```$'), '').trim();

    final parsedMap = jsonDecode(cleanedJson) as Map<String, dynamic>;
    final itemsList = parsedMap['items'] as List<dynamic>;

    final result = <ParsedItem>[];
    for (final itemMap in itemsList) {
      final map = itemMap as Map<String, dynamic>;

      DateTime? dt;
      if (map['datetime'] != null) {
        try {
          dt = DateTime.parse(map['datetime'] as String);
        } catch (_) {}
      }

      final category = ReminderCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ReminderCategory.task,
      );

      final priority = ReminderPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => ReminderPriority.normal,
      );

      RepeatRule repeatRule = const RepeatRule();
      if (map['repeat'] != null) {
        repeatRule = RepeatRule.fromJson(map['repeat'] as Map<String, dynamic>);
      }

      result.add(ParsedItem(
        title: map['title'] as String? ?? rawText,
        datetime: dt,
        dateOnly: map['date_only'] as bool? ?? false,
        repeat: repeatRule,
        person: map['person'] as String?,
        category: category,
        priority: priority,
        leadTimesMinutes: (map['lead_times_minutes'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
        confidence: (map['confidence'] as num?)?.toDouble() ?? 1.0,
        assumptions: (map['assumptions'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        rawText: rawText,
      ));
    }

    return result;
  }
}
