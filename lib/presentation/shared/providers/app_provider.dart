import 'package:app/core/utils/session_util.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final SessionUtil _sessionUtil = SessionUtil();
  final UserRepository _userRepository = UserRepository();

  //private variable decalaration to save status
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  String? _boardingStatus;
  String? _loginStatus;

  //getters to access status from outside the class
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get boardingStatus => _boardingStatus;
  String? get loginStatus => _loginStatus;

  //method to initialize app status - explicitly called during app startup
  Future<void> initializeApp() async {
    if (_isInitialized) return; //prevent re-initialization

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Initializing AppProvider...');

      _boardingStatus = await _sessionUtil.readSession(
        _sessionUtil.boardingKey,
      );
      _loginStatus = await _sessionUtil.readSession(_sessionUtil.userKey);
      _isInitialized = true;

      debugPrint('Boarding Status: $_boardingStatus');
      debugPrint('Login Status: $_loginStatus');
    } catch (e) {
      _error = e.toString();
      debugPrint('Error initializing AppProvider: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to get the initial route based on app status
  Future<String> getInitialRoute() async {
    if (_boardingStatus != null && _boardingStatus == 'true') {
      if (_loginStatus != null) {
        String uid = _loginStatus!;
        String? hashedPin = await _userRepository.getHashedPin(uid: uid);

        // If user has PIN, go to verify PIN screen, otherwise set PIN first
        return hashedPin != null ? '/verify-pin' : '/set-pin';
      } else {
        return '/login'; //user has completed onboarding but is not logged in
      }
    } else {
      await _sessionUtil.writeSession(_sessionUtil.boardingKey, 'true');
      return '/boarding'; //user has not completed onboarding
    }
  }

  // Get hashed PIN for verify mode
  Future<String?> getHashedPin() async {
    if (_loginStatus != null) {
      return await _userRepository.getHashedPin(uid: _loginStatus!);
    }
    return null;
  }
}
