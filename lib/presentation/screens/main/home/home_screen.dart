import 'package:app/presentation/screens/main/card/card_screen.dart';
import 'package:app/presentation/screens/main/profile/profile_screen.dart';
import 'package:app/presentation/screens/main/transfer/transfer_screen1.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 35, backgroundImage: AssetImage('assets/imgs/user_avatar.png')),
                    Text(
                      "John Smith",
                      style: TextStyle(fontFamily: 'Amaranth', fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "john.appleseed@apple.com",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            _buildItemMenu(
              'My Wallet',
              'assets/imgs/icn_wallet.png',
              // onTap: () {
              //   Navigator.pop(context);
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => MyWallet())));
              // },
            ),
            _buildItemMenu(
              'Profile',
              'assets/imgs/icn_user.png',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            _buildItemMenu('Statistics', 'assets/imgs/icn_chart.png'),
            _buildItemMenu(
              'Transfer',
              'assets/imgs/icn_transfer.png',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen1()));
              },
            ),
            _buildItemMenu('Settings', 'assets/imgs/icn_settings.png'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  backgroundColor: Color(0xFFFF1F70),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                child: Row(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/imgs/icn_logout.png', width: 20, height: 20, color: Colors.white),
                    Text('Log out', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'RM 34,565.78',
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CardScreen()));
                    },
                    child: _buildCardWidget('VISA', 'Master Card • 6253', 'RM 11,243.60'),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CardScreen()));
                    },
                    child: _buildCardWidget('VISA', 'Master Card • 6253', 'RM 11,243.60'),
                  ),
                ],
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTransactionCard(
                    '+RM 54.23',
                    'From',
                    'Johnny Bairdstow',
                    '23 December 2020',
                    'assets/imgs/user_avatar.png',
                    isIncoming: true,
                  ),
                  const SizedBox(width: 12),
                  _buildTransactionCard(
                    '+RM 62.54',
                    'From',
                    'Johnson Charles',
                    '23 December 2020',
                    'assets/imgs/user_avatar.png',
                    isIncoming: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Outgoing Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Outgoing Transactions',
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTransactionCard(
                    '-RM 39.84',
                    'From',
                    'John Morrison',
                    '12 December 2021',
                    'assets/imgs/user_avatar.png',
                    isIncoming: false,
                  ),
                  const SizedBox(width: 12),
                  _buildTransactionCard(
                    '-RM 45.21',
                    'From',
                    'Mellony Storke',
                    '12 December 2021',
                    'assets/imgs/user_avatar.png',
                    isIncoming: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWidget(String cardType, String cardInfo, String balance) {
    return Container(
      width: 300,
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
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      cardInfo,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                balance,
                style: TextStyle(
                  fontFamily: 'Poppins',
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
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 32, backgroundImage: AssetImage(avatarPath)),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncoming ? Color(0xFF00D4FF) : Color(0xFFFF3D00),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
          ),
          Flexible(
            child: Text(
              name,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isIncoming ? [Color(0xFFB3E5FC), Color(0xFF80DEEA)] : [Color(0xFFE8EAFD), Color(0xFFD1D5FF)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMenu(String title, String iconPath, {void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(iconPath, width: 24, height: 24),
      title: Text(title, style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
    );
  }
}
