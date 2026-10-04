// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rawTextMeta =
      const VerificationMeta('rawText');
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
      'raw_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _datetimeUtcMeta =
      const VerificationMeta('datetimeUtc');
  @override
  late final GeneratedColumn<DateTime> datetimeUtc = GeneratedColumn<DateTime>(
      'datetime_utc', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateOnlyMeta =
      const VerificationMeta('dateOnly');
  @override
  late final GeneratedColumn<bool> dateOnly = GeneratedColumn<bool>(
      'date_only', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("date_only" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _repeatJsonMeta =
      const VerificationMeta('repeatJson');
  @override
  late final GeneratedColumn<String> repeatJson = GeneratedColumn<String>(
      'repeat_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
      'person', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('task'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normal'));
  static const VerificationMeta _leadTimesJsonMeta =
      const VerificationMeta('leadTimesJson');
  @override
  late final GeneratedColumn<String> leadTimesJson = GeneratedColumn<String>(
      'lead_times_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _snoozedUntilMeta =
      const VerificationMeta('snoozedUntil');
  @override
  late final GeneratedColumn<DateTime> snoozedUntil = GeneratedColumn<DateTime>(
      'snoozed_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _escalationCountMeta =
      const VerificationMeta('escalationCount');
  @override
  late final GeneratedColumn<int> escalationCount = GeneratedColumn<int>(
      'escalation_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notificationIdsJsonMeta =
      const VerificationMeta('notificationIdsJson');
  @override
  late final GeneratedColumn<String> notificationIdsJson =
      GeneratedColumn<String>('notification_ids_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<int> noteId = GeneratedColumn<int>(
      'note_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        rawText,
        datetimeUtc,
        dateOnly,
        repeatJson,
        person,
        category,
        priority,
        leadTimesJson,
        status,
        snoozedUntil,
        escalationCount,
        createdAt,
        completedAt,
        notificationIdsJson,
        noteId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('raw_text')) {
      context.handle(_rawTextMeta,
          rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta));
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('datetime_utc')) {
      context.handle(
          _datetimeUtcMeta,
          datetimeUtc.isAcceptableOrUnknown(
              data['datetime_utc']!, _datetimeUtcMeta));
    }
    if (data.containsKey('date_only')) {
      context.handle(_dateOnlyMeta,
          dateOnly.isAcceptableOrUnknown(data['date_only']!, _dateOnlyMeta));
    }
    if (data.containsKey('repeat_json')) {
      context.handle(
          _repeatJsonMeta,
          repeatJson.isAcceptableOrUnknown(
              data['repeat_json']!, _repeatJsonMeta));
    }
    if (data.containsKey('person')) {
      context.handle(_personMeta,
          person.isAcceptableOrUnknown(data['person']!, _personMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('lead_times_json')) {
      context.handle(
          _leadTimesJsonMeta,
          leadTimesJson.isAcceptableOrUnknown(
              data['lead_times_json']!, _leadTimesJsonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
          _snoozedUntilMeta,
          snoozedUntil.isAcceptableOrUnknown(
              data['snoozed_until']!, _snoozedUntilMeta));
    }
    if (data.containsKey('escalation_count')) {
      context.handle(
          _escalationCountMeta,
          escalationCount.isAcceptableOrUnknown(
              data['escalation_count']!, _escalationCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('notification_ids_json')) {
      context.handle(
          _notificationIdsJsonMeta,
          notificationIdsJson.isAcceptableOrUnknown(
              data['notification_ids_json']!, _notificationIdsJsonMeta));
    }
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      rawText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_text'])!,
      datetimeUtc: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime_utc']),
      dateOnly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}date_only'])!,
      repeatJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat_json']),
      person: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      leadTimesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lead_times_json']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      snoozedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}snoozed_until']),
      escalationCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}escalation_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      notificationIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_ids_json']),
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}note_id']),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final String title;
  final String rawText;
  final DateTime? datetimeUtc;
  final bool dateOnly;
  final String? repeatJson;
  final String? person;
  final String category;
  final String priority;
  final String? leadTimesJson;
  final String status;
  final DateTime? snoozedUntil;
  final int escalationCount;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notificationIdsJson;
  final int? noteId;
  const Reminder(
      {required this.id,
      required this.title,
      required this.rawText,
      this.datetimeUtc,
      required this.dateOnly,
      this.repeatJson,
      this.person,
      required this.category,
      required this.priority,
      this.leadTimesJson,
      required this.status,
      this.snoozedUntil,
      required this.escalationCount,
      required this.createdAt,
      this.completedAt,
      this.notificationIdsJson,
      this.noteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['raw_text'] = Variable<String>(rawText);
    if (!nullToAbsent || datetimeUtc != null) {
      map['datetime_utc'] = Variable<DateTime>(datetimeUtc);
    }
    map['date_only'] = Variable<bool>(dateOnly);
    if (!nullToAbsent || repeatJson != null) {
      map['repeat_json'] = Variable<String>(repeatJson);
    }
    if (!nullToAbsent || person != null) {
      map['person'] = Variable<String>(person);
    }
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || leadTimesJson != null) {
      map['lead_times_json'] = Variable<String>(leadTimesJson);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil);
    }
    map['escalation_count'] = Variable<int>(escalationCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || notificationIdsJson != null) {
      map['notification_ids_json'] = Variable<String>(notificationIdsJson);
    }
    if (!nullToAbsent || noteId != null) {
      map['note_id'] = Variable<int>(noteId);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      rawText: Value(rawText),
      datetimeUtc: datetimeUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(datetimeUtc),
      dateOnly: Value(dateOnly),
      repeatJson: repeatJson == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatJson),
      person:
          person == null && nullToAbsent ? const Value.absent() : Value(person),
      category: Value(category),
      priority: Value(priority),
      leadTimesJson: leadTimesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(leadTimesJson),
      status: Value(status),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      escalationCount: Value(escalationCount),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notificationIdsJson: notificationIdsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationIdsJson),
      noteId:
          noteId == null && nullToAbsent ? const Value.absent() : Value(noteId),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      rawText: serializer.fromJson<String>(json['rawText']),
      datetimeUtc: serializer.fromJson<DateTime?>(json['datetimeUtc']),
      dateOnly: serializer.fromJson<bool>(json['dateOnly']),
      repeatJson: serializer.fromJson<String?>(json['repeatJson']),
      person: serializer.fromJson<String?>(json['person']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<String>(json['priority']),
      leadTimesJson: serializer.fromJson<String?>(json['leadTimesJson']),
      status: serializer.fromJson<String>(json['status']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      escalationCount: serializer.fromJson<int>(json['escalationCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      notificationIdsJson:
          serializer.fromJson<String?>(json['notificationIdsJson']),
      noteId: serializer.fromJson<int?>(json['noteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'rawText': serializer.toJson<String>(rawText),
      'datetimeUtc': serializer.toJson<DateTime?>(datetimeUtc),
      'dateOnly': serializer.toJson<bool>(dateOnly),
      'repeatJson': serializer.toJson<String?>(repeatJson),
      'person': serializer.toJson<String?>(person),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<String>(priority),
      'leadTimesJson': serializer.toJson<String?>(leadTimesJson),
      'status': serializer.toJson<String>(status),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'escalationCount': serializer.toJson<int>(escalationCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'notificationIdsJson': serializer.toJson<String?>(notificationIdsJson),
      'noteId': serializer.toJson<int?>(noteId),
    };
  }

  Reminder copyWith(
          {int? id,
          String? title,
          String? rawText,
          Value<DateTime?> datetimeUtc = const Value.absent(),
          bool? dateOnly,
          Value<String?> repeatJson = const Value.absent(),
          Value<String?> person = const Value.absent(),
          String? category,
          String? priority,
          Value<String?> leadTimesJson = const Value.absent(),
          String? status,
          Value<DateTime?> snoozedUntil = const Value.absent(),
          int? escalationCount,
          DateTime? createdAt,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> notificationIdsJson = const Value.absent(),
          Value<int?> noteId = const Value.absent()}) =>
      Reminder(
        id: id ?? this.id,
        title: title ?? this.title,
        rawText: rawText ?? this.rawText,
        datetimeUtc: datetimeUtc.present ? datetimeUtc.value : this.datetimeUtc,
        dateOnly: dateOnly ?? this.dateOnly,
        repeatJson: repeatJson.present ? repeatJson.value : this.repeatJson,
        person: person.present ? person.value : this.person,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        leadTimesJson:
            leadTimesJson.present ? leadTimesJson.value : this.leadTimesJson,
        status: status ?? this.status,
        snoozedUntil:
            snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
        escalationCount: escalationCount ?? this.escalationCount,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        notificationIdsJson: notificationIdsJson.present
            ? notificationIdsJson.value
            : this.notificationIdsJson,
        noteId: noteId.present ? noteId.value : this.noteId,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      datetimeUtc:
          data.datetimeUtc.present ? data.datetimeUtc.value : this.datetimeUtc,
      dateOnly: data.dateOnly.present ? data.dateOnly.value : this.dateOnly,
      repeatJson:
          data.repeatJson.present ? data.repeatJson.value : this.repeatJson,
      person: data.person.present ? data.person.value : this.person,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      leadTimesJson: data.leadTimesJson.present
          ? data.leadTimesJson.value
          : this.leadTimesJson,
      status: data.status.present ? data.status.value : this.status,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      escalationCount: data.escalationCount.present
          ? data.escalationCount.value
          : this.escalationCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      notificationIdsJson: data.notificationIdsJson.present
          ? data.notificationIdsJson.value
          : this.notificationIdsJson,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rawText: $rawText, ')
          ..write('datetimeUtc: $datetimeUtc, ')
          ..write('dateOnly: $dateOnly, ')
          ..write('repeatJson: $repeatJson, ')
          ..write('person: $person, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('leadTimesJson: $leadTimesJson, ')
          ..write('status: $status, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('escalationCount: $escalationCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notificationIdsJson: $notificationIdsJson, ')
          ..write('noteId: $noteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      rawText,
      datetimeUtc,
      dateOnly,
      repeatJson,
      person,
      category,
      priority,
      leadTimesJson,
      status,
      snoozedUntil,
      escalationCount,
      createdAt,
      completedAt,
      notificationIdsJson,
      noteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.title == this.title &&
          other.rawText == this.rawText &&
          other.datetimeUtc == this.datetimeUtc &&
          other.dateOnly == this.dateOnly &&
          other.repeatJson == this.repeatJson &&
          other.person == this.person &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.leadTimesJson == this.leadTimesJson &&
          other.status == this.status &&
          other.snoozedUntil == this.snoozedUntil &&
          other.escalationCount == this.escalationCount &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt &&
          other.notificationIdsJson == this.notificationIdsJson &&
          other.noteId == this.noteId);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> rawText;
  final Value<DateTime?> datetimeUtc;
  final Value<bool> dateOnly;
  final Value<String?> repeatJson;
  final Value<String?> person;
  final Value<String> category;
  final Value<String> priority;
  final Value<String?> leadTimesJson;
  final Value<String> status;
  final Value<DateTime?> snoozedUntil;
  final Value<int> escalationCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<String?> notificationIdsJson;
  final Value<int?> noteId;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.rawText = const Value.absent(),
    this.datetimeUtc = const Value.absent(),
    this.dateOnly = const Value.absent(),
    this.repeatJson = const Value.absent(),
    this.person = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.leadTimesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.escalationCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notificationIdsJson = const Value.absent(),
    this.noteId = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String rawText,
    this.datetimeUtc = const Value.absent(),
    this.dateOnly = const Value.absent(),
    this.repeatJson = const Value.absent(),
    this.person = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.leadTimesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.escalationCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notificationIdsJson = const Value.absent(),
    this.noteId = const Value.absent(),
  })  : title = Value(title),
        rawText = Value(rawText);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? rawText,
    Expression<DateTime>? datetimeUtc,
    Expression<bool>? dateOnly,
    Expression<String>? repeatJson,
    Expression<String>? person,
    Expression<String>? category,
    Expression<String>? priority,
    Expression<String>? leadTimesJson,
    Expression<String>? status,
    Expression<DateTime>? snoozedUntil,
    Expression<int>? escalationCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<String>? notificationIdsJson,
    Expression<int>? noteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (rawText != null) 'raw_text': rawText,
      if (datetimeUtc != null) 'datetime_utc': datetimeUtc,
      if (dateOnly != null) 'date_only': dateOnly,
      if (repeatJson != null) 'repeat_json': repeatJson,
      if (person != null) 'person': person,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (leadTimesJson != null) 'lead_times_json': leadTimesJson,
      if (status != null) 'status': status,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (escalationCount != null) 'escalation_count': escalationCount,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (notificationIdsJson != null)
        'notification_ids_json': notificationIdsJson,
      if (noteId != null) 'note_id': noteId,
    });
  }

  RemindersCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? rawText,
      Value<DateTime?>? datetimeUtc,
      Value<bool>? dateOnly,
      Value<String?>? repeatJson,
      Value<String?>? person,
      Value<String>? category,
      Value<String>? priority,
      Value<String?>? leadTimesJson,
      Value<String>? status,
      Value<DateTime?>? snoozedUntil,
      Value<int>? escalationCount,
      Value<DateTime>? createdAt,
      Value<DateTime?>? completedAt,
      Value<String?>? notificationIdsJson,
      Value<int?>? noteId}) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      rawText: rawText ?? this.rawText,
      datetimeUtc: datetimeUtc ?? this.datetimeUtc,
      dateOnly: dateOnly ?? this.dateOnly,
      repeatJson: repeatJson ?? this.repeatJson,
      person: person ?? this.person,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      leadTimesJson: leadTimesJson ?? this.leadTimesJson,
      status: status ?? this.status,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      escalationCount: escalationCount ?? this.escalationCount,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      notificationIdsJson: notificationIdsJson ?? this.notificationIdsJson,
      noteId: noteId ?? this.noteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (datetimeUtc.present) {
      map['datetime_utc'] = Variable<DateTime>(datetimeUtc.value);
    }
    if (dateOnly.present) {
      map['date_only'] = Variable<bool>(dateOnly.value);
    }
    if (repeatJson.present) {
      map['repeat_json'] = Variable<String>(repeatJson.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (leadTimesJson.present) {
      map['lead_times_json'] = Variable<String>(leadTimesJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil.value);
    }
    if (escalationCount.present) {
      map['escalation_count'] = Variable<int>(escalationCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notificationIdsJson.present) {
      map['notification_ids_json'] =
          Variable<String>(notificationIdsJson.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<int>(noteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rawText: $rawText, ')
          ..write('datetimeUtc: $datetimeUtc, ')
          ..write('dateOnly: $dateOnly, ')
          ..write('repeatJson: $repeatJson, ')
          ..write('person: $person, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('leadTimesJson: $leadTimesJson, ')
          ..write('status: $status, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('escalationCount: $escalationCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notificationIdsJson: $notificationIdsJson, ')
          ..write('noteId: $noteId')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isImportantMeta =
      const VerificationMeta('isImportant');
  @override
  late final GeneratedColumn<bool> isImportant = GeneratedColumn<bool>(
      'is_important', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_important" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<int> reminderId = GeneratedColumn<int>(
      'reminder_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        body,
        summary,
        isImportant,
        tagsJson,
        createdAt,
        updatedAt,
        reminderId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('is_important')) {
      context.handle(
          _isImportantMeta,
          isImportant.isAcceptableOrUnknown(
              data['is_important']!, _isImportantMeta));
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      isImportant: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_important'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_id']),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String body;
  final String? summary;
  final bool isImportant;
  final String? tagsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? reminderId;
  const Note(
      {required this.id,
      required this.body,
      this.summary,
      required this.isImportant,
      this.tagsJson,
      required this.createdAt,
      required this.updatedAt,
      this.reminderId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['is_important'] = Variable<bool>(isImportant);
    if (!nullToAbsent || tagsJson != null) {
      map['tags_json'] = Variable<String>(tagsJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<int>(reminderId);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      body: Value(body),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      isImportant: Value(isImportant),
      tagsJson: tagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tagsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      summary: serializer.fromJson<String?>(json['summary']),
      isImportant: serializer.fromJson<bool>(json['isImportant']),
      tagsJson: serializer.fromJson<String?>(json['tagsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      reminderId: serializer.fromJson<int?>(json['reminderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'body': serializer.toJson<String>(body),
      'summary': serializer.toJson<String?>(summary),
      'isImportant': serializer.toJson<bool>(isImportant),
      'tagsJson': serializer.toJson<String?>(tagsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'reminderId': serializer.toJson<int?>(reminderId),
    };
  }

  Note copyWith(
          {int? id,
          String? body,
          Value<String?> summary = const Value.absent(),
          bool? isImportant,
          Value<String?> tagsJson = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<int?> reminderId = const Value.absent()}) =>
      Note(
        id: id ?? this.id,
        body: body ?? this.body,
        summary: summary.present ? summary.value : this.summary,
        isImportant: isImportant ?? this.isImportant,
        tagsJson: tagsJson.present ? tagsJson.value : this.tagsJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        reminderId: reminderId.present ? reminderId.value : this.reminderId,
      );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      summary: data.summary.present ? data.summary.value : this.summary,
      isImportant:
          data.isImportant.present ? data.isImportant.value : this.isImportant,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('summary: $summary, ')
          ..write('isImportant: $isImportant, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminderId: $reminderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, body, summary, isImportant, tagsJson,
      createdAt, updatedAt, reminderId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.body == this.body &&
          other.summary == this.summary &&
          other.isImportant == this.isImportant &&
          other.tagsJson == this.tagsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.reminderId == this.reminderId);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> body;
  final Value<String?> summary;
  final Value<bool> isImportant;
  final Value<String?> tagsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> reminderId;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.summary = const Value.absent(),
    this.isImportant = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminderId = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required String body,
    this.summary = const Value.absent(),
    this.isImportant = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminderId = const Value.absent(),
  }) : body = Value(body);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<String>? body,
    Expression<String>? summary,
    Expression<bool>? isImportant,
    Expression<String>? tagsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? reminderId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (summary != null) 'summary': summary,
      if (isImportant != null) 'is_important': isImportant,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (reminderId != null) 'reminder_id': reminderId,
    });
  }

  NotesCompanion copyWith(
      {Value<int>? id,
      Value<String>? body,
      Value<String?>? summary,
      Value<bool>? isImportant,
      Value<String?>? tagsJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? reminderId}) {
    return NotesCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      summary: summary ?? this.summary,
      isImportant: isImportant ?? this.isImportant,
      tagsJson: tagsJson ?? this.tagsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderId: reminderId ?? this.reminderId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (isImportant.present) {
      map['is_important'] = Variable<bool>(isImportant.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<int>(reminderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('summary: $summary, ')
          ..write('isImportant: $isImportant, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminderId: $reminderId')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [reminders, notes, settings];
}

typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required String title,
  required String rawText,
  Value<DateTime?> datetimeUtc,
  Value<bool> dateOnly,
  Value<String?> repeatJson,
  Value<String?> person,
  Value<String> category,
  Value<String> priority,
  Value<String?> leadTimesJson,
  Value<String> status,
  Value<DateTime?> snoozedUntil,
  Value<int> escalationCount,
  Value<DateTime> createdAt,
  Value<DateTime?> completedAt,
  Value<String?> notificationIdsJson,
  Value<int?> noteId,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> rawText,
  Value<DateTime?> datetimeUtc,
  Value<bool> dateOnly,
  Value<String?> repeatJson,
  Value<String?> person,
  Value<String> category,
  Value<String> priority,
  Value<String?> leadTimesJson,
  Value<String> status,
  Value<DateTime?> snoozedUntil,
  Value<int> escalationCount,
  Value<DateTime> createdAt,
  Value<DateTime?> completedAt,
  Value<String?> notificationIdsJson,
  Value<int?> noteId,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawText => $composableBuilder(
      column: $table.rawText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datetimeUtc => $composableBuilder(
      column: $table.datetimeUtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dateOnly => $composableBuilder(
      column: $table.dateOnly, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repeatJson => $composableBuilder(
      column: $table.repeatJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get person => $composableBuilder(
      column: $table.person, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get leadTimesJson => $composableBuilder(
      column: $table.leadTimesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get snoozedUntil => $composableBuilder(
      column: $table.snoozedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get escalationCount => $composableBuilder(
      column: $table.escalationCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationIdsJson => $composableBuilder(
      column: $table.notificationIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnFilters(column));
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawText => $composableBuilder(
      column: $table.rawText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datetimeUtc => $composableBuilder(
      column: $table.datetimeUtc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dateOnly => $composableBuilder(
      column: $table.dateOnly, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeatJson => $composableBuilder(
      column: $table.repeatJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get person => $composableBuilder(
      column: $table.person, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get leadTimesJson => $composableBuilder(
      column: $table.leadTimesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get snoozedUntil => $composableBuilder(
      column: $table.snoozedUntil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get escalationCount => $composableBuilder(
      column: $table.escalationCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationIdsJson => $composableBuilder(
      column: $table.notificationIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<DateTime> get datetimeUtc => $composableBuilder(
      column: $table.datetimeUtc, builder: (column) => column);

  GeneratedColumn<bool> get dateOnly =>
      $composableBuilder(column: $table.dateOnly, builder: (column) => column);

  GeneratedColumn<String> get repeatJson => $composableBuilder(
      column: $table.repeatJson, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get leadTimesJson => $composableBuilder(
      column: $table.leadTimesJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get snoozedUntil => $composableBuilder(
      column: $table.snoozedUntil, builder: (column) => column);

  GeneratedColumn<int> get escalationCount => $composableBuilder(
      column: $table.escalationCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get notificationIdsJson => $composableBuilder(
      column: $table.notificationIdsJson, builder: (column) => column);

  GeneratedColumn<int> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> rawText = const Value.absent(),
            Value<DateTime?> datetimeUtc = const Value.absent(),
            Value<bool> dateOnly = const Value.absent(),
            Value<String?> repeatJson = const Value.absent(),
            Value<String?> person = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String?> leadTimesJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> snoozedUntil = const Value.absent(),
            Value<int> escalationCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> notificationIdsJson = const Value.absent(),
            Value<int?> noteId = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            title: title,
            rawText: rawText,
            datetimeUtc: datetimeUtc,
            dateOnly: dateOnly,
            repeatJson: repeatJson,
            person: person,
            category: category,
            priority: priority,
            leadTimesJson: leadTimesJson,
            status: status,
            snoozedUntil: snoozedUntil,
            escalationCount: escalationCount,
            createdAt: createdAt,
            completedAt: completedAt,
            notificationIdsJson: notificationIdsJson,
            noteId: noteId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String rawText,
            Value<DateTime?> datetimeUtc = const Value.absent(),
            Value<bool> dateOnly = const Value.absent(),
            Value<String?> repeatJson = const Value.absent(),
            Value<String?> person = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String?> leadTimesJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> snoozedUntil = const Value.absent(),
            Value<int> escalationCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> notificationIdsJson = const Value.absent(),
            Value<int?> noteId = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            title: title,
            rawText: rawText,
            datetimeUtc: datetimeUtc,
            dateOnly: dateOnly,
            repeatJson: repeatJson,
            person: person,
            category: category,
            priority: priority,
            leadTimesJson: leadTimesJson,
            status: status,
            snoozedUntil: snoozedUntil,
            escalationCount: escalationCount,
            createdAt: createdAt,
            completedAt: completedAt,
            notificationIdsJson: notificationIdsJson,
            noteId: noteId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  required String body,
  Value<String?> summary,
  Value<bool> isImportant,
  Value<String?> tagsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int?> reminderId,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  Value<String> body,
  Value<String?> summary,
  Value<bool> isImportant,
  Value<String?> tagsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int?> reminderId,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isImportant => $composableBuilder(
      column: $table.isImportant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isImportant => $composableBuilder(
      column: $table.isImportant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<bool> get isImportant => $composableBuilder(
      column: $table.isImportant, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<bool> isImportant = const Value.absent(),
            Value<String?> tagsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int?> reminderId = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            body: body,
            summary: summary,
            isImportant: isImportant,
            tagsJson: tagsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            reminderId: reminderId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String body,
            Value<String?> summary = const Value.absent(),
            Value<bool> isImportant = const Value.absent(),
            Value<String?> tagsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int?> reminderId = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            body: body,
            summary: summary,
            isImportant: isImportant,
            tagsJson: tagsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            reminderId: reminderId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
