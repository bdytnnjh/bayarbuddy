import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String fullName;
  final String accountNumber;

  const ProfileScreen({super.key, required this.fullName, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Settings')),
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
              _buildInfoRow('Full Name', fullName),
              _buildInfoRow('Account Number', accountNumber),
              _buildInfoRow('Username', 'John.SMith'),
              _buildInfoRow('Email', 'john.appleseed@apple.com'),
              _buildInfoRow('Mobile Phone', '+620932938232'),
              _buildInfoRow('Address', 'Gotham Road 21...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
          ),
          Text(value, style: TextStyle(fontSize: 12, color: Color(0xFF001A4D))),
        ],
      ),
    );
  }
}
