// lib/services/auth_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AuthService {
  late Client client;
  late Account account;

  AuthService() {
    _init();
  }

  void _init() {
    // Initialize Appwrite client
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite endpoint
        .setProject('your-project-id'); // Your Appwrite project ID

    account = Account(client);
  }

  // Create a new account
  Future<models.User> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return user;
    } catch (e) {
      print('Create account error: $e');
      rethrow;
    }
  }

  // Login with email and password - FIXED METHOD NAME
  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Get current user
  Future<models.User?> getCurrentUser() async {
    try {
      final user = await account.get();
      return user;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Logout user - FIXED METHOD NAME
  Future<void> logout() async {
    try {
      await account.deleteSessions();
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  // Delete account (optional) - FIXED METHOD NAME
  Future<void> deleteAccount() async {
    try {
      // Note: Account deletion might require additional permissions
      // or might not be available in all Appwrite configurations
      print('Account deletion not implemented - check Appwrite documentation');
    } catch (e) {
      print('Delete account error: $e');
      rethrow;
    }
  }

  // Request password reset (optional)
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await account.createRecovery(
        email: email,
        url: 'https://yourapp.com/reset-password', // Your reset password URL
      );
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }

  // Update password with recovery (optional)
  Future<void> updatePasswordWithRecovery({
    required String userId,
    required String secret,
    required String password,
  }) async {
    try {
      await account.updateRecovery(
        userId: userId,
        secret: secret,
        password: password,
      );
    } catch (e) {
      print('Update password error: $e');
      rethrow;
    }
  }

  // Update user profile (optional)
  Future<models.User> updateProfile({required String name}) async {
    try {
      final user = await account.updateName(name: name);
      return user;
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Update user email (optional)
  Future<models.User> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await account.updateEmail(
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      print('Update email error: $e');
      rethrow;
    }
  }

  // Update user password (optional)
  Future<models.User> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = await account.updatePassword(
        oldPassword: oldPassword,
        password: newPassword,
      );
      return user;
    } catch (e) {
      print('Update password error: $e');
      rethrow;
    }
  }

  // Alternative logout method - delete specific session
  Future<void> logoutSession(String sessionId) async {
    try {
      await account.deleteSession(sessionId: sessionId);
    } catch (e) {
      print('Logout session error: $e');
      rethrow;
    }
  }
}