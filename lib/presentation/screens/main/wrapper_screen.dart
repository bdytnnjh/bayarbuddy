import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/nav_bottom_bar_custom_widget.dart';
import 'package:app/presentation/screens/main/card/card_screen.dart';
import 'package:app/presentation/screens/main/home/home_screen.dart';
import 'package:app/presentation/screens/main/profile/profile_screen.dart';
import 'package:app/presentation/screens/main/transfer/transfer_screen1.dart';
import 'package:flutter/material.dart';

class WrapperScreen extends StatelessWidget {
  WrapperScreen({super.key});

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
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
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        'assets/imgs/user/avatar.png',
                      ),
                    ),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontFamily: 'Amaranth',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "john.appleseed@apple.com",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildItemMenu(
              'My Wallet',
              'assets/imgs/icn_wallet.png',
              // onTap: () {
              //  Navigator.pop(context);
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyWaller()));
              // }
            ),
            _buildItemMenu(
              'Profile',
              'assets/imgs/icn_user.png',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            _buildItemMenu('Statistics', 'assets/imgs/icn_chart.png'),
            _buildItemMenu(
              'Transfer',
              'assets/imgs/icn_transfer.png',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransferScreen1()),
                );
              },
            ),
            _buildItemMenu('Setings', 'assets/imgs/icn_settings.png'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  backgroundColor: Color(0xFFFF1F70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Row(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/imgs/icn_logout.png',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                    Text('Logout', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        children: [
          HomeScreen(),
          CardScreen(),
          TransferScreen1(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, value, child) {
          return NavBottomBarCustomWidget(
            items: [
              NavBottomBarCustomItem(
                imagePath: 'assets/imgs/icn_home.png',
                text: 'Home',
              ),
              NavBottomBarCustomItem(
                imagePath: 'assets/imgs/icn_wallet.png',
                text: 'Card',
              ),
              NavBottomBarCustomItem(
                imagePath: 'assets/imgs/icn_transfer.png',
                text: 'Transfer',
              ),
              NavBottomBarCustomItem(
                imagePath: 'assets/imgs/icn_user.png',
                text: 'Profile',
              ),
            ],
            backgroundColor: Colors.pink,
            unselectedColor: Colors.grey,
            selectedColor: AppTheme.colors.primary,
            onTabSelected: (index) {
              currentIndex.value = index;
              pageController.jumpToPage(index);
            },
            selected: value,
          );
        },
      ),
    );
  }

  Widget _buildItemMenu(
    String title,
    String iconPath, {
    void Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(iconPath, width: 24, height: 24),
      title: Text(title, style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
    );
  }
}
