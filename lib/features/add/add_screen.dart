import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:remember/core/constants/app_constants.dart';
import 'package:remember/core/theme/app_theme.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/domain/models/parsed_item.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/features/add/confirm_card.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/parser_rule_based.dart';
import 'package:remember/services/scheduler_service.dart';

final ruleBasedParserProvider = Provider<RuleBasedParser>((ref) {
  return const RuleBasedParser();
});

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({super.key});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechTranscript = '';
  List<ParsedItem> _parsedItems = [];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
              _pulseController.stop();
            });
            if (_speechTranscript.trim().isNotEmpty) {
              _textController.text = _speechTranscript;
              _parseCurrentInput();
            }
          }
        },
        onError: (error) {
          setState(() {
            _isListening = false;
            _pulseController.stop();
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _speechTranscript = '';
        });
        _pulseController.repeat(reverse: true);

        final settingsRepo = ref.read(settingsRepositoryProvider);
        final locale =
            await settingsRepo.getString(AppConstants.keyVoiceLocale, defaultValue: 'en_IN');

        _speech.listen(
          localeId: locale,
          onResult: (val) {
            setState(() {
              _speechTranscript = val.recognizedWords;
              _textController.text = _speechTranscript;
            });
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Speech recognition not available on this device')),
          );
        }
      }
    } else {
      setState(() {
        _isListening = false;
        _pulseController.stop();
      });
      _speech.stop();
      if (_speechTranscript.trim().isNotEmpty) {
        _textController.text = _speechTranscript;
        _parseCurrentInput();
      }
    }
  }

  void _parseCurrentInput() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final parser = ref.read(ruleBasedParserProvider);
    final splitTextList = parser.splitInput(text);

    final items = splitTextList.map((t) => parser.parseSingle(t)).toList();
    setState(() {
      _parsedItems = items;
    });
  }

  Future<void> _saveParsedItem(int index) async {
    if (index < 0 || index >= _parsedItems.length) return;

    final item = _parsedItems[index];
    final nowUtc = DateTime.now().toUtc();

    final reminderRepo = ref.read(reminderRepositoryProvider);
    final noteRepo = ref.read(noteRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final scheduler = SchedulerService(
      reminderRepo,
      settingsRepo,
      NotificationService(),
    );

    // 1. Save Reminder
    final reminder = item.toReminderItem(nowUtc: nowUtc);
    final reminderId = await reminderRepo.saveReminder(reminder);

    // 2. Save Note
    final note = NoteItem(
      id: 0,
      body: item.rawText,
      summary: item.title,
      isImportant: item.priority == ReminderPriority.high,
      tags: [item.category.name, if (item.person != null) item.person!],
      createdAt: nowUtc,
      updatedAt: nowUtc,
      reminderId: reminderId,
    );
    final noteId = await noteRepo.saveNote(note);

    // Link noteId back to reminder
    final updatedReminder = reminder.copyWith(id: reminderId, noteId: noteId);
    await reminderRepo.saveReminder(updatedReminder);

    // 3. Schedule Notifications
    await scheduler.scheduleReminder(updatedReminder, nowUtc: nowUtc);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved "${item.title}"!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {
      _parsedItems.removeAt(index);
      if (_parsedItems.isEmpty) {
        _textController.clear();
        _speechTranscript = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Reminder'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.15).animate(_pulseController),
                      child: FloatingActionButton.large(
                        onPressed: _listen,
                        backgroundColor: _isListening ? Colors.red : AppTheme.primarySeed,
                        foregroundColor: Colors.white,
                        elevation: 6,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isListening ? 'Listening...' : 'Tap mic to speak or type below',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: _textController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'e.g. Call Rahul about rent tomorrow evening...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded),
                          onPressed: _parseCurrentInput,
                        ),
                      ),
                      onSubmitted: (_) => _parseCurrentInput(),
                    ),
                    const SizedBox(height: 16),

                    if (_parsedItems.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Parsed Items (${_parsedItems.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _parsedItems.length,
                        itemBuilder: (context, index) {
                          return ConfirmCard(
                            parsedItem: _parsedItems[index],
                            onChanged: (updated) {
                              setState(() => _parsedItems[index] = updated);
                            },
                            onSave: () => _saveParsedItem(index),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
