import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/register/screen2.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TextEditingController _firstNameController = TextEditingController(
    text: 'Micheal',
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: 'Starc',
  );

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Profile'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Text(
                'Please set up your profile',
                style: TextStyle(
                  color: AppTheme.colors.grey,
                  fontSize: 14,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 40),

              // Profile Picture Upload
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle image upload
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.upload, color: Colors.white, size: 48),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 56),

              // First Name Field
              Text(
                'First Name',
                style: TextStyle(
                  color: AppTheme.colors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _firstNameController,
                style: TextStyle(
                  color: AppTheme.colors.textSecondary,
                  fontSize: 14,
                  fontFamily: AppTheme.typography.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'Micheal',
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
                    borderSide: BorderSide(color: AppTheme.colors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Last Name Field
              Text(
                'Last Name',
                style: TextStyle(
                  color: AppTheme.colors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _lastNameController,
                style: TextStyle(
                  color: AppTheme.colors.textSecondary,
                  fontSize: 14,
                  fontFamily: AppTheme.typography.primary,
                ),
                decoration: InputDecoration(
                  hintText: 'Starc',
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
                    borderSide: BorderSide(color: AppTheme.colors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 80),

              // Set Button
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Screen2(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Set',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.typography.primary,
                      ),
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
