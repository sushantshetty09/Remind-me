import 'package:flutter/material.dart';
import 'package:remember/domain/models/parsed_item.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';

class DaypartDefaults {
  final TimeOfDay morning; // 09:00
  final TimeOfDay afternoon; // 14:00
  final TimeOfDay evening; // 18:00
  final TimeOfDay tonight; // 20:00
  final TimeOfDay eod; // 17:30

  const DaypartDefaults({
    this.morning = const TimeOfDay(hour: 9, minute: 0),
    this.afternoon = const TimeOfDay(hour: 14, minute: 0),
    this.evening = const TimeOfDay(hour: 18, minute: 0),
    this.tonight = const TimeOfDay(hour: 20, minute: 0),
    this.eod = const TimeOfDay(hour: 17, minute: 30),
  });
}

class RuleBasedParser {
  final DaypartDefaults dayparts;

  const RuleBasedParser({
    this.dayparts = const DaypartDefaults(),
  });

  List<String> splitInput(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) return [];

    if (text.contains('\n')) {
      final lines = text
          .split('\n')
          .map((l) => l.replaceAll(RegExp(r'^\s*[-*•\d+.]+\s*'), '').trim())
          .where((l) => l.isNotEmpty)
          .toList();
      if (lines.length > 1) return lines;
    }

    final regexAnd = RegExp(r'\s*(?:,|;|\band\b)\s*', caseSensitive: false);
    final parts = text.split(regexAnd).where((p) => p.trim().isNotEmpty).toList();

    if (parts.length > 1) {
      bool looksLikeMultiTask = true;
      for (final p in parts) {
        if (p.trim().length < 3) {
          looksLikeMultiTask = false;
          break;
        }
      }
      if (looksLikeMultiTask && parts.length <= 5) {
        return parts;
      }
    }

