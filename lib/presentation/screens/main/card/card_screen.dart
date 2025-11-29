import 'package:app/core/utils/app_util.dart';
import 'package:app/data/models/transfer_history_model.dart';
import 'package:app/presentation/shared/providers/app_provider.dart';
import 'package:app/presentation/shared/providers/transfer_history_provider.dart';
import 'package:app/presentation/shared/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      final historyProvider = Provider.of<TransferHistoryProvider>(context, listen: false);

      final userId = await AppUtil.getCurrentUserId();
      setState(() {
        _userId = userId;
      });

      if (userId != null) {
        // Wait for wallets to load
        await walletProvider.loadWallets();

        if (walletProvider.primaryWallet != null) {
          // Load combined histories (incoming + outgoing)
          historyProvider.loadTransferHistories(userId, walletProvider.primaryWallet!.walletNummer);
        }
      }
    });
  }

  Widget _buildCardWidget(String cardType, String cardInfo, String balance) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/imgs/visa_logo.webp', width: 40, height: 25),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cardType, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(
                      cardInfo,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'RM $balance',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(String currency, String amount, {required bool isActive}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFFF1F70) : Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currency,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
              Icon(Icons.arrow_outward, size: 16, color: isActive ? Colors.white : Colors.black),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferHistoryItem(TransferHistoryModel history) {
    // Determine if incoming or outgoing based on senderUid
    final isIncoming = _userId != null && history.senderUid != _userId;

    // Format time from createdAt timestamp
    final dateTime = history.createdAt;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final formattedTime = '$hour:$minute';

    // Determine color, icon, and prefix based on transaction type and status
    Color statusColor;
    IconData statusIcon;
    String amountPrefix;

    if (history.status == TransferStatus.success) {
      if (isIncoming) {
        statusColor = Colors.green;
        statusIcon = Icons.arrow_downward;
        amountPrefix = '+';
      } else {
        statusColor = Colors.red;
        statusIcon = Icons.arrow_upward;
        amountPrefix = '-';
      }
    } else if (history.status == TransferStatus.failed || history.status == TransferStatus.rejected) {
      statusColor = Colors.red;
      statusIcon = Icons.error_outline;
      amountPrefix = isIncoming ? '+' : '-';
    } else {
      // Pending
      statusColor = Colors.orange;
      statusIcon = Icons.pending_outlined;
      amountPrefix = isIncoming ? '+' : '-';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.recipientName,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  formattedTime,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (history.isDistressSignal) Icon(Icons.warning_amber_rounded, size: 20, color: Colors.red),
          if (history.isDistressSignal) const SizedBox(width: 8),
          const SizedBox(width: 12),
          Text(
            '$amountPrefix RM ${history.amount.toStringAsFixed(2)}',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: statusColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, child) {
          return RefreshIndicator(
            onRefresh: () => walletProvider.refreshWallets(),
            color: Color(0xFFFF1F70),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Widget
                  // Card Section
                  if (walletProvider.isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(color: Color(0xFFFF1F70)),
                      ),
                    )
                  else if (walletProvider.error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Error loading wallets', style: TextStyle(color: Colors.red)),
                            SizedBox(height: 8),
                            ElevatedButton(onPressed: () => walletProvider.refreshWallets(), child: Text('Retry')),
                          ],
                        ),
                      ),
                    )
                  else if (walletProvider.wallets.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text('No wallets found', style: TextStyle(color: Colors.grey[600])),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: walletProvider.wallets.map((wallet) {
                          return _buildCardWidget('VISA', wallet.walletNummer, wallet.balance.toStringAsFixed(2));
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Currency Selector Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCurrencyCard('USD', '72.28', isActive: true),
                      _buildCurrencyCard('Euro', '34.46', isActive: false),
                      _buildCurrencyCard('Yen', '95.31', isActive: false),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Add Card Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF1F70),
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Add Card',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Transaction History Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFFF1F70)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Transaction History List
                  Consumer<TransferHistoryProvider>(
                    builder: (context, historyProvider, child) {
                      if (historyProvider.isLoading) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(color: Color(0xFFFF1F70)),
                          ),
                        );
                      }

                      if (historyProvider.error != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text('Error loading history', style: TextStyle(color: Colors.red)),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    final appProvider = Provider.of<AppProvider>(context, listen: false);
                                    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
                                    if (appProvider.loginStatus != null && walletProvider.primaryWallet != null) {
                                      historyProvider.refreshTransferHistories(
                                        appProvider.loginStatus!,
                                        walletProvider.primaryWallet!.walletNummer,
                                      );
                                    }
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (historyProvider.histories.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
                                SizedBox(height: 16),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Show only the latest 3 transactions
                      final latestHistories = historyProvider.histories.take(3).toList();

                      return Column(
                        children: latestHistories.map((history) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildTransferHistoryItem(history),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Bottom Navigation Placeholder (optional for future use)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
