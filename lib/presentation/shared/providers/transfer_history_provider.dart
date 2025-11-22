import 'package:app/data/models/transfer_history_model.dart';
import 'package:app/data/repositories/transfer_repository.dart';
import 'package:flutter/material.dart';

class TransferHistoryProvider with ChangeNotifier {
  final TransferRepository _transferRepository = TransferRepository();

  List<TransferHistoryModel> _histories = [];
  List<TransferHistoryModel> _incomingHistories = [];
  List<TransferHistoryModel> _outgoingHistories = [];
  bool _isLoading = false;
  String? _error;

  List<TransferHistoryModel> get histories => _histories;
  List<TransferHistoryModel> get incomingHistories => _incomingHistories;
  List<TransferHistoryModel> get outgoingHistories => _outgoingHistories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load transfer histories for a user
  Future<void> loadTransferHistories(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _histories = await _transferRepository.getUserTransferHistories(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _histories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh transfer histories
  Future<void> refreshTransferHistories(String userId) async {
    await loadTransferHistories(userId);
  }

  /// Stream transfer histories (real-time updates)
  void streamTransferHistories(String userId) {
    _isLoading = true;
    notifyListeners();

    _transferRepository
        .streamUserTransferHistories(userId)
        .listen(
          (histories) {
            _histories = histories;
            _isLoading = false;
            _error = null;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  /// Get histories by status
  List<TransferHistoryModel> getHistoriesByStatus(String status) {
    return _histories.where((h) => h.status == status).toList();
  }

  /// Get success histories
  List<TransferHistoryModel> get successHistories {
    return getHistoriesByStatus(TransferStatus.success);
  }

  /// Get pending histories
  List<TransferHistoryModel> get pendingHistories {
    return getHistoriesByStatus(TransferStatus.pendingApproval);
  }

  /// Get failed histories
  List<TransferHistoryModel> get failedHistories {
    return getHistoriesByStatus(TransferStatus.failed);
  }

  /// Load incoming transfers (received money)
  Future<void> loadIncomingTransfers(String walletNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _incomingHistories = await _transferRepository.getIncomingTransfers(walletNumber);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _incomingHistories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load outgoing transfers (sent money)
  Future<void> loadOutgoingTransfers(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _outgoingHistories = await _transferRepository.getOutgoingTransfers(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _outgoingHistories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
