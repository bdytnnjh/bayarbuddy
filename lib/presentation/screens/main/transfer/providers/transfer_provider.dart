import 'package:app/data/models/receiver_model.dart';
import 'package:app/data/repositories/transfer_repository.dart';
import 'package:app/data/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';

class TransferProvider with ChangeNotifier {
  // Repositories
  final TransferRepository _transferRepository = TransferRepository();
  final WalletRepository _walletRepository = WalletRepository();

  // Transfer data
  ReceiverModel? _receiver;
  String _amount = '';
  String _reference = '';
  String _paymentDetails = '';
  String? _currentTransferHistoryId;
  bool _isProcessing = false;
  String? _errorMessage;

  // Getters
  ReceiverModel? get receiver => _receiver;
  String get amount => _amount;
  String get reference => _reference;
  String get paymentDetails => _paymentDetails;
  String? get currentTransferHistoryId => _currentTransferHistoryId;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  // Check if transfer data is complete
  bool get hasReceiver => _receiver != null;
  bool get hasAmount => _amount.isNotEmpty && double.tryParse(_amount) != null;
  bool get hasReference => _reference.isNotEmpty;
  bool get isTransferReady => hasReceiver && hasAmount;

  // Setters with notification
  void setReceiver(ReceiverModel receiver) {
    _receiver = receiver;
    notifyListeners();
  }

  void setAmount(String amount) {
    _amount = amount;
    notifyListeners();
  }

  void setReference(String reference) {
    _reference = reference;
    notifyListeners();
  }

  void setPaymentDetails(String details) {
    _paymentDetails = details;
    notifyListeners();
  }

  // Clear all transfer data
  void clearTransfer() {
    _receiver = null;
    _amount = '';
    _reference = '';
    _paymentDetails = '';
    notifyListeners();
  }

  // Validate amount
  String? validateAmount(String value) {
    if (value.isEmpty) {
      return 'Please enter amount';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > 100000) {
      return 'Amount exceeds maximum limit';
    }

    return null;
  }

  // Get formatted amount
  String get formattedAmount {
    if (_amount.isEmpty) return 'RM 0.00';
    final amount = double.tryParse(_amount);
    if (amount == null) return 'RM 0.00';
    return 'RM ${amount.toStringAsFixed(2)}';
  }

  // Execute transfer (create pending transfer)
  Future<Map<String, dynamic>> executeTransfer({
    required String senderUid,
    required String senderName,
    required String senderWalletId,
    bool isDistressSignal = false,
  }) async {
    if (_receiver == null || _amount.isEmpty) {
      return {'success': false, 'message': 'Invalid transfer data'};
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final amountValue = double.parse(_amount);
      final description = _reference.isNotEmpty ? _reference : _paymentDetails;

      final result = await _transferRepository.executeTransfer(
        senderUid: senderUid,
        senderName: senderName,
        senderWalletId: senderWalletId,
        recipientWalletNumber: _receiver!.walletNumber,
        recipientName: _receiver!.name,
        amount: amountValue,
        description: description,
        isDistressSignal: isDistressSignal,
      );

      if (result['success']) {
        _currentTransferHistoryId = result['historyId'];
      } else {
        _errorMessage = result['message'];
      }

      _isProcessing = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isProcessing = false;
      _errorMessage = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    }
  }

  // Approve transfer (update balances)
  Future<Map<String, dynamic>> approveTransfer({required String senderWalletId}) async {
    if (_currentTransferHistoryId == null || _receiver == null || _amount.isEmpty) {
      return {'success': false, 'message': 'Invalid transfer data'};
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final amountValue = double.parse(_amount);

      final result = await _transferRepository.approveTransfer(
        historyId: _currentTransferHistoryId!,
        senderWalletId: senderWalletId,
        recipientWalletNumber: _receiver!.walletNumber,
        amount: amountValue,
      );

      if (!result['success']) {
        _errorMessage = result['message'];
      }

      _isProcessing = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isProcessing = false;
      _errorMessage = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    }
  }

  // Reject transfer
  Future<void> rejectTransfer() async {
    print('Rejecting transfer...');
    print(_currentTransferHistoryId);
    if (_currentTransferHistoryId == null) return;

    _isProcessing = true;
    notifyListeners();

    try {
      await _transferRepository.rejectTransfer(_currentTransferHistoryId!);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isProcessing = false;
    notifyListeners();
  }

  // Get sender's primary wallet
  Future<String?> getSenderWalletId(String userId) async {
    try {
      final wallets = await _walletRepository.getWalletByUserId(userId);
      if (wallets.isEmpty) return null;

      // Return primary wallet or first wallet
      final primaryWallet = wallets.firstWhere((w) => w.isPrimary, orElse: () => wallets.first);

      return primaryWallet.id;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }
}
