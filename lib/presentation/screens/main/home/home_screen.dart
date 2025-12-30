import 'package:app/core/utils/app_util.dart';
import 'package:app/presentation/shared/providers/transfer_history_provider.dart';
import 'package:app/presentation/shared/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletProvider = Provider.of<WalletProvider>(
        context,
        listen: false,
      );
      final historyProvider = Provider.of<TransferHistoryProvider>(
        context,
        listen: false,
      );

      final userId = await AppUtil.getCurrentUserId();

      if (userId != null) {
        // Load outgoing transfers
        historyProvider.loadOutgoingTransfers(userId);

        // Wait for wallets to load, then load incoming transfers
        await walletProvider.loadWallets();
        if (walletProvider.primaryWallet != null) {
          historyProvider.loadIncomingTransfers(
            walletProvider.primaryWallet!.walletNumber,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<WalletProvider, TransferHistoryProvider>(
        builder: (context, walletProvider, historyProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              String? userId = await AppUtil.getCurrentUserId();
              if (userId == null || walletProvider.primaryWallet == null)
                return;

              historyProvider.refreshTransferHistories(
                userId,
                walletProvider.primaryWallet!.walletNumber,
              );
              walletProvider.refreshWallets();
            },
            color: Color(0xFFFF1F70),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Balance Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        walletProvider.calculateCurrentBalance(),
                        style: TextStyle(
                          fontFamily: 'Amaranth',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF1F70),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Card Section
                  if (walletProvider.isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF1F70),
                        ),
                      ),
                    )
                  else if (walletProvider.error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Error loading wallets',
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => walletProvider.refreshWallets(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (walletProvider.wallets.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No wallets found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: walletProvider.wallets.map((wallet) {
                          return _buildCardWidget(
                            'VISA',
                            wallet.walletNumber,
                            wallet.balance.toStringAsFixed(2),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Incoming Transactions Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Incoming Transactions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF1F70),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<TransferHistoryProvider>(
                    builder: (context, historyProvider, child) {
                      if (historyProvider.incomingHistories.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'No incoming transactions',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: historyProvider.incomingHistories
                              .take(5)
                              .map((history) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _buildTransactionCard(
                                    '+RM ${history.amount.toStringAsFixed(2)}',
                                    'From',
                                    history.senderName,
                                    _formatDate(history.createdAt),
                                    'assets/imgs/user_avatar.png',
                                    isIncoming: true,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Outgoing Transactions Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outgoing Transactions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF1F70),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<TransferHistoryProvider>(
                    builder: (context, historyProvider, child) {
                      if (historyProvider.outgoingHistories.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'No outgoing transactions',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: historyProvider.outgoingHistories
                              .take(5)
                              .map((history) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _buildTransactionCard(
                                    '-RM ${history.amount.toStringAsFixed(2)}',
                                    'To',
                                    history.recipientName,
                                    _formatDate(history.createdAt),
                                    'assets/imgs/user_avatar.png',
                                    isIncoming: false,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
                    Text(
                      cardType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF1F70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
    String amount,
    String label,
    String name,
    String date,
    String avatarPath, {
    required bool isIncoming,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 32, backgroundImage: AssetImage(avatarPath)),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncoming ? Color(0xFF00D4FF) : Color(0xFFFF3D00),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Flexible(
            child: Text(
              name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Text(date, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
