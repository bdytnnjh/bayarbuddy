import 'dart:async';
import 'package:app/core/utils/app_util.dart';
import 'package:app/data/repositories/notification_repository.dart';
import 'package:app/data/repositories/scam_trigger_histories_repository.dart';
import 'package:app/data/repositories/trusted_contact_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class ConfirmTransferProvider with ChangeNotifier {
  final ScamTriggerHistoriesRepository _scamRepo = ScamTriggerHistoriesRepository();
  final TrustedContactRepository _trustedContactRepo = TrustedContactRepository();
  final NotificationRepository _notificationRepo = NotificationRepository();
  final UserRepository _userRepo = UserRepository();

  // Timer state
  Timer? _waitTimer;
  int _remainingSeconds = 30;
  bool _isWaitingPeriod = true;

  // Approve attempts tracking
  int _approveAttempts = 0;
  bool _isScamDetected = false;
  bool _isWaitingTrustedResponse = false;

  // Scam trigger history
  String? _currentScamTriggerId;

  // Getters
  int get remainingSeconds => _remainingSeconds;
  bool get isWaitingPeriod => _isWaitingPeriod;
  int get approveAttempts => _approveAttempts;
  bool get isScamDetected => _isScamDetected;
  bool get isWaitingTrustedResponse => _isWaitingTrustedResponse;
  bool get canApprove => !_isWaitingPeriod && !_isScamDetected && !_isWaitingTrustedResponse;
  bool get canReject => !_isWaitingTrustedResponse;

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }

  /// Initialize waiting period when screen loads
  void startWaitingPeriod() {
    _remainingSeconds = 30;
    _isWaitingPeriod = true;
    _approveAttempts = 0;
    _isScamDetected = false;
    _isWaitingTrustedResponse = false;
    notifyListeners();

    _waitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _isWaitingPeriod = false;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  /// Handle approve button press during waiting period
  Future<void> handleApproveAttempt({
    required String recipientName,
    required String recipientWalletNumber,
    required double amount,
  }) async {
    if (!_isWaitingPeriod) return;

    _approveAttempts++;
    notifyListeners();

    debugPrint('Approve attempt: $_approveAttempts');

    // If 3+ attempts during waiting period, trigger scam detection
    if (_approveAttempts >= 3 && !_isScamDetected) {
      final userId = await AppUtil.getCurrentUserId();
      await _triggerScamDetection(
        userId: userId!,
        recipientName: recipientName,
        recipientWalletNumber: recipientWalletNumber,
        amount: amount,
      );
    }
  }

  /// Trigger scam detection and send help request
  Future<void> _triggerScamDetection({
    required String userId,
    required String recipientName,
    required String recipientWalletNumber,
    required double amount,
  }) async {
    try {
      _isScamDetected = true;
      _isWaitingTrustedResponse = true;
      notifyListeners();

      debugPrint('⚠️ SCAM DETECTED - User made $_approveAttempts approve attempts during waiting period');

      // Create scam trigger history
      _currentScamTriggerId = await _scamRepo.createScamTrigger(
        userId: userId,
        transferId: 'transfer_${DateTime.now().millisecondsSinceEpoch}',
        recipientName: recipientName,
        recipientWalletNumber: recipientWalletNumber,
        amount: amount,
        triggerType: 'multiple_approve_attempts',
        approveAttempts: _approveAttempts,
      );

      debugPrint('Scam trigger history created: $_currentScamTriggerId');

      // Get user data
      final userData = await _userRepo.getUserByUid(uid: userId);
      final userName = userData?['fullName'] ?? userData?['username'] ?? 'Someone';

      // Get trusted contacts
      final trustedContacts = await _trustedContactRepo.getTrustedContactsByUserId(userId);

      if (trustedContacts.isEmpty) {
        debugPrint('No trusted contacts found - cannot send help request');
        _isWaitingTrustedResponse = false;
        notifyListeners();
        return;
      }

      // Prepare notification data
      final notificationData = {
        'type': 'scam_detection',
        'amount': amount.toString(),
        'recipientName': recipientName,
        'recipientPhone': recipientWalletNumber,
        'senderName': userName,
        'senderUid': userId,
        'scamTriggerId': _currentScamTriggerId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Send notifications to all trusted contacts
      int successCount = 0;
      for (final contact in trustedContacts) {
        if (contact.linkedUserId != null && contact.linkedUserId!.isNotEmpty) {
          try {
            await _notificationRepo.sendNotificationWithData(
              userId: contact.linkedUserId!,
              title: '🚨 SCAM ALERT: ${userName.toUpperCase()} MAY BE IN DANGER!',
              body:
                  'Suspicious activity detected! $_approveAttempts attempts to approve RM $amount transfer. Urgent response needed!',
              data: notificationData,
            );
            successCount++;
            debugPrint('Scam alert sent to ${contact.name}');
          } catch (e) {
            debugPrint('Failed to send scam alert to ${contact.name}: $e');
          }
        }
      }

      debugPrint('Scam alerts sent to $successCount trusted contact(s)');
    } catch (e) {
      debugPrint('Error in _triggerScamDetection: $e');
      _isWaitingTrustedResponse = false;
      notifyListeners();
    }
  }

  /// Resolve scam trigger (called when trusted contact responds or user cancels)
  Future<void> resolveScamTrigger({required String resolvedBy, required String resolution}) async {
    if (_currentScamTriggerId == null) return;

    try {
      await _scamRepo.resolveScamTrigger(
        historyId: _currentScamTriggerId!,
        resolvedBy: resolvedBy,
        resolution: resolution,
      );

      _isWaitingTrustedResponse = false;
      notifyListeners();

      debugPrint('Scam trigger resolved: $resolution by $resolvedBy');
    } catch (e) {
      debugPrint('Error resolving scam trigger: $e');
    }
  }

  /// Reset state (for testing or when user leaves screen)
  void resetState() {
    _waitTimer?.cancel();
    _remainingSeconds = 30;
    _isWaitingPeriod = false;
    _approveAttempts = 0;
    _isScamDetected = false;
    _isWaitingTrustedResponse = false;
    _currentScamTriggerId = null;
    notifyListeners();
  }
}
