class AppConstants {
  static const String appName = 'Remember';

  // Storage keys
  static const String keyVoiceLocale = 'voice_locale';
  static const String keyMorningBriefingTime = 'morning_briefing_time'; // Default "08:00"
  static const String keyEveningReviewTime = 'evening_review_time';   // Default "21:00"
  static const String keyAutoSaveConfirmCard = 'auto_save_confirm_card'; // Default false
  static const String keyEnableLlmParser = 'enable_llm_parser'; // Default false
  static const String keyLlmProvider = 'llm_provider'; // Default OpenAI / custom
  static const String keyLlmEndpoint = 'llm_endpoint';
  static const String keyAutoExportFolder = 'auto_export_folder';

  // Daypart defaults (24-hour format HH:mm)
  static const String keyMorningDefaultTime = 'morning_default_time'; // 09:00
  static const String keyAfternoonDefaultTime = 'afternoon_default_time'; // 14:00
  static const String keyEveningDefaultTime = 'evening_default_time'; // 18:00
  static const String keyTonightDefaultTime = 'tonight_default_time'; // 20:00
  static const String keyEodDefaultTime = 'eod_default_time'; // 17:30

  // Secure storage keys
  static const String secureKeyLlmApiKey = 'llm_api_key';

  // Notification Channel IDs
  static const String channelReminders = 'reminders_channel';
  static const String channelEscalations = 'escalations_channel';
  static const String channelBriefings = 'briefings_channel';
}
