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

  /// Load transfer histories for a user (combine incoming and outgoing)
  Future<void> loadTransferHistories(String userId, String walletNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load both incoming and outgoing transfers
      final outgoing = await _transferRepository.getOutgoingTransfers(userId);
      final incoming = await _transferRepository.getIncomingTransfers(walletNumber);

      // Combine both lists
      _histories = [...outgoing, ...incoming];

      // Sort by date (newest first)
      _histories.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
  Future<void> refreshTransferHistories(String userId, String walletNumber) async {
    await loadTransferHistories(userId, walletNumber);
    await loadIncomingTransfers(walletNumber);
    await loadOutgoingTransfers(userId);
  }

  /// Stream transfer histories (real-time updates) - combines incoming and outgoing
  void streamTransferHistories(String userId, String walletNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get both streams
      final outgoingStream = _transferRepository.streamUserTransferHistories(userId);

      outgoingStream.listen(
        (outgoing) async {
          try {
            // Get incoming transfers
            final incoming = await _transferRepository.getIncomingTransfers(walletNumber);

            // Combine and sort
            _histories = [...outgoing, ...incoming];
            _histories.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            _isLoading = false;
            _error = null;
            notifyListeners();
          } catch (e) {
            _error = e.toString();
            _isLoading = false;
            notifyListeners();
          }
        },
        onError: (error) {
          _error = error.toString();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
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
