import 'package:app/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title: Text('Home Screen')),
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
            _buildItemMenu('Transfer', 'assets/imgs/icn_transfer.png'),
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
                    Icon(Icons.login_outlined, color: Colors.white),
                    Text('Log out', style: TextStyle(color: Colors.white)),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text('Welcome to the Home Screen!', style: TextStyle(fontSize: 24))),
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
