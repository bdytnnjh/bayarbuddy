import 'package:app/core/configs/firebase_query.dart';
import 'package:app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RegisterRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const String _usersCollection = 'users';

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Register user with email and password (Firebase Auth only)
  Future<User> registerWithEmailPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('User registration failed');
      }

      debugPrint('User registered successfully: ${userCredential.user!.uid}');
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Registration Error: $e');
      rethrow;
    }
  }

  // Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String username,
    required String fullName,
    required String phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        email: email,
        username: username,
        fullName: fullName,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseQuery.setDocument(collection: _usersCollection, docId: uid, data: userModel.toMap());

      debugPrint('User profile created successfully: $uid');
    } catch (e) {
      debugPrint('Create Profile Error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Sign Out Error: $e');
      rethrow;
    }
  }

  // Get user profile from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await FirebaseQuery.getDocument(collection: _usersCollection, docId: uid);

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromSnapshot(doc);
    } catch (e) {
      debugPrint('Get Profile Error: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? username,
    String? fullName,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final Map<String, dynamic> updateData = {'updatedAt': DateTime.now()};

      if (username != null) updateData['username'] = username;
      if (fullName != null) updateData['fullName'] = fullName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;

      await FirebaseQuery.updateDocument(collection: _usersCollection, docId: uid, data: updateData);

      debugPrint('User profile updated successfully: $uid');
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      // Delete user profile from Firestore
      await FirebaseQuery.deleteDocument(collection: _usersCollection, docId: user.uid);

      // Delete user from Firebase Auth
      await user.delete();
      debugPrint('User account deleted successfully');
    } catch (e) {
      debugPrint('Delete Account Error: $e');
      rethrow;
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email.';
      case 'invalid-email':
        return 'Invalid email address. Please check and try again.';
      case 'user-not-found':
        return 'No user found with this email. Please register first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action.';
      default:
        return e.message ?? 'An unknown error occurred. Please try again.';
    }
  }
}
