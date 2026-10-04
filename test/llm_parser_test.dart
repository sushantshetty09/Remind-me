import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remember/data/database/app_database.dart';
import 'package:remember/data/repositories/settings_repository.dart';
import 'package:remember/services/parser_llm.dart';
import 'package:remember/services/parser_rule_based.dart';

void main() {
  test('LlmParserService falls back silently to Layer 1 when disabled', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final settingsRepo = SettingsRepository(db);
    final ruleBasedParser = const RuleBasedParser();
    final llmService = LlmParserService(settingsRepo, ruleBasedParser);

    final refTime = DateTime(2026, 10, 5, 10, 0);
    final items = await llmService.parse('Call Rahul about rent tomorrow evening', referenceTime: refTime);

    expect(items.length, 1);
    expect(items.first.title, contains('Call Rahul'));
    expect(items.first.person, 'Rahul');

    await db.close();
  });
}
