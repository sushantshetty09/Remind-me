import 'package:drift/drift.dart';

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get rawText => text()();
  DateTimeColumn get datetimeUtc => dateTime().nullable()();
  BoolColumn get dateOnly => boolean().withDefault(const Constant(false))();
  TextColumn get repeatJson => text().nullable()(); // JSON string for repeat rules
  TextColumn get person => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('task'))(); // commitment, task, event, idea, note
  TextColumn get priority => text().withDefault(const Constant('normal'))(); // normal, high
  TextColumn get leadTimesJson => text().nullable()(); // JSON list of lead minutes
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, done, snoozed, dismissed
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  IntColumn get escalationCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get notificationIdsJson => text().nullable()(); // JSON list of scheduled notification IDs
  IntColumn get noteId => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [];
}
