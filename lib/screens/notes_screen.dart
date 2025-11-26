// lib/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import '../components/add_note_modal.dart';
import '../components/note_item.dart';
import '../providers/auth_provider.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();

  List<Note> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final fetchedNotes = await _noteService.getNotes(authProvider.user!.id);

      setState(() {
        _notes = fetchedNotes; // <--- FIXED (you forgot this)
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching notes: $e");
      setState(() {
        _error = "Failed to load notes";
        _isLoading = false;
      });
    }
  }

  Future<void> _addNote(String text) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    try {
      final newNote = await _noteService.addNote(text, authProvider.user!.id);
      if (newNote != null) {
        setState(() {
          _notes.insert(0, newNote);
        });
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Failed to add note: $e");
    }
  }

  // open add note modal
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        userId: Provider.of<AuthProvider>(context, listen: false).user!.id,
        onNoteAdded: _handleNoteAdded,
      ),
    );
  }

  // add note to list
  void _handleNoteAdded(Note newNote) {
    setState(() {
      _notes.insert(0, newNote);
    });
  }

  // delete note from list
  void _handleNoteDeleted(String noteId) {
    setState(() {
      _notes.removeWhere((note) => note.id == noteId);
    });
  }

  Widget _buildEmptyNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You don't have any notes yet.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Tap the + button to create your first note!",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Notes",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
         
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? Center(
              child: Text(
                "No notes yet. Add your first one!",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchNotes,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return NoteItem(
                    note: _notes[index],
                    onNoteDeleted: _handleNoteDeleted,
                  );
                },
              ),
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
         
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddNoteModal(
              userId: Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user!.id,
              onNoteAdded: _handleNoteAdded,
            ),
          );
        },
      ),
    );
  }
}
