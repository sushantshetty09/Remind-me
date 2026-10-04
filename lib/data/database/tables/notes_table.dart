import 'package:drift/drift.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get body => text()();
  TextColumn get summary => text().nullable()();
  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();
  TextColumn get tagsJson => text().nullable()(); // JSON list of tags
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get reminderId => integer().nullable()();
}
