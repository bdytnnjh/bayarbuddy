import 'package:app/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawerHeader(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 35, backgroundImage: AssetImage('assets/imgs/user_avatar.png')),
                      Text(
                        "John Smith",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                      ),
                      Text("john.appleseed@apple.com", style: TextStyle(fontSize: 16, color: Color(0xFF838080))),
                    ],
                  ),
                ),
              ),
              _buildItemMenu('My Wallet', 'assets/imgs/icn_wallet.png'),
              _buildItemMenu(
                'Profile',
                'assets/imgs/icn_user.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(fullName: "Sendi", accountNumber: "123245"),
                    ),
                  );
                },
              ),
              _buildItemMenu('Statistic', 'assets/imgs/icn_chart.png'),
              _buildItemMenu('Transfer', 'assets/imgs/icn_transfer.png'),
              _buildItemMenu('Settings', 'assets/imgs/icn_settings.png'),
            ],
          ),
        ),
      ),
      body: Center(child: Text('Welcome to Bayar Buddy!', style: TextStyle(fontSize: 24))),
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
