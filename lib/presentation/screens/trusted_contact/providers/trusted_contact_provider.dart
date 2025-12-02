import 'package:app/core/utils/app_util.dart';
import 'package:app/data/models/trusted_contact_model.dart';
import 'package:app/data/models/user_model.dart';
import 'package:app/data/repositories/trusted_contact_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class TrustedContactProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final TrustedContactRepository _repository = TrustedContactRepository();

  List<TrustedContactModel> _contacts = [];
  bool _isLoading = false;
  String? _error;

  List<TrustedContactModel> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await AppUtil.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not found');
      }

      _contacts = await _repository.getTrustedContactsByUserId(userId);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading contacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addContact({
    required String name,
    required String phoneNumber,
    required String email,
    required String relationship,
  }) async {
    try {
      final userId = await AppUtil.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not found');
      }

      UserModel? isUserApp = await _userRepository.checkUserExistsByEmail(email);

      await _repository.createTrustedContact(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        relationship: relationship,
        linkedUserId: isUserApp.uid,
      );

      await loadContacts();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding contact: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateContact({
    required String contactId,
    String? name,
    String? phoneNumber,
    String? email,
    String? relationship,
    String? linkedUserId,
  }) async {
    try {
      await _repository.updateTrustedContact(
        contactId: contactId,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        relationship: relationship,
        linkedUserId: linkedUserId,
      );

      await loadContacts();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating contact: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      await _repository.deactivateTrustedContact(contactId);

      await loadContacts();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting contact: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> permanentlyDeleteContact(String contactId) async {
    try {
      await _repository.deleteTrustedContact(contactId);

      await loadContacts();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error permanently deleting contact: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshContacts() async {
    await loadContacts();
  }
}