    return [text];
  }

  ParsedItem parseSingle(String rawText, {DateTime? referenceTime}) {
    final now = referenceTime ?? DateTime.now();
    final trimmedRaw = rawText.trim();
    if (trimmedRaw.isEmpty) {
      return ParsedItem(
        title: '',
        rawText: rawText,
        confidence: 1.0,
      );
    }

    final lower = trimmedRaw.toLowerCase();
    final assumptions = <String>[];
    double confidence = 1.0;

    // 0. Extract person from original input
    final personResult = _extractPerson(trimmedRaw);
    final String? person = personResult.person;

    // 1. Repeat rule detection
    final repeatResult = _extractRepeat(lower);
    final RepeatRule repeat = repeatResult.rule;
    String workingText = repeatResult.remainingText;

    // 2. Relative time detection ("in 2 hours", "after 30 mins", "in 3 days")
    final relativeResult = _extractRelativeTime(workingText, now);
    DateTime? resolvedDatetime = relativeResult.datetime;
    if (relativeResult.matched) {
      workingText = relativeResult.remainingText;
      assumptions.add('Relative time calculated from current time');
    }

    // 3. Date & Time extraction if not relative
    bool dateOnly = false;
    if (resolvedDatetime == null) {
      final dateTimeResult = _extractDateAndTime(workingText, now, dayparts);
      resolvedDatetime = dateTimeResult.datetime;
      dateOnly = dateTimeResult.dateOnly;
      workingText = dateTimeResult.remainingText;
      if (dateTimeResult.assumptions.isNotEmpty) {
        assumptions.addAll(dateTimeResult.assumptions);
      }
      if (dateTimeResult.confidenceAdjustment < 0) {
        confidence += dateTimeResult.confidenceAdjustment;
      }
    }

    // Check for past datetime
    if (resolvedDatetime != null && resolvedDatetime.isBefore(now)) {
      if (dateOnly) {
        resolvedDatetime = resolvedDatetime.add(const Duration(days: 1));
        assumptions.add('Time was in the past; shifted forward');
      } else {
        resolvedDatetime = resolvedDatetime.add(const Duration(days: 1));
        assumptions.add('Specified time has passed today; scheduled for tomorrow');
      }
      confidence -= 0.1;
    }

    // 4. Category & Priority
    ReminderCategory category = ReminderCategory.task;
    ReminderPriority priority = ReminderPriority.normal;

    final isCommitment = _isCommitment(lower, person);
    if (isCommitment) {
      category = ReminderCategory.commitment;
      priority = ReminderPriority.high;
    } else if (resolvedDatetime == null && repeat.type == RepeatType.none) {
      if (lower.startsWith('idea') || lower.contains('idea:')) {
        category = ReminderCategory.idea;
      } else if (lower.startsWith('note') || lower.contains('note:')) {
        category = ReminderCategory.note;
      }
    }

    if (_isHighPriorityKeyword(lower)) {
      priority = ReminderPriority.high;
    }

    // 5. Lead times
    List<int> leadTimes = [];
    if (resolvedDatetime != null) {
      if (dateOnly) {
        leadTimes = [60];
      } else {
        final diff = resolvedDatetime.difference(now);
        if (diff.inHours >= 2) {
          leadTimes = [60];
        }
      }
    }

    // 6. Title formatting
    String title = _cleanTitle(workingText, trimmedRaw, person);

    return ParsedItem(
      title: title,
      datetime: resolvedDatetime,
      dateOnly: dateOnly,
      repeat: repeat,
      person: person,
      category: category,
      priority: priority,
      leadTimesMinutes: leadTimes,
      confidence: confidence.clamp(0.0, 1.0),
      assumptions: assumptions,
      rawText: rawText,
    );
  }

  _RepeatResult _extractRepeat(String text) {
    if (RegExp(r'\bevery\s+day\b|\bdaily\b').hasMatch(text)) {
      final cleaned = text.replaceAll(RegExp(r'\bevery\s+day\b|\bdaily\b'), '');
      return _RepeatResult(const RepeatRule(type: RepeatType.daily), cleaned);
    }
    if (RegExp(r'\bevery\s+week\b|\bweekly\b').hasMatch(text)) {
      final cleaned = text.replaceAll(RegExp(r'\bevery\s+week\b|\bweekly\b'), '');
      return _RepeatResult(const RepeatRule(type: RepeatType.weekly), cleaned);
    }
    if (RegExp(r'\bevery\s+month\b|\bmonthly\b').hasMatch(text)) {
      final cleaned = text.replaceAll(RegExp(r'\bevery\s+month\b|\bmonthly\b'), '');
      return _RepeatResult(const RepeatRule(type: RepeatType.monthly), cleaned);
    }

    final weekdayMap = {
      'monday': 0, 'mon': 0,
      'tuesday': 1, 'tue': 1, 'tues': 1,
      'wednesday': 2, 'wed': 2,
      'thursday': 3, 'thu': 3, 'thur': 3, 'thurs': 3,
      'friday': 4, 'fri': 4,
      'saturday': 5, 'sat': 5,
      'sunday': 6, 'sun': 6,
    };

    final matchEvery = RegExp(r'\bevery\s+([a-z,\s]+)', caseSensitive: false).firstMatch(text);
    if (matchEvery != null) {
      final daysMatched = <int>[];
      final daySegment = matchEvery.group(1)!;
      for (final entry in weekdayMap.entries) {
        if (RegExp('\\b${entry.key}\\b').hasMatch(daySegment)) {
          if (!daysMatched.contains(entry.value)) {
            daysMatched.add(entry.value);
          }
        }
      }
      if (daysMatched.isNotEmpty) {
        daysMatched.sort();
        final cleaned = text.replaceRange(matchEvery.start, matchEvery.end, '');
        return _RepeatResult(
            RepeatRule(type: RepeatType.weekly, days: daysMatched), cleaned);
      }
    }

    return _RepeatResult(const RepeatRule(), text);
  }

  _RelativeResult _extractRelativeTime(String text, DateTime now) {
    final relRegex = RegExp(
      r'\b(?:in|after)\s+(\d+)\s*(hour|hr|hours|hrs|minute|min|minutes|mins|day|days)\b',
      caseSensitive: false,
    );
    final match = relRegex.firstMatch(text);
    if (match != null) {
      final amount = int.parse(match.group(1)!);
      final unit = match.group(2)!.toLowerCase();
      Duration duration;
      if (unit.startsWith('h')) {
        duration = Duration(hours: amount);
      } else if (unit.startsWith('m')) {
        duration = Duration(minutes: amount);
      } else {
        duration = Duration(days: amount);
      }
      final dt = now.add(duration);
      final cleaned = text.replaceRange(match.start, match.end, '');
      return _RelativeResult(datetime: dt, matched: true, remainingText: cleaned);
    }
    return _RelativeResult(datetime: null, matched: false, remainingText: text);
  }

  _DateTimeResult _extractDateAndTime(
      String text, DateTime now, DaypartDefaults dayparts) {
    DateTime? targetDate;
    TimeOfDay? targetTime;
    bool dateOnly = false;
    final assumptions = <String>[];
    double confidenceAdjustment = 0.0;
    String remaining = text;

    TimeOfDay? daypartTime;
    if (RegExp(r'\btonight\b').hasMatch(remaining)) {
      daypartTime = dayparts.tonight;
      remaining = remaining.replaceAll(RegExp(r'\btonight\b'), '');
    } else if (RegExp(r'\bthis evening\b|\bevening\b').hasMatch(remaining)) {
      daypartTime = dayparts.evening;
      remaining = remaining.replaceAll(RegExp(r'\bthis evening\b|\bevening\b'), '');
    } else if (RegExp(r'\bafternoon\b').hasMatch(remaining)) {
      daypartTime = dayparts.afternoon;
      remaining = remaining.replaceAll(RegExp(r'\bafternoon\b'), '');
    } else if (RegExp(r'\bmorning\b').hasMatch(remaining)) {
      daypartTime = dayparts.morning;
      remaining = remaining.replaceAll(RegExp(r'\bmorning\b'), '');
    } else if (RegExp(r'\beod\b|\bend of day\b').hasMatch(remaining)) {
      daypartTime = dayparts.eod;
      remaining = remaining.replaceAll(RegExp(r'\beod\b|\bend of day\b'), '');
    }

    if (RegExp(r'\bday after tomorrow\b').hasMatch(remaining)) {
      targetDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 2));
      remaining = remaining.replaceAll(RegExp(r'\bday after tomorrow\b'), '');
    } else if (RegExp(r'\btomorrow\b').hasMatch(remaining)) {
      targetDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
      remaining = remaining.replaceAll(RegExp(r'\btomorrow\b'), '');
    } else if (RegExp(r'\btoday\b').hasMatch(remaining)) {
      targetDate = DateTime(now.year, now.month, now.day);
      remaining = remaining.replaceAll(RegExp(r'\btoday\b'), '');
    }

    if (targetDate == null) {
      final weekdayResult = _extractWeekday(remaining, now);
      if (weekdayResult.date != null) {
        targetDate = weekdayResult.date;
        remaining = weekdayResult.remainingText;
      }
    }

    if (targetDate == null) {
      final specificDateResult = _extractSpecificDate(remaining, now);
      if (specificDateResult.date != null) {
        targetDate = specificDateResult.date;
        remaining = specificDateResult.remainingText;
      }
    }

    final explicitTimeResult = _extractExplicitTime(remaining);
    if (explicitTimeResult.time != null) {
      targetTime = explicitTimeResult.time;
      remaining = explicitTimeResult.remainingText;
    } else if (daypartTime != null) {
      targetTime = daypartTime;
    }

    if (targetDate == null && targetTime == null) {
      return _DateTimeResult(
        datetime: null,
        dateOnly: false,
        assumptions: assumptions,
        confidenceAdjustment: 0.0,
        remainingText: remaining,
      );
    }

    if (targetDate != null && targetTime == null) {
      dateOnly = true;
      targetTime = dayparts.morning;
      assumptions.add('Time not specified; set default 09:00 AM');
    } else if (targetDate == null && targetTime != null) {
      final candidate = DateTime(
        now.year,
        now.month,
        now.day,
        targetTime.hour,
        targetTime.minute,
      );
      if (candidate.isAfter(now)) {
        targetDate = DateTime(now.year, now.month, now.day);
      } else {
        targetDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
        assumptions.add('Time already passed today; set for tomorrow');
      }
    }

    final finalDateTime = DateTime(
      targetDate!.year,
      targetDate.month,
      targetDate.day,
      targetTime!.hour,
      targetTime.minute,
    );

    return _DateTimeResult(
      datetime: finalDateTime,
      dateOnly: dateOnly,
      assumptions: assumptions,
      confidenceAdjustment: confidenceAdjustment,
      remainingText: remaining,
    );
  }

  _WeekdayResult _extractWeekday(String text, DateTime now) {
    final weekdayMap = {
      'monday': DateTime.monday, 'mon': DateTime.monday,
      'tuesday': DateTime.tuesday, 'tue': DateTime.tuesday, 'tues': DateTime.tuesday,
      'wednesday': DateTime.wednesday, 'wed': DateTime.wednesday,
      'thursday': DateTime.thursday, 'thu': DateTime.thursday, 'thur': DateTime.thursday, 'thurs': DateTime.thursday,
      'friday': DateTime.friday, 'fri': DateTime.friday,
      'saturday': DateTime.saturday, 'sat': DateTime.saturday,
      'sunday': DateTime.sunday, 'sun': DateTime.sunday,
    };

    final regexNext = RegExp(
        r'\b(?:next|this)?\s*(monday|mon|tuesday|tue|tues|wednesday|wed|thursday|thu|thur|thurs|friday|fri|saturday|sat|sunday|sun)\b',
        caseSensitive: false);
    final match = regexNext.firstMatch(text);
    if (match != null) {
      final fullMatch = match.group(0)!.toLowerCase();
      final dayName = match.group(1)!.toLowerCase();
      final targetWeekday = weekdayMap[dayName]!;

      int daysUntil = targetWeekday - now.weekday;
      if (fullMatch.startsWith('next')) {
        daysUntil = daysUntil <= 0 ? daysUntil + 7 : daysUntil + 7;
      } else {
        if (daysUntil < 0) {
          daysUntil += 7;
        }
      }

      final date = DateTime(now.year, now.month, now.day).add(Duration(days: daysUntil));
      final cleaned = text.replaceRange(match.start, match.end, '');
      return _WeekdayResult(date: date, remainingText: cleaned);
    }

    return _WeekdayResult(date: null, remainingText: text);
  }

  _SpecificDateResult _extractSpecificDate(String text, DateTime now) {
    final monthMap = {
      'january': 1, 'jan': 1,
      'february': 2, 'feb': 2,
      'march': 3, 'mar': 3,
      'april': 4, 'apr': 4,
      'may': 5,
      'june': 6, 'jun': 6,
      'july': 7, 'jul': 7,
      'august': 8, 'aug': 8,
      'september': 9, 'sep': 9, 'sept': 9,
      'october': 10, 'oct': 10,
      'november': 11, 'nov': 11,
      'december': 12, 'dec': 12,
    };

    final regexMonthDate = RegExp(
      r'\b(?:on\s+)?(?:(\d{1,2})(?:st|nd|rd|th)?\s+([a-z]+)|([a-z]+)\s+(\d{1,2})(?:st|nd|rd|th)?)\b',
      caseSensitive: false,
    );

    final monthMatch = regexMonthDate.firstMatch(text);
    if (monthMatch != null) {
      int day;
      int month;
      if (monthMatch.group(1) != null && monthMatch.group(2) != null) {
        day = int.parse(monthMatch.group(1)!);
        month = monthMap[monthMatch.group(2)!.toLowerCase()] ?? 0;
      } else {
        month = monthMap[monthMatch.group(3)!.toLowerCase()] ?? 0;
        day = int.parse(monthMatch.group(4)!);
      }

      if (month > 0 && day >= 1 && day <= 31) {
        var year = now.year;
        var date = DateTime(year, month, day);
        if (date.isBefore(DateTime(now.year, now.month, now.day))) {
          date = DateTime(year + 1, month, day);
        }
        final cleaned = text.replaceRange(monthMatch.start, monthMatch.end, '');
        return _SpecificDateResult(date: date, remainingText: cleaned);
      }
    }

    final matchNth = RegExp(r'\b(?:on\s+(?:the\s+)?)?(\d{1,2})(?:st|nd|rd|th)\b', caseSensitive: false).firstMatch(text);
    if (matchNth != null) {
      final day = int.parse(matchNth.group(1)!);
      if (day >= 1 && day <= 31) {
        var year = now.year;
        var month = now.month;
        if (day < now.day) {
          month += 1;
          if (month > 12) {
            month = 1;
            year += 1;
          }
        }
        final date = DateTime(year, month, day);
        final cleaned = text.replaceRange(matchNth.start, matchNth.end, '');
        return _SpecificDateResult(date: date, remainingText: cleaned);
      }
    }

    return _SpecificDateResult(date: null, remainingText: text);
  }

  _ExplicitTimeResult _extractExplicitTime(String text) {
    final regexColon = RegExp(r'\b(?:at\s+)?(\d{1,2}):(\d{2})\s*(am|pm)?\b', caseSensitive: false);
    final matchColon = regexColon.firstMatch(text);
    if (matchColon != null) {
      int hour = int.parse(matchColon.group(1)!);
      final minute = int.parse(matchColon.group(2)!);
      final ampm = matchColon.group(3)?.toLowerCase();

      if (ampm == 'pm' && hour < 12) hour += 12;
      if (ampm == 'am' && hour == 12) hour = 0;

      final time = TimeOfDay(hour: hour, minute: minute);
      final cleaned = text.replaceRange(matchColon.start, matchColon.end, '');
      return _ExplicitTimeResult(time: time, remainingText: cleaned);
    }

    final regexAmPm = RegExp(r'\b(?:at\s+)?(\d{1,2})\s*(am|pm|o\x27clock|o’clock)\b', caseSensitive: false);
    final matchAmPm = regexAmPm.firstMatch(text);
    if (matchAmPm != null) {
      int hour = int.parse(matchAmPm.group(1)!);
      final ampm = matchAmPm.group(2)!.toLowerCase();

      if (ampm == 'pm' && hour < 12) hour += 12;
      if (ampm == 'am' && hour == 12) hour = 0;
      if (ampm.contains('clock') && hour >= 1 && hour <= 6) hour += 12;

      final time = TimeOfDay(hour: hour, minute: 0);
      final cleaned = text.replaceRange(matchAmPm.start, matchAmPm.end, '');
      return _ExplicitTimeResult(time: time, remainingText: cleaned);
    }

    final regexAtBare = RegExp(r'\bat\s+(\d{1,2})\b', caseSensitive: false);
    final matchBare = regexAtBare.firstMatch(text);
    if (matchBare != null) {
      int hour = int.parse(matchBare.group(1)!);
      if (hour >= 1 && hour <= 12) {
        if (hour >= 1 && hour <= 6) hour += 12;
        final time = TimeOfDay(hour: hour, minute: 0);
        final cleaned = text.replaceRange(matchBare.start, matchBare.end, '');
        return _ExplicitTimeResult(time: time, remainingText: cleaned);
      }
    }

    return _ExplicitTimeResult(time: null, remainingText: text);
  }

  _PersonResult _extractPerson(String text) {
    final regexPerson = RegExp(
      r'\b(?:call|tell|meet|email|ask|remind|talk to|with|promise|promised)\s+([A-Za-z]+)\b',
      caseSensitive: false,
    );
    final matches = regexPerson.allMatches(text);
    const exclusions = {'me', 'the', 'my', 'about', 'on', 'at', 'in', 'today', 'tomorrow', 'tonight', 'to'};
    for (final match in matches) {
      final name = match.group(1)!;
      if (!exclusions.contains(name.toLowerCase())) {
        final formattedName = name[0].toUpperCase() + name.substring(1).toLowerCase();
        return _PersonResult(person: formattedName);
      }
    }
    return const _PersonResult(person: null);
  }

  bool _isCommitment(String text, String? person) {
    if (person != null) {
      if (RegExp(r'\b(?:promised?|said i would|agreed to|committed|told)\b', caseSensitive: false)
          .hasMatch(text)) {
        return true;
      }
      if (RegExp(r'\b(?:call|meet|pay|send|submit|return|about rent)\b', caseSensitive: false)
          .hasMatch(text)) {
        return true;
      }
    }
    return RegExp(r'\b(?:promise|promised|commitment|promised to)\b', caseSensitive: false)
        .hasMatch(text);
  }

  bool _isHighPriorityKeyword(String text) {
    return RegExp(
      r'\b(?:important|urgent|must|don\x27t forget|don’t forget|critical|asap)\b',
      caseSensitive: false,
    ).hasMatch(text);
  }

  String _cleanTitle(String text, String raw, String? person) {
    var cleaned = text
        .replaceAll(RegExp(r'\b(at|on|by|in|for)\s*$', caseSensitive: false), '')
        .replaceAll(RegExp(r'^\s*(remind me to|remind me|don\x27t forget to|don’t forget to|remember to)\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleaned.isEmpty) {
      cleaned = raw.trim();
    }

    if (cleaned.isNotEmpty) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    if (person != null && person.isNotEmpty) {
      final regPerson = RegExp('\\b' + person + '\\b', caseSensitive: false);
      cleaned = cleaned.replaceAllMapped(regPerson, (m) => person);
    }

    return cleaned;
  }
}

class _RepeatResult {
  final RepeatRule rule;
  final String remainingText;
  _RepeatResult(this.rule, this.remainingText);
}

class _RelativeResult {
  final DateTime? datetime;
  final bool matched;
  final String remainingText;
  _RelativeResult({required this.datetime, required this.matched, required this.remainingText});
}

class _DateTimeResult {
  final DateTime? datetime;
  final bool dateOnly;
  final List<String> assumptions;
  final double confidenceAdjustment;
  final String remainingText;
  _DateTimeResult({
    required this.datetime,
    required this.dateOnly,
    required this.assumptions,
    required this.confidenceAdjustment,
    required this.remainingText,
  });
}

class _WeekdayResult {
  final DateTime? date;
  final String remainingText;
  _WeekdayResult({required this.date, required this.remainingText});
}

class _SpecificDateResult {
  final DateTime? date;
  final String remainingText;
  _SpecificDateResult({required this.date, required this.remainingText});
}

class _ExplicitTimeResult {
  final TimeOfDay? time;
  final String remainingText;
  _ExplicitTimeResult({required this.time, required this.remainingText});
}

class _PersonResult {
  final String? person;
  const _PersonResult({this.person});
}
