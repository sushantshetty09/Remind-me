import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/domain/models/note_item.dart';
import 'package:remember/services/export_service.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(
    ref.watch(noteRepositoryProvider),
    ref.watch(reminderRepositoryProvider),
  );
});

final notesQueryProvider = StateProvider<String>((ref) => '');
final selectedFilterProvider = StateProvider<String>((ref) => 'All');

final filteredNotesProvider = FutureProvider<List<NoteItem>>((ref) async {
  final query = ref.watch(notesQueryProvider);
  final filter = ref.watch(selectedFilterProvider);
  final noteRepo = ref.watch(noteRepositoryProvider);

  var notes = await noteRepo.searchNotes(query);

  if (filter == 'Important') {
    notes = notes.where((n) => n.isImportant).toList();
  } else if (filter == 'Commitments') {
    notes = notes.where((n) => n.tags.contains('commitment')).toList();
  } else if (filter == 'This week') {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    notes = notes.where((n) => n.createdAt.isAfter(startOfWeek)).toList();
  }

  return notes;
});

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddManualNoteDialog() {
    final bodyController = TextEditingController();
    final summaryController = TextEditingController();
    bool isImportant = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: summaryController,
                    decoration: const InputDecoration(
                      labelText: 'Summary (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Note Content',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Mark as Important'),
                    value: isImportant,
                    onChanged: (val) {
                      setDialogState(() => isImportant = val ?? false);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (bodyController.text.trim().isEmpty) return;
                    final now = DateTime.now().toUtc();
                    final note = NoteItem(
                      id: 0,
                      body: bodyController.text.trim(),
                      summary: summaryController.text.trim().isEmpty
                          ? null
                          : summaryController.text.trim(),
                      isImportant: isImportant,
                      createdAt: now,
                      updatedAt: now,
                    );

                    await ref.read(noteRepositoryProvider).saveNote(note);
                    ref.refresh(filteredNotesProvider);
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Note'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(filteredNotesProvider);
    final activeFilter = ref.watch(selectedFilterProvider);
    final exportService = ref.watch(exportServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add_outlined),
            tooltip: 'Add Manual Note',
            onPressed: _showAddManualNoteDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Note: Android limits direct background writing into Google Keep. Use "Send to Notes" or auto-export folder.',
                    style: TextStyle(fontSize: 11, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes by keyword or tag...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(notesQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onChanged: (val) {
                ref.read(notesQueryProvider.notifier).state = val;
              },
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['All', 'Important', 'Commitments', 'This week'].map((f) {
                final isSelected = activeFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedFilterProvider.notifier).state = f;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: notesAsync.when(
              data: (notes) {
                if (notes.isEmpty) {
                  return const Center(child: Text('No notes found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (note.isImportant)
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    note.summary ?? 'Note',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    note.isImportant ? Icons.star : Icons.star_border,
                                    color: note.isImportant ? Colors.amber : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    await ref.read(noteRepositoryProvider).toggleImportant(note.id);
                                    ref.refresh(filteredNotesProvider);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              note.body,
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  DateFormat('d MMM yyyy • h:mm a').format(note.createdAt.toLocal()),
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  icon: const Icon(Icons.share, size: 16),
                                  label: const Text('Send to Notes', style: TextStyle(fontSize: 12)),
                                  onPressed: () => exportService.sendNoteToShareSheet(note),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading notes: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
