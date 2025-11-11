import 'package:app/presentation/screens/transfer/transfer_screen2.dart';
import 'package:flutter/material.dart';

class TransferScreen1 extends StatefulWidget {
  const TransferScreen1({super.key});

  @override
  State<TransferScreen1> createState() => _TransferScreen1State();
}

class _TransferScreen1State extends State<TransferScreen1> {
  String selectedTab = 'SELF';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFF1F70),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Transfer To',
          style: TextStyle(
            fontFamily: 'Amaranth',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Section
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('SELF'),
                  const SizedBox(width: 12),
                  _buildTabButton('OTHERS'),
                  const SizedBox(width: 12),
                  _buildTabButton('DUITNOW'),
                  const SizedBox(width: 12),
                  _buildTabButton('ASNB'),
                  const SizedBox(width: 12),
                  _buildTabButton('TABUNG HA'),
                  if (selectedTab == 'OTHERS') ...[
                    const SizedBox(width: 12),
                    _buildTabButton('OVERSEAS'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content based on selected tab
            if (selectedTab == 'SELF') ...[
              // Wallet Section
              _buildAccountCard(
                title: 'Wallet',
                accountNumber: '1132 2233 1234',
                balance: 'RM 0.40',
              ),
              const SizedBox(height: 24),

              // Saving Account Section
              _buildAccountCard(
                title: 'Saving Account',
                accountNumber: '1511 1356 2213',
                balance: 'RM 44,123.22',
              ),
            ] else if (selectedTab == 'OTHERS') ...[
              // New Transfer Section
              Text(
                'New Transfer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF1F70),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTransferOptionButton('Banks')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTransferOptionButton('DuitNow')),
                ],
              ),
              const SizedBox(height: 32),

              // Favourites Section
              Text(
                'Favourites',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF1F70),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFavouriteCircle(null), // Add new favourite button
                    const SizedBox(width: 12),
                    _buildFavouriteCircle('assets/imgs/user_avatar.png'),
                    const SizedBox(width: 12),
                    _buildFavouriteCircle('assets/imgs/user_avatar.png'),
                    const SizedBox(width: 12),
                    _buildFavouriteCircle('assets/imgs/user_avatar.png'),
                    const SizedBox(width: 12),
                    _buildFavouriteCircle('assets/imgs/user_avatar.png'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Add Favourites to List',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF1F70),
                  ),
                ),
              ),
            ] else ...[
              // Default content for other tabs
              Center(
                child: Text(
                  'Content for $selectedTab',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Color(0xFFFF1F70) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Color(0xFFFF1F70) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard({
    required String title,
    required String accountNumber,
    required String balance,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF1F70),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          accountNumber,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          balance,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1,
          color: Color(0xFFFF1F70),
        ),
      ],
    );
  }

  Widget _buildTransferOptionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteCircle(String? avatarPath) {
    if (avatarPath == null) {
      // Add new favourite button
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          color: Color(0xFFFF1F70),
          size: 28,
        ),
      );
    } else {
      // Favourite contact - make it clickable
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen2()));
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(avatarPath),
          ),
        ),
      );
    }
  }
}
