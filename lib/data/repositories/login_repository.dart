import 'package:app/core/configs/firebase_query.dart';
import 'package:app/core/utils/jwt_utils.dart';
import 'package:app/core/utils/session_util.dart';
import 'package:app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginRepository {
  static const String _usersCollection = 'users';
  final JwTUtil _jwtUtil = JwTUtil();
  final SessionUtil _sessionUtil = SessionUtil();

  /// Login with email and password
  /// Returns true if login is successful, throws exception otherwise
  Future<bool> loginWithEmailPassword({required String email, required String password}) async {
    try {
      // Step 1: Get all users and find by email
      final usersSnapshot = await FirebaseQuery.getCollection(collection: _usersCollection);
      print(usersSnapshot.docs);

      if (usersSnapshot.docs.isEmpty) {
        throw Exception('No users found. Please register first.');
      }

      // Step 2: Find user by email
      UserModel? user;
      for (var doc in usersSnapshot.docs) {
        final userData = UserModel.fromMap(doc.data());
        if (userData.email == email) {
          user = userData;
          break;
        }
      }

      if (user == null) {
        throw Exception('User not found. Please check your email.');
      }

      // Step 3: Validate password using Firebase Auth
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        throw Exception('Invalid password. Please try again.');
      }

      // Step 4: Generate JWT token
      final tokenPayload = {
        'id': user.uid,
        'email': user.email,
        'username': user.username,
        'iat': DateTime.now().millisecondsSinceEpoch,
      };

      final jwtToken = _jwtUtil.generateJwtFromJson(tokenPayload);

      // Step 5: Store token and user data locally using session_util
      await _sessionUtil.writeSession(_sessionUtil.authKey, jwtToken);
      await _sessionUtil.writeSession(_sessionUtil.userKey, user.uid);

      debugPrint('User logged in successfully: ${user.email}');
      return true;
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow;
    }
  }

  /// Get stored auth token
  Future<String?> getAuthToken() async {
    try {
      return await _sessionUtil.readSession(_sessionUtil.authKey);
    } catch (e) {
      debugPrint('Get Auth Token Error: $e');
      return null;
    }
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    try {
      return await _sessionUtil.readSession(_sessionUtil.userKey);
    } catch (e) {
      debugPrint('Get User ID Error: $e');
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('Check Login Status Error: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _sessionUtil.deleteSession(_sessionUtil.authKey);
      await _sessionUtil.deleteSession(_sessionUtil.userKey);
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Logout Error: $e');
      rethrow;
    }
  }
}
