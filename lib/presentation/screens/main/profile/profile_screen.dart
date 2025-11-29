import 'package:app/presentation/screens/trusted_contact/trusted_contact_screen.dart';
import 'package:app/presentation/shared/providers/user_profile_provider.dart';
import 'package:app/presentation/shared/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/screens/limit/limit_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool fingerPrintEnabled = true;
  bool displayModeEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      profileProvider.loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Center(
                child: Text(
                  'Your Profile Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF878787)),
                ),
              ),
              Center(child: CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/imgs/user_avatar.png'))),
              SizedBox(height: 16.0),
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
              ),
              Consumer<UserProfileProvider>(
                builder: (context, profileProvider, child) {
                  if (profileProvider.isLoading) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: Color(0xFFFF1F70)),
                      ),
                    );
                  }

                  if (profileProvider.error != null) {
                    return _buildInfoRow('Error', profileProvider.error!);
                  }

                  final user = profileProvider.userProfile;
                  if (user == null) {
                    return _buildInfoRow('Full Name', 'Not loaded');
                  }

                  return Column(
                    children: [
                      _buildInfoRow('Full Name', user.fullName),
                      Consumer<WalletProvider>(
                        builder: (context, walletProvider, child) {
                          if (walletProvider.wallets.isEmpty) {
                            return _buildInfoRow('Account Number', 'Loading...');
                          }
                          return _buildInfoRow('Account Number', walletProvider.primaryWallet?.walletNummer ?? 'N/A');
                        },
                      ),
                      _buildInfoRow('Username', user.username),
                      _buildInfoRow('Email', user.email),
                      _buildInfoRow('Mobile Phone', user.phoneNumber),
                      _buildInfoRow('Address', 'N/A'),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),

              Text(
                'Security',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
              ),
              _buildNavigationRow('Change Pin', () {
                Navigator.pushNamed(context, '/set-pin');
              }),
              _buildNavigationRow('Change Password', () {}),
              _buildToggleRow('Finger Print', fingerPrintEnabled, (value) {
                setState(() {
                  fingerPrintEnabled = value;
                });
              }),
              SizedBox(height: 16.0),
              Text(
                'Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
              ),
              _buildNavigationRow('Limit Transactions', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LimitTransactionScreen()));
              }),
              _buildNavigationRow('Trusted Contacts', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TrustedContactScreen()));
              }),
              _buildToggleRow('Display Mode', displayModeEnabled, (value) {
                setState(() {
                  displayModeEnabled = value;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Color(0xfff4f4f4), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFFF1F70)),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFFF1F70), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFFF1F70)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFFFF1F70),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }
}
