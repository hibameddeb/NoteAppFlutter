// lib/services/note_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/note_model.dart';
import 'appwrite_config.dart';

class NoteService {
  final Databases databases;

  NoteService() : databases = Databases(AppwriteConfig.client);

  Future<List<Note>> getNotes(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: [
          Query.equal('user_id', userId) 
        ],
      );

      return response.documents.map((doc) => Note.fromJson(doc.data)).toList();
    } catch (e) {
      print('Error fetching notes: $e');
      return [];
    }
  }

  Future<Note?> addNote(String text, String userId) async {
    try {
      final response = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: ID.unique(),
        data: {
          'text': text,
          'user_id': userId // Add user ID to the note
        },
      );

      return Note.fromJson(response.data);
    } catch (e) {
      print('Error adding note: $e');
      return null;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      
      await databases.deleteDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
      );

      return true;
    } catch (e) {
      print('Error deleting note: $e');
      throw e;
    }
  }


  Future<Document> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      // Add updated timestamp
      final noteData = {
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Update the document in the database
      final response = await databases.updateDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
        data: noteData,
      );

      return response;
    } catch (e) {
      print('Error updating note: $e');
      throw e;
    }
  }
}