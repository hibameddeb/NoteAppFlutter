import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NoteItem extends StatefulWidget {
  final Note note;
  final Function(String)? onNoteDeleted;

  const NoteItem({
    Key? key,
    required this.note,
    this.onNoteDeleted,
  }) : super(key: key);

  @override
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  final NoteService _noteService = NoteService();
  bool _isDeleting = false;

  // Format date safely
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        setState(() => _isDeleting = true);

        await _noteService.deleteNote(widget.note.id);

        if (widget.onNoteDeleted != null) {
          widget.onNoteDeleted!(widget.note.id);
        }
      } catch (e) {
        print('Error deleting note: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete note. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isDeleting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Main note content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (note.updatedAt != null)
                    Text(
                      'Last updated: ${_formatDate(note.updatedAt!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Delete button
            IconButton(
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete, color: Colors.red),
              onPressed: _isDeleting ? null : _handleDelete,
            ),
          ],
        ),
      ),
    );
  }
}
