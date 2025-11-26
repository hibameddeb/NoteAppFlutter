// lib/widgets/add_note_modal.dart
import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../models/note_model.dart';

class AddNoteModal extends StatefulWidget {
  final Function(Note) onNoteAdded;
  final String userId;

  const AddNoteModal({
    Key? key,
    required this.onNoteAdded,
    required this.userId,
  }) : super(key: key);

  @override
  _AddNoteModalState createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModal> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteService = NoteService();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _error = null;
    });
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      setState(() {
        _error = 'Please fill in both title and content';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Combine title + content into the single "text" field stored in Appwrite
      final combinedText = "$title\n\n$content";

      final newNote = await _noteService.addNote(
        combinedText,
        widget.userId,
      );

      if (newNote == null) {
        throw Exception("Failed to create note");
      }

      _resetForm();
      widget.onNoteAdded(newNote);

      Navigator.pop(context);

    } catch (e) {
      print("Error creating note: $e");
      setState(() {
        _error = "Failed to save note. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add New Note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (_error != null)
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              hintText: 'Content',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                child: Text(_isLoading ? "Saving..." : "Save Note"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
