import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/reliability_service.dart';
import 'package:remember/services/scheduler_service.dart';

final reliabilityServiceProvider = Provider<ReliabilityService>((ref) {
  final notifService = NotificationService();
  final db = ref.watch(appDatabaseProvider);
  final reminderRepo = ref.watch(reminderRepositoryProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final schedulerService = SchedulerService(reminderRepo, settingsRepo, notifService);

  return ReliabilityService(notifService, schedulerService, reminderRepo);
});

final reliabilityStatusProvider = FutureProvider<ReliabilityStatus>((ref) async {
  final service = ref.watch(reliabilityServiceProvider);
  return await service.getReliabilityStatus();
});

class ReliabilityScreen extends ConsumerWidget {
  const ReliabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(reliabilityStatusProvider);
    final service = ref.read(reliabilityServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Reliability'),
      ),
      body: statusAsync.when(
        data: (status) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: status.isFullyReliable
                  ? Colors.green.withOpacity(0.15)
                  : Colors.orange.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      status.isFullyReliable
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_rounded,
                      color: status.isFullyReliable ? Colors.green : Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.isFullyReliable
                                ? 'Reliability status: EXCELLENT'
                                : 'Reliability status: ATTENTION NEEDED',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            status.isFullyReliable
                                ? 'All required permissions are granted for exact reminders.'
                                : 'Enable missing permissions to prevent missed reminders.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Permissions Check',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                status.notificationPermission ? Icons.check : Icons.close,
                color: status.notificationPermission ? Colors.green : Colors.red,
              ),
              title: const Text('Notification Permission'),
              subtitle: const Text('Required to show reminder notifications.'),
              trailing: status.notificationPermission
                  ? null
                  : TextButton(
                      onPressed: () async {
                        await service.requestNotificationPermission();
                        ref.refresh(reliabilityStatusProvider);
                      },
                      child: const Text('Enable'),
                    ),
            ),
            ListTile(
              leading: Icon(
                status.exactAlarmPermission ? Icons.check : Icons.close,
                color: status.exactAlarmPermission ? Colors.green : Colors.red,
              ),
              title: const Text('Exact Alarm Permission'),
              subtitle: const Text('Required to trigger reminders at the exact minute.'),
              trailing: status.exactAlarmPermission
                  ? null
                  : TextButton(
                      onPressed: () async {
                        await service.requestExactAlarmPermission();
                        ref.refresh(reliabilityStatusProvider);
                      },
                      child: const Text('Enable'),
                    ),
            ),
            ListTile(
              leading: Icon(
                status.batteryOptimizationDisabled ? Icons.check : Icons.info_outline,
                color: status.batteryOptimizationDisabled ? Colors.green : Colors.orange,
              ),
              title: const Text('Battery Optimization'),
              subtitle: const Text('Disable optimization so Android does not delay alerts.'),
              trailing: TextButton(
                onPressed: () async {
                  await service.requestIgnoreBatteryOptimization();
                  ref.refresh(reliabilityStatusProvider);
                },
                child: const Text('Configure'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.timer_outlined, color: Colors.indigo),
                title: const Text('Test Notification'),
                subtitle: const Text('Triggers a test notification in 10 seconds.'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await service.sendTestNotificationIn10Seconds();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Test notification scheduled in 10 seconds. Lock your phone to test!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Test (10s)'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Brand Battery Guidance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...ReliabilityService.getBrandTips().entries.map((e) => ExpansionTile(
                  title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(e.value),
                    ),
                  ],
                )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading status: $err')),
      ),
    );
  }
}
