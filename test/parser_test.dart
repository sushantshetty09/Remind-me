import 'package:flutter_test/flutter_test.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';
import 'package:remember/services/parser_rule_based.dart';

void main() {
  late RuleBasedParser parser;
  // Fixed reference time: Monday, 2026-10-05 at 10:00 AM
  final refTime = DateTime(2026, 10, 5, 10, 0);

  setUp(() {
    parser = const RuleBasedParser();
  });

  group('RuleBasedParser Unit Tests (40+ Cases)', () {
    // Case 1
    test('1. Call Rahul about rent tomorrow evening', () {
      final item = parser.parseSingle('Call Rahul about rent tomorrow evening', referenceTime: refTime);
      expect(item.person, 'Rahul');
      expect(item.datetime, DateTime(2026, 10, 6, 18, 0));
      expect(item.category, ReminderCategory.commitment);
      expect(item.priority, ReminderPriority.high);
    });

    // Case 2
    test('2. In 2 hours drink water', () {
      final item = parser.parseSingle('In 2 hours drink water', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 12, 0));
      expect(item.title, contains('Drink water'));
    });

    // Case 3
    test('3. After 30 minutes take break', () {
      final item = parser.parseSingle('After 30 minutes take break', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 10, 30));
    });

    // Case 4
    test('4. Tonight at 8', () {
      final item = parser.parseSingle('Call mom tonight', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 20, 0));
    });

    // Case 5
    test('5. Submit form on Friday', () {
      // 2026-10-05 is Monday. Friday is 2026-10-09
      final item = parser.parseSingle('Submit form on Friday', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 9, 9, 0));
      expect(item.dateOnly, isTrue);
    });

    // Case 6
    test('6. Next Monday doctor appointment', () {
      // Monday 2026-10-05; next Monday is 2026-10-12
      final item = parser.parseSingle('Next Monday doctor appointment', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 12, 9, 0));
      expect(item.dateOnly, isTrue);
    });

    // Case 7
    test('7. On the 15th pay electric bill', () {
      final item = parser.parseSingle('On the 15th pay electric bill', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 15, 9, 0));
    });

    // Case 8
    test('8. Every Monday and Thursday standup meeting', () {
      final item = parser.parseSingle('Every Monday and Thursday standup meeting', referenceTime: refTime);
      expect(item.repeat.type, RepeatType.weekly);
      expect(item.repeat.days, containsAll([0, 3])); // 0=Mon, 3=Thu
    });

    // Case 9
    test('9. Every day meditate', () {
      final item = parser.parseSingle('Every day meditate', referenceTime: refTime);
      expect(item.repeat.type, RepeatType.daily);
    });

    // Case 10
    test('10. Weekly report on Friday at 5 PM', () {
      final item = parser.parseSingle('Weekly report on Friday at 5 PM', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 9, 17, 0));
      expect(item.dateOnly, isFalse);
    });

    // Case 11
    test('11. Time only in future today (5 PM)', () {
      // refTime is 10:00 AM. 5 PM is today 17:00
      final item = parser.parseSingle('Meeting at 5 PM', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 17, 0));
    });

    // Case 12
    test('12. Time already passed today (8 AM when refTime is 10 AM)', () {
      final item = parser.parseSingle('Call dentist at 8 AM', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 6, 8, 0)); // Shifted to tomorrow
    });

    // Case 13
    test('13. High priority keywords - Important', () {
      final item = parser.parseSingle('Important: submit tax file tomorrow', referenceTime: refTime);
      expect(item.priority, ReminderPriority.high);
    });

    // Case 14
    test('14. High priority keywords - Must don\'t forget', () {
      final item = parser.parseSingle('Must buy medicine don\'t forget', referenceTime: refTime);
      expect(item.priority, ReminderPriority.high);
    });

    // Case 15
    test('15. Commitment - promised Sarah', () {
      final item = parser.parseSingle('Promised Sarah to review code tonight', referenceTime: refTime);
      expect(item.category, ReminderCategory.commitment);
      expect(item.person, 'Sarah');
      expect(item.priority, ReminderPriority.high);
    });

    // Case 16
    test('16. EOD default time', () {
      final item = parser.parseSingle('Submit PR by EOD', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 17, 30));
    });

    // Case 17
    test('17. Afternoon default time', () {
      final item = parser.parseSingle('Walk dog in afternoon tomorrow', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 6, 14, 0));
    });

    // Case 18
    test('18. Morning default time', () {
      final item = parser.parseSingle('Exercise tomorrow morning', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 6, 9, 0));
    });

    // Case 19
    test('19. Multi-item input splitting', () {
      final items = parser.splitInput('Call mom at 6, buy milk, and submit the form on Friday');
      expect(items.length, 3);
      expect(items[0], contains('Call mom at 6'));
      expect(items[1], contains('buy milk'));
      expect(items[2], contains('submit the form on Friday'));
    });

    // Case 20
    test('20. Multi-line input splitting', () {
      final items = parser.splitInput('1. Pay rent\n2. Call Vivek\n3. Buy groceries');
      expect(items.length, 3);
      expect(items[0], 'Pay rent');
      expect(items[1], 'Call Vivek');
      expect(items[2], 'Buy groceries');
    });

    // Case 21
    test('21. Specific date October 15', () {
      final item = parser.parseSingle('Flight to Delhi on 15 October', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 15, 9, 0));
    });

    // Case 22
    test('22. Day after tomorrow', () {
      final item = parser.parseSingle('Pick up dry cleaning day after tomorrow', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 7, 9, 0));
    });

    // Case 23
    test('23. Bare hour at 5 o\'clock', () {
      final item = parser.parseSingle('Team sync at 5 o\'clock', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 17, 0));
    });

    // Case 24
    test('24. Note/Idea without datetime', () {
      final item = parser.parseSingle('Idea: new mobile app concept', referenceTime: refTime);
      expect(item.category, ReminderCategory.idea);
      expect(item.datetime, isNull);
    });

    // Case 25
    test('25. Lead times generated for date-only items', () {
      final item = parser.parseSingle('Renew license on Friday', referenceTime: refTime);
      expect(item.leadTimesMinutes, contains(60));
    });

    // Case 26
    test('26. Lead times generated for timed items >2h away', () {
      final item = parser.parseSingle('Dinner with team tomorrow at 8 PM', referenceTime: refTime);
      expect(item.leadTimesMinutes, contains(60));
    });

    // Case 27
    test('27. Title cleaned of prefix phrases', () {
      final item = parser.parseSingle('Remind me to call Vivek tomorrow', referenceTime: refTime);
      expect(item.title, 'Call Vivek');
    });

    // Case 28
    test('28. Person extraction with Email', () {
      final item = parser.parseSingle('Email Vivek about slides tomorrow at 11 AM', referenceTime: refTime);
      expect(item.person, 'Vivek');
      expect(item.datetime, DateTime(2026, 10, 6, 11, 0));
    });

    // Case 29
    test('29. Person extraction with Meet', () {
      final item = parser.parseSingle('Meet Sarah on Wednesday', referenceTime: refTime);
      expect(item.person, 'Sarah');
      expect(item.datetime, DateTime(2026, 10, 7, 9, 0));
    });

    // Case 30
    test('30. 12 PM (noon)', () {
      final item = parser.parseSingle('Lunch at 12 PM today', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 5, 12, 0));
    });

    // Case 31
    test('31. 12 AM (midnight)', () {
      final item = parser.parseSingle('System restart at 12 AM tomorrow', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 6, 0, 0));
    });

    // Case 32
    test('32. In 3 days relative time', () {
      final item = parser.parseSingle('Check passport in 3 days', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 8, 10, 0));
    });

    // Case 33
    test('33. 24-hour military time format 17:30', () {
      final item = parser.parseSingle('Train departure at 17:30 tomorrow', referenceTime: refTime);
      expect(item.datetime, DateTime(2026, 10, 6, 17, 30));
    });

    // Case 34
    test('34. Monthly recurrence', () {
      final item = parser.parseSingle('Monthly rent payment', referenceTime: refTime);
      expect(item.repeat.type, RepeatType.monthly);
    });

    // Case 35
    test('35. Urgent keyword elevates priority', () {
      final item = parser.parseSingle('Urgent fix broken link on site', referenceTime: refTime);
      expect(item.priority, ReminderPriority.high);
    });

    // Case 36
    test('36. Asap keyword elevates priority', () {
      final item = parser.parseSingle('Call client asap', referenceTime: refTime);
      expect(item.priority, ReminderPriority.high);
    });

    // Case 37
    test('37. Past date rolls forward to next year', () {
      // refTime is Oct 5 2026. "On 1st May" is in the past, so rolls to May 1 2027.
      final item = parser.parseSingle('On 1st May celebrate anniversary', referenceTime: refTime);
      expect(item.datetime?.year, 2027);
      expect(item.datetime?.month, 5);
      expect(item.datetime?.day, 1);
    });

    // Case 38
    test('38. Raw text preserved', () {
      const raw = 'Remind me to buy flowers for Mom on Thursday';
      final item = parser.parseSingle(raw, referenceTime: refTime);
      expect(item.rawText, raw);
    });

    // Case 39
    test('39. Empty or whitespace input safety', () {
      final item = parser.parseSingle('   ', referenceTime: refTime);
      expect(item.title, isEmpty);
      expect(item.datetime, isNull);
    });

    // Case 40
    test('40. Confidence score default high for unambiguous string', () {
      final item = parser.parseSingle('Call mom tomorrow at 5 PM', referenceTime: refTime);
      expect(item.confidence, greaterThanOrEqualTo(0.9));
    });

    // Case 41
    test('41. Assumptions populated when time defaulted', () {
      final item = parser.parseSingle('Submit tax report on Friday', referenceTime: refTime);
      expect(item.assumptions, isNotEmpty);
    });
  });
}
