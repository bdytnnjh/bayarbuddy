import 'package:app/core/utils/app_util.dart';
import 'package:app/data/models/wallet_model.dart';
import 'package:app/data/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';

class WalletProvider with ChangeNotifier {
  final WalletRepository _walletRepository = WalletRepository();
  bool _disposed = false;

  // Initializer
  WalletProvider() {
    _initializeWallets();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  List<WalletModel> _wallets = [];
  bool _isLoading = false;
  String? _error;

  List<WalletModel> get wallets => _wallets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setWallets(List<WalletModel> wallets) {
    _wallets = wallets;
    _notifyListeners();
  }

  /// Initialize wallets for the current user
  void _initializeWallets() async {
    await loadWallets();
  }

  /// Refresh wallets
  Future<void> refreshWallets() async {
    await loadWallets();
  }

  /// Load wallets for the current user
  Future<void> loadWallets() async {
    _isLoading = true;
    _error = null;
    _notifyListeners();

    try {
      String? userId = await AppUtil.getCurrentUserId();

      if (userId != null) {
        List<WalletModel> wallets = await _walletRepository.getWalletByUserId(userId);
        _wallets = wallets;
      } else {
        _error = 'User not found';
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading wallets: $e');
    } finally {
      _isLoading = false;
      _notifyListeners();
    }
  }
}
