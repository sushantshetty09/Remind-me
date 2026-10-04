import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/domain/models/reminder_item.dart';

final completedRemindersProvider = FutureProvider<List<ReminderItem>>((ref) async {
  final reminderRepo = ref.watch(reminderRepositoryProvider);
  return await reminderRepo.getCompletedReminders();
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(completedRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: completedAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No completed reminders yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    item.title,
                    style: const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  subtitle: Text(
                    item.completedAt != null
                        ? 'Done: ${DateFormat('EEE, d MMM • h:mm a').format(item.completedAt!.toLocal())}'
                        : 'Completed',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
