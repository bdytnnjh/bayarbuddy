import 'dart:developer' as dev;
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/data/models/receiver_model.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/data/repositories/wallet_repository.dart';
import 'package:app/presentation/screens/main/transfer/enter_amount_screen.dart';
import 'package:app/presentation/screens/main/transfer/providers/tranfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectReceiverScreen extends StatefulWidget {
  final String transferType; // 'banks' or 'duitnow'
  final String amount;
  final String reference;
  final String paymentDetails;

  const SelectReceiverScreen({
    super.key,
    required this.transferType,
    this.amount = '0.00',
    this.reference = '',
    this.paymentDetails = '',
  });

  @override
  State<SelectReceiverScreen> createState() => _SelectReceiverScreenState();
}

class _SelectReceiverScreenState extends State<SelectReceiverScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WalletRepository _walletRepository = WalletRepository();
  final UserRepository _userRepository = UserRepository();

  ReceiverModel? _foundReceiver;
  bool _isSearching = false;
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchWalletNumber(String walletNumber) async {
    print('Searching wallet number: $walletNumber');
    if (walletNumber.isEmpty) {
      setState(() {
        _foundReceiver = null;
        _searchError = null;
        _isSearching = false;
      });
      return;
    }

    if (walletNumber.length != 12) {
      setState(() {
        _foundReceiver = null;
        _searchError = 'Wallet number must be 12 digits';
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
      _foundReceiver = null;
    });

    try {
      // Search wallet by number
      final wallet = await _walletRepository.searchWalletByNumber(walletNumber);

      if (wallet == null) {
        setState(() {
          _searchError = 'Wallet number not found';
          _isSearching = false;
        });
        return;
      }

      // Get user data
      final userData = await _userRepository.getUserByUid(uid: wallet.userId);

      if (userData == null) {
        setState(() {
          _searchError = 'User data not found';
          _isSearching = false;
        });
        return;
      }

      // Create receiver model
      final receiver = ReceiverModel.fromUserAndWallet(userData: userData, walletNumber: walletNumber);

      setState(() {
        _foundReceiver = receiver;
        _isSearching = false;
      });
    } catch (e) {
      dev.log('Error searching wallet: $e');
      setState(() {
        _searchError = 'Error searching wallet: ${e.toString()}';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Select Receiver'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instruction Text
            Text(
              'Enter 12-digit wallet number',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: _searchWalletNumber,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: InputDecoration(
                hintText: 'Enter wallet number (12 digits)',
                hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _foundReceiver = null;
                            _searchError = null;
                            _isSearching = false;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),

            // Search Status/Results
            if (_isSearching)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFFFF1F70)),
                    SizedBox(height: 12),
                    Text(
                      'Searching wallet...',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            if (_searchError != null && !_isSearching)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _searchError!,
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),

            if (_foundReceiver != null && !_isSearching)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receiver Found',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReceiverCard(_foundReceiver!),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverCard(ReceiverModel receiver) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF1F70), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFFF1F70).withValues(alpha: 0.1),
                backgroundImage: receiver.photoUrl != null ? NetworkImage(receiver.photoUrl!) : null,
                child: receiver.photoUrl == null
                    ? Text(
                        receiver.name.isNotEmpty ? receiver.name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF1F70),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Receiver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiver.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      receiver.walletNumber,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (receiver.phoneNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        receiver.phoneNumber!,
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Save receiver to provider
                final transferProvider = Provider.of<TransferProvider>(context, listen: false);
                transferProvider.setReceiver(receiver);

                // Navigate to enter amount screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterAmountScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1F70),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
