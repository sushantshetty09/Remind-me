import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/data/database/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  Future<String?> getString(String key, {String? defaultValue}) async {
    final value = await _db.getSetting(key);
    return value ?? defaultValue;
  }

  Future<void> setString(String key, String value) async {
    await _db.setSetting(key, value);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final value = await _db.getSetting(key);
    if (value == null) return defaultValue;
    return value == 'true';
  }

  Future<void> setBool(String key, bool value) async {
    await _db.setSetting(key, value.toString());
  }

  // Get daypart defaults (e.g., "09:00" -> TimeOfDay or DateTime)
  Future<Map<String, String>> getDaypartDefaults() async {
    final morning = await getString(AppConstants.keyMorningDefaultTime, defaultValue: '09:00');
    final afternoon = await getString(AppConstants.keyAfternoonDefaultTime, defaultValue: '14:00');
    final evening = await getString(AppConstants.keyEveningDefaultTime, defaultValue: '18:00');
    final tonight = await getString(AppConstants.keyTonightDefaultTime, defaultValue: '20:00');
    final eod = await getString(AppConstants.keyEodDefaultTime, defaultValue: '17:30');

    return {
      'morning': morning!,
      'afternoon': afternoon!,
      'evening': evening!,
      'tonight': tonight!,
      'eod': eod!,
    };
  }
}
