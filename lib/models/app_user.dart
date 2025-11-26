// lib/models/app_user.dart
class AppUser {
  final String id;
  final String name;
  final String email;

  AppUser({required this.id, required this.name, required this.email});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['\$id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
