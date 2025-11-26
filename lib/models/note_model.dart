// lib/models/note_model.dart
class Note {
  final String id; // Appwrite document ID ($id)
  final String text;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Note({
    required this.id,
    required this.text,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Create Note from Appwrite document data + metadata
  factory Note.fromJson(Map<String, dynamic> json) {
    // Appwrite document often returns fields directly in json,
    // and meta fields like $id, $createdAt, $updatedAt at top-level.
    return Note(
      id: json[r'$id'] ?? json['\$id'] ?? (json['id'] ?? ''),
      text: json['text'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      createdAt: json[r'$createdAt'] != null
          ? DateTime.tryParse(json[r'$createdAt'])
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null),
      updatedAt: json[r'$updatedAt'] != null
          ? DateTime.tryParse(json[r'$updatedAt'])
          : (json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'user_id': userId,
      
    };
  }
}
