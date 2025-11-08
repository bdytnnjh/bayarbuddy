import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
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
              _buildInfoRow('Full Name', 'John Smith'),
              _buildInfoRow('Account Number', '02873902'),
              _buildInfoRow('Username', 'John.smith'),
              _buildInfoRow('Email', 'johnapple@apple.com'),
              _buildInfoRow('Mobile Phone', '+620875736547'),
              _buildInfoRow('Address', 'Gotham Road 32...'),
            ],
          )
        ),
      )
    );
  }
  Widget _buildInfoRow(String label, String value){
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Color(0xfff4f4f4), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
          ),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70))),
        ],
      ),
    );
  }
}