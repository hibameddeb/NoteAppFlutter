// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';
import 'package:appwrite/models.dart' show User;

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Current user
  AppUser? _user;
  AppUser? get user => _user;

  // Loading state
  bool _loading = true;
  bool get loading => _loading;

  // Authentication state
  bool get isAuthenticated => _user != null;

  // Constructor - checks for existing session
  AuthProvider() {
    _checkUserStatus();
  }

  // Check if user is already logged in - FIXED
  Future<void> _checkUserStatus() async {
    try {
      final User? currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        // Convert Appwrite User to Map and then to AppUser
        _user = AppUser.fromMap({
          '\$id': currentUser.$id,
          'name': currentUser.name,
          'email': currentUser.email,
        });
      } else {
        _user = null;
      }
    } catch (e) {
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Register a new user - FIXED
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _authService.createAccount(
        email: email,
        password: password,
        name: name,
      );
      // Convert Appwrite User to Map and then to AppUser
      _user = AppUser.fromMap({
        '\$id': user.$id,
        'name': user.name,
        'email': user.email,
      });
      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Login existing user - FIXED
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.login(email: email, password: password);
      final User? currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        // Convert Appwrite User to Map and then to AppUser
        _user = AppUser.fromMap({
          '\$id': currentUser.$id,
          'name': currentUser.name,
          'email': currentUser.email,
        });
      }
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}