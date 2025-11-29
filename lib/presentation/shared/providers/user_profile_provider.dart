import 'package:app/core/utils/app_util.dart';
import 'package:app/data/models/user_model.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user profile
  Future<void> loadUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await AppUtil.getCurrentUserId();

      if (userId != null) {
        final userData = await _userRepository.getUserByUid(uid: userId);

        if (userData != null) {
          _userProfile = UserModel.fromMap(userData);
          _error = null;
        } else {
          _error = 'User not found';
        }
      } else {
        _error = 'User ID not found';
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user profile
  Future<void> refreshUserProfile() async {
    await loadUserProfile();
  }
}
