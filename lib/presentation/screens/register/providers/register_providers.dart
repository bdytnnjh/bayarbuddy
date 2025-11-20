import 'package:app/data/repositories/register_repository.dart';
import 'package:app/data/repositories/wallet_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  final RegisterRepository _authRepository = RegisterRepository();
  final WalletRepository _walletRepository = WalletRepository();

  // Registration state
  bool _isLoading = false;
  String? _error;
  String? _userId;

  // User registration data
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phoneNumber => _phoneNumber;

  // Computed getters
  String get fullName => '${_firstName ?? ''} ${_lastName ?? ''}'.trim();
  String get username => _email?.split('@').first ?? '';

  // Step 1: Register with email and password (Firebase Auth)
  Future<bool> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      // Register user in Firebase Auth
      final User user = await _authRepository.registerWithEmailPassword(
        email: email,
        password: password,
      );
      await _walletRepository.createWallet(userId: user.uid);

      // Store user data temporarily
      _userId = user.uid;
      _email = email;

      debugPrint('Registration successful: ${user.uid}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Registration error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Step 2: Save name data
  void saveName({required String firstName, required String lastName}) {
    _firstName = firstName;
    _lastName = lastName;
    notifyListeners();
    debugPrint('Name saved: $fullName');
  }

  // Step 3: Save phone and create Firestore profile
  Future<bool> savePhoneAndCreateProfile({required String phoneNumber}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate all required data
      if (_userId == null || _email == null) {
        throw Exception(
          'User not registered. Please start from the beginning.',
        );
      }

      if (_firstName == null || _lastName == null) {
        throw Exception('Name is required. Please complete the previous step.');
      }

      if (phoneNumber.isEmpty) {
        throw Exception('Phone number is required');
      }

      _phoneNumber = phoneNumber;

      // Create user profile in Firestore
      await _authRepository.createUserProfile(
        uid: _userId!,
        email: _email!,
        username: username,
        fullName: fullName,
        phoneNumber: _phoneNumber!,
      );

      debugPrint('User profile created successfully');

      // Sign out user after registration
      await _authRepository.signOut();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Create profile error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset provider state
  void reset() {
    _isLoading = false;
    _error = null;
    _userId = null;
    _email = null;
    _firstName = null;
    _lastName = null;
    _phoneNumber = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
