import 'package:app/core/utils/encrypter_util.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class SetPinProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final EncrypterUtil _encrypterUtil = EncrypterUtil();

  String _pin = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isVerifyMode = false;
  String? _storedHashedPin;
  int _failedAttempts = 0;

  final int maxPinLength = 5;
  final int maxFailedAttempts = 3;

  String get pin => _pin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isVerifyMode => _isVerifyMode;
  bool get isPinComplete => _pin.length == maxPinLength;
  int get failedAttempts => _failedAttempts;

  void setVerifyMode(bool value, {String? hashedPin}) {
    _isVerifyMode = value;
    _storedHashedPin = hashedPin;
    notifyListeners();
  }

  void addDigit(String digit) {
    if (_pin.length < maxPinLength) {
      _pin += digit;
      notifyListeners();
    }
  }

  void deleteDigit() {
    if (_pin.isNotEmpty) {
      _pin = _pin.substring(0, _pin.length - 1);
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearPin() {
    _pin = '';
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> setPin({required String uid}) async {
    if (_pin.length != maxPinLength) {
      _errorMessage = 'Please enter a 5-digit PIN';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Encrypt PIN
      final hashedPin = _encrypterUtil.encryptData(_pin);

      // Save to database
      final success = await _userRepository.createOrUpdateHasedPin(uid: uid, hashedPin: hashedPin);

      if (success) {
        clearPin();
        return true;
      } else {
        _errorMessage = 'Failed to set PIN. Please try again.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyPin() async {
    if (_pin.length != maxPinLength) {
      _errorMessage = 'Please enter a 5-digit PIN';
      notifyListeners();
      return false;
    }

    if (_storedHashedPin == null) {
      _errorMessage = 'No PIN set. Please set your PIN first.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Encrypt entered PIN
      final enteredHashedPin = _encrypterUtil.encryptData(_pin);

      // Compare with stored hashed PIN
      if (enteredHashedPin == _storedHashedPin) {
        _failedAttempts = 0; // Reset on success
        clearPin();
        return true;
      } else {
        _failedAttempts++;
        final remainingAttempts = maxFailedAttempts - _failedAttempts;

        if (_failedAttempts >= maxFailedAttempts) {
          _errorMessage = 'Too many failed attempts. Please contact support.';
        } else {
          _errorMessage = 'Incorrect PIN. $remainingAttempts attempt${remainingAttempts > 1 ? 's' : ''} remaining.';
        }

        clearPin();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
