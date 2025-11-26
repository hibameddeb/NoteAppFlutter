// lib/services/appwrite_config.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Initialize Appwrite client
Client getClient() {
  Client client = Client();
  return client
    .setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)
    .setProject(dotenv.env['APPWRITE_PROJECT_ID']!);
}

class AppwriteConfig {
  static final Client client = Client()
    ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)   // Your Appwrite endpoint
    ..setProject(dotenv.env['APPWRITE_PROJECT_ID']!);
  static final String databaseId = dotenv.env['APPWRITE_DATABASE_ID'] ?? '';
  static final String collectionId = dotenv.env['APPWRITE_COLLECTION_ID'] ?? ''; // Your Appwrite project ID
}
