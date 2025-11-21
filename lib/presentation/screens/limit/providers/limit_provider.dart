import 'package:app/core/utils/session_util.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class LimitProvider with ChangeNotifier {
  final SessionUtil _sessionUtil = SessionUtil();
  final UserRepository _userRepository = UserRepository();

  double _transactionLimit = 0;
  bool _isEditing = false;
  bool _isLoading = false;
  String? _errorMessage;

  final double minLimit = 500;
  final double maxLimit = 10000;

  double get transactionLimit => _transactionLimit;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setTransactionLimit(double value) {
    _transactionLimit = value;
    notifyListeners();
  }

  void setIsEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void initializeLimit() async {
    _isLoading = true;
    notifyListeners();
    String? userUid = await _sessionUtil.readSession(_sessionUtil.userKey);
    if (userUid != null) {
      _transactionLimit = await _userRepository.getUserLimitTransaction(
        uid: userUid,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLimit() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? userUid = await _sessionUtil.readSession(_sessionUtil.userKey);
      final success = await _userRepository.updateUserLimitTransaction(
        uid: userUid ?? '',
        newLimit: _transactionLimit,
      );

      if (success) {
        _isEditing = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to update limit. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
