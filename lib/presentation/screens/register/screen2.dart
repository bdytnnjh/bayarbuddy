import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final TextEditingController _phoneNumberController = TextEditingController(
    text: '+1 8456 5846 5846',
  );

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Phone Number'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Subtitle
              Center(
                child: Text(
                  'Please add your\nmobile phone number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.colors.grey,
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: AppTheme.typography.primary,
                  ),
                ),
              ),
              const SizedBox(height: 80),

              // Phone Number Label
              Text(
                '* Phone Number',
                style: TextStyle(
                  color: AppTheme.colors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Phone Number Input Field
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: AppTheme.colors.textSecondary,
                  fontSize: 14,
                  fontFamily: AppTheme.typography.primary,
                ),
                decoration: InputDecoration(
                  hintText: '+1 8456 5846 5846',
                  hintStyle: TextStyle(
                    color: AppTheme.colors.grey,
                    fontSize: 14,
                    fontFamily: AppTheme.typography.primary,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.colors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 120),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirm action
                    if (_phoneNumberController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a phone number'),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.typography.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
