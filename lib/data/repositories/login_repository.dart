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

  Future<bool> loginWithEmailPassword({required String email, required String password}) async {
    try {
      final usersSnapshot = await FirebaseQuery.getDocuments(
        collection: _usersCollection,
        queryBuilder: (collection) => collection.where('email', isEqualTo: email).limit(1),
      );

      if (usersSnapshot.docs.isEmpty) {
        throw Exception('User not found. Please check your email.');
      }

      final user = UserModel.fromMap(usersSnapshot.docs.first.data());

      // Check if user account is blocked
      if (user.status == 'blocked') {
        throw Exception(
          'Your account has been blocked due to security reasons. Please contact admin support to unlock your account.',
        );
      }

      // Check if user account is inactive
      if (user.status == 'inactive') {
        throw Exception('Your account is inactive. Please contact admin support.');
      }

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        throw Exception('Invalid password. Please try again.');
      }

      final tokenPayload = {
        'uid': user.uid,
        'email': user.email,
        'username': user.username,
        'fullName': user.fullName,
        'phoneNumber': user.phoneNumber,
        'photoUrl': user.photoUrl,
        'createdAt': user.createdAt.toIso8601String(),
        'updatedAt': user.updatedAt.toIso8601String(),
        'iat': DateTime.now().millisecondsSinceEpoch,
      };

      final jwtToken = _jwtUtil.generateJwtFromJson(tokenPayload);

      await _sessionUtil.writeSession(_sessionUtil.authKey, jwtToken);
      await _sessionUtil.writeSession(_sessionUtil.userKey, user.uid);

      debugPrint('User logged in successfully: ${user.email}');
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return await _sessionUtil.readSession(_sessionUtil.authKey);
    } catch (e) {
      debugPrint('Get Auth Token Error: $e');
      return null;
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _sessionUtil.readSession(_sessionUtil.userKey);
    } catch (e) {
      debugPrint('Get User ID Error: $e');
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('Check Login Status Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _sessionUtil.deleteSession(_sessionUtil.authKey);
      await _sessionUtil.deleteSession(_sessionUtil.userKey);
      await FirebaseAuth.instance.signOut();
      debugPrint('User logged out successfully.');
    } catch (e) {
      debugPrint('Logout Error: $e');
      rethrow;
    }
  }
}
