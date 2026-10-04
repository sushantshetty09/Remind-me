import 'package:flutter_test/flutter_test.dart';
import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';
import 'package:remember/services/scheduler_service.dart';

void main() {
  group('SchedulerService & Deterministic Notification IDs', () {
    test('generateNotificationId returns consistent deterministic hashes', () {
      final id1 = SchedulerService.generateNotificationId(42, 'main', 0);
      final id2 = SchedulerService.generateNotificationId(42, 'main', 0);
      final id3 = SchedulerService.generateNotificationId(42, 'lead', 0);

      expect(id1, equals(id2));
      expect(id1, isNot(equals(id3)));
      expect(id1, greaterThanOrEqualTo(0));
    });
  });
}
