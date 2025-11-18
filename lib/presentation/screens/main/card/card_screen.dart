import 'package:app/presentation/shared/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: Scaffold(
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
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CardScreen()));
                              },
                              child: _buildCardWidget('VISA', wallet.walletNummer, wallet.balance.toStringAsFixed(2)),
                            );
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

                    // Cash Backs Section
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

                    // Cash Back Items
                    _buildCashBackItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Entertainment',
                      time: '4:34 PM',
                      amount: 'RM 5.40',
                      backgroundColor: Color(0xFFB3E5FC),
                    ),
                    const SizedBox(height: 12),
                    _buildCashBackItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Food Delivery',
                      time: '6:57 PM',
                      amount: 'RM 4.70',
                      backgroundColor: Color(0xFFFF1F70),
                    ),
                    const SizedBox(height: 12),
                    _buildCashBackItemWithAvatar(
                      avatarPath: 'assets/imgs/user_avatar.png',
                      title: 'Sarah',
                      time: '12:23 AM',
                      amount: 'RM 5.00',
                    ),
                    const SizedBox(height: 32),

                    // Bottom Navigation Placeholder (optional for future use)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
                balance,
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

  Widget _buildCashBackItem({
    required IconData icon,
    required String title,
    required String time,
    required String amount,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: backgroundColor == Color(0xFFFF1F70) ? Colors.white : Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  time,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_outward, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF1F70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashBackItemWithAvatar({
    required String avatarPath,
    required String title,
    required String time,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: AssetImage(avatarPath)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  time,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_outward, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF1F70),
            ),
          ),
        ],
      ),
    );
  }
}
