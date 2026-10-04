import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/features/reliability/reliability_screen.dart';
import 'package:remember/features/notes/notes_screen.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/scheduler_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final _apiKeyController = TextEditingController();
  final _endpointController = TextEditingController();

  bool _enableLlm = false;
  String _voiceLocale = 'en_IN';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final enableLlm = await settingsRepo.getBool(AppConstants.keyEnableLlmParser);
    final locale = await settingsRepo.getString(AppConstants.keyVoiceLocale, defaultValue: 'en_IN');
    final endpoint = await settingsRepo.getString(AppConstants.keyLlmEndpoint, defaultValue: 'https://api.openai.com/v1/chat/completions');
    final apiKey = await _secureStorage.read(key: AppConstants.secureKeyLlmApiKey) ?? '';

    setState(() {
      _enableLlm = enableLlm;
      _voiceLocale = locale!;
      _endpointController.text = endpoint!;
      _apiKeyController.text = apiKey;
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exportService = ref.watch(exportServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined, color: Colors.indigo),
              title: const Text('Reliability & Permission Check'),
              subtitle: const Text('Verify exact alarms, battery optimizations & test alerts.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReliabilityScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          const Text('Voice Recognition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(
            title: const Text('Voice Locale'),
            subtitle: Text(_voiceLocale),
            trailing: DropdownButton<String>(
              value: _voiceLocale,
              items: const [
                DropdownMenuItem(value: 'en_IN', child: Text('English (India)')),
                DropdownMenuItem(value: 'en_US', child: Text('English (US)')),
                DropdownMenuItem(value: 'hi_IN', child: Text('Hindi (India)')),
                DropdownMenuItem(value: 'kn_IN', child: Text('Kannada (India)')),
              ],
              onChanged: (val) async {
                if (val != null) {
                  setState(() => _voiceLocale = val);
                  await ref.read(settingsRepositoryProvider).setString(AppConstants.keyVoiceLocale, val);
                }
              },
            ),
          ),
          const Divider(),

          const Text('Layer 2 Optional AI Parser', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SwitchListTile(
            title: const Text('Enable AI LLM Parser'),
            subtitle: const Text('Uses personal API key with 3s timeout & Layer 1 fallback.'),
            value: _enableLlm,
            onChanged: (val) async {
              setState(() => _enableLlm = val);
              await ref.read(settingsRepositoryProvider).setBool(AppConstants.keyEnableLlmParser, val);
            },
          ),
          if (_enableLlm) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _endpointController,
                decoration: const InputDecoration(
                  labelText: 'API Endpoint',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) async {
                  await ref.read(settingsRepositoryProvider).setString(AppConstants.keyLlmEndpoint, val);
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _apiKeyController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'API Key (Stored in Secure Storage)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) async {
                  await _secureStorage.write(key: AppConstants.secureKeyLlmApiKey, value: val);
                },
              ),
            ),
          ],
          const Divider(),

          const Text('Backup & Export', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export Backup (JSON)'),
            subtitle: const Text('Save full JSON backup of reminders & notes.'),
            onTap: () async {
              final jsonStr = await exportService.exportBackupToJson();
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Backup Generated'),
                    content: SingleChildScrollView(child: SelectableText(jsonStr)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    ],
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Import Backup (JSON)'),
            subtitle: const Text('Restore notes and reminders from JSON string.'),
            onTap: () async {
              final controller = TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Import JSON Backup'),
                  content: TextField(
                    controller: controller,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Paste backup JSON here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () async {
                        final text = controller.text.trim();
                        if (text.isNotEmpty) {
                          final count = await exportService.importBackupFromJson(text);

                          // Trigger notification reschedule on backup import
                          final reminderRepo = ref.read(reminderRepositoryProvider);
                          final settingsRepo = ref.read(settingsRepositoryProvider);
                          final scheduler = SchedulerService(reminderRepo, settingsRepo, NotificationService());
                          await scheduler.rebuildAll();

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Imported $count items successfully.')),
                            );
                          }
                        }
                      },
                      child: const Text('Import'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
