import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:remember/core/theme/app_theme.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/scheduler_service.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final int reminderId;

  const ItemDetailScreen({super.key, required this.reminderId});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  ReminderItem? _reminder;
  NoteItem? _note;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final reminderRepo = ref.read(reminderRepositoryProvider);
    final noteRepo = ref.read(noteRepositoryProvider);

    final item = await reminderRepo.getReminderById(widget.reminderId);
    NoteItem? note;
    if (item != null) {
      note = await noteRepo.getNoteByReminderId(item.id);
    }

    setState(() {
      _reminder = item;
      _note = note;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reminder Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_reminder == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reminder Detail')),
        body: const Center(child: Text('Reminder not found')),
      );
    }

    final reminder = _reminder!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final reminderRepo = ref.read(reminderRepositoryProvider);
              final settingsRepo = ref.read(settingsRepositoryProvider);
              final scheduler = SchedulerService(reminderRepo, settingsRepo, NotificationService());

              await scheduler.cancelReminderNotifications(reminder);
              await reminderRepo.deleteReminder(reminder.id);

              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (reminder.isCommitment)
                        const Chip(
                          label: Text('Commitment', style: TextStyle(color: Colors.white)),
                          backgroundColor: AppTheme.commitmentColor,
                        ),
                      if (reminder.isHighPriority && !reminder.isCommitment)
                        Chip(
                          label: const Text('High Priority'),
                          backgroundColor: Colors.amber.shade200,
                        ),
                      const Spacer(),
                      Chip(
                        label: Text(reminder.status.name.toUpperCase()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (reminder.datetimeUtc != null)
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy • h:mm a')
                              .format(reminder.datetimeUtc!.toLocal()),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  if (reminder.person != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('Person: ${reminder.person!}'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_note != null) ...[
            const Text(
              'Associated Note',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _note!.body,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Created: ${DateFormat('d MMM yyyy, h:mm a').format(_note!.createdAt.toLocal())}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
