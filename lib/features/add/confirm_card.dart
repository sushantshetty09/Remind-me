import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remember/core/theme/app_theme.dart';
import 'package:remember/domain/models/parsed_item.dart';
import 'package:remember/domain/models/reminder_item.dart';
import 'package:remember/domain/models/repeat_rule.dart';

class ConfirmCard extends StatefulWidget {
  final ParsedItem parsedItem;
  final VoidCallback onSave;
  final ValueChanged<ParsedItem> onChanged;

  const ConfirmCard({
    super.key,
    required this.parsedItem,
    required this.onSave,
    required this.onChanged,
  });

  @override
  State<ConfirmCard> createState() => _ConfirmCardState();
}

class _ConfirmCardState extends State<ConfirmCard> {
  late TextEditingController _titleController;
  late ParsedItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.parsedItem;
    _titleController = TextEditingController(text: _item.title);
  }

  @override
  void didUpdateWidget(covariant ConfirmCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parsedItem != widget.parsedItem) {
      _item = widget.parsedItem;
      _titleController.text = _item.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateItem(ParsedItem updated) {
    setState(() => _item = updated);
    widget.onChanged(updated);
  }

  String _formatDateTime(DateTime? dt, bool dateOnly) {
    if (dt == null) return 'No date set (Note only)';
    final localDt = dt.toLocal();
    final dayStr = DateFormat('EEE, d MMM yyyy').format(localDt);
    if (dateOnly) {
      return '$dayStr (All day / 9:00 AM)';
    }
    final timeStr = DateFormat('h:mm a').format(localDt);
    return '$dayStr at $timeStr';
  }

  void _adjustTime(Duration duration) {
    final base = _item.datetime ?? DateTime.now();
    final newDt = base.add(duration);
    _updateItem(_item.copyWith(datetime: newDt, dateOnly: false));
  }

  void _setTomorrowMorning() {
    final now = DateTime.now();
    final tomorrow9am = DateTime(now.year, now.month, now.day + 1, 9, 0);
    _updateItem(_item.copyWith(datetime: tomorrow9am, dateOnly: false));
  }

  void _setNextWeek() {
    final now = DateTime.now();
    final nextWeek9am = DateTime(now.year, now.month, now.day + 7, 9, 0);
    _updateItem(_item.copyWith(datetime: nextWeek9am, dateOnly: true));
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate = _item.datetime ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (pickedDate == null || !mounted) return;

    final initialTime = TimeOfDay.fromDateTime(_item.datetime ?? DateTime(2026, 1, 1, 9, 0));
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      final newDt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _updateItem(_item.copyWith(datetime: newDt, dateOnly: false));
    } else {
      final newDt = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 9, 0);
      _updateItem(_item.copyWith(datetime: newDt, dateOnly: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUncertain = _item.confidence < 0.8;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isUncertain ? Colors.orange : Colors.transparent,
          width: isUncertain ? 2 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUncertain)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.help_outline, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _item.assumptions.isNotEmpty
                            ? _item.assumptions.first
                            : 'Please review date/time',
                        style: const TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Reminder Title',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (val) {
                _updateItem(_item.copyWith(title: val));
              },
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (_item.category == ReminderCategory.commitment)
                  const Chip(
                    avatar: Icon(Icons.star, size: 16, color: Colors.white),
                    label: Text('Commitment', style: TextStyle(color: Colors.white)),
                    backgroundColor: AppTheme.commitmentColor,
                  ),
                if (_item.priority == ReminderPriority.high &&
                    _item.category != ReminderCategory.commitment)
                  Chip(
                    avatar: const Icon(Icons.priority_high, size: 16),
                    label: const Text('High Priority'),
                    backgroundColor: Colors.amber.shade200,
                  ),
                if (_item.person != null)
                  Chip(
                    avatar: const Icon(Icons.person_outline, size: 16),
                    label: Text(_item.person!),
                  ),
                if (_item.repeat.type != RepeatType.none)
                  Chip(
                    avatar: const Icon(Icons.repeat, size: 16),
                    label: Text('Repeats ${_item.repeat.type.name}'),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppTheme.primarySeed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDateTime(_item.datetime, _item.dateOnly),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const Icon(Icons.edit_calendar, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    label: const Text('+15m'),
                    onPressed: () => _adjustTime(const Duration(minutes: 15)),
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    label: const Text('+1h'),
                    onPressed: () => _adjustTime(const Duration(hours: 1)),
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    label: const Text('Tomorrow 9AM'),
                    onPressed: _setTomorrowMorning,
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    label: const Text('Next week'),
                    onPressed: _setNextWeek,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onSave,
                icon: const Icon(Icons.check),
                label: const Text('Save Reminder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
