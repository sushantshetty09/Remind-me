# Remember - Personal Reminder App

**Remember** is a personal, offline-first Flutter/Android reminder application designed to eliminate capture friction and ensure reliable follow-through.

---

## 🌟 Key Features

1. **< 5-Second Capture:**
   - Tap the mic hero button to speak or type naturally.
   - Multi-task sentence splitting ("Call mom at 6, buy milk, submit form on Friday").
2. **Two-Layer Parser:**
   - **Layer 1 (Offline, On-Device):** Rule-based Dart parser handling relative times ("in 2 hours"), dayparts ("tonight" = 8 PM), dates/weekdays, recurrences, commitments, and person names.
   - **Layer 2 (Optional AI LLM):** User-supplied API key, 3s timeout with silent Layer 1 fallback.
3. **Reliable Escalating Reminders:**
   - On-device exact local alarms via `flutter_local_notifications` and `zonedSchedule`.
   - Pre-reminders for dates and timed items.
   - Escalating alerts (+5m, +15m, +30m, +1h) for commitments and high-priority items until marked Done or Snoozed.
   - Automatic boot, timezone, and update reschedule handler.
4. **Notes Log & Export:**
   - Every captured item creates a searchable note with raw text, parsed summary, and timestamps.
   - Full-text search and filters (Important, Commitments, Done, This week).
   - "Send to Notes" via Android share sheet.
   - Daily Markdown files auto-export folder and full JSON backup/restore.
5. **Reliability Check:**
   - Built-in diagnostic screen for notification permission, exact alarms, and battery optimizations.
   - Brand-specific battery manager guidance (Xiaomi, Oppo, Vivo, Samsung, OnePlus).

---

## 🏗 Architecture

```
lib/
├── core/         # Theme, constants, utilities
├── data/         # Drift SQLite database, DAOs, repositories, mappers
├── domain/       # Models (ReminderItem, NoteItem, ParsedItem, RepeatRule)
├── services/     # NotificationService, SchedulerService, RuleBasedParser, LlmParserService, ReliabilityService, ExportService
└── features/     # Feature screens (Today, Add, Notes, Detail, History, Settings, Reliability)
```

---

## 🔑 Permissions Explained

- `POST_NOTIFICATIONS`: Required on Android 13+ to show reminder alerts and briefings.
- `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`: Ensures notifications trigger at the exact minute specified.
- `RECEIVE_BOOT_COMPLETED`: Reschedules all pending alerts whenever the device reboots.
- `RECORD_AUDIO`: Allows voice capture via on-device speech-to-text.
- `USE_FULL_SCREEN_INTENT`: Enables optional full-screen alarm alerts for critical commitments.

---

## 🚀 Running Tests

Run all unit and widget tests:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```
