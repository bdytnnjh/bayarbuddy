import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/button_widget.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/register/providers/register_provider.dart';
import 'package:app/presentation/screens/register/set_up_phone_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetUpNameScreen extends StatefulWidget {
  const SetUpNameScreen({super.key});

  @override
  State<SetUpNameScreen> createState() => _SetUpNameScreenState();
}

class _SetUpNameScreenState extends State<SetUpNameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleSetName() {
    // Validate input
    if (_firstNameController.text.trim().isEmpty) {
      _showError('Please enter your first name');
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      _showError('Please enter your last name');
      return;
    }

    // Save name to provider
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    registerProvider.saveName(firstName: _firstNameController.text.trim(), lastName: _lastNameController.text.trim());

    // Navigate to phone setup screen
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SetUpPhoneScreen()));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
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
                style: TextStyle(color: AppTheme.colors.grey, fontSize: 14, fontFamily: AppTheme.typography.primary),
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
                    decoration: BoxDecoration(color: AppTheme.colors.primary, shape: BoxShape.circle),
                    child: Center(child: Icon(Icons.upload, color: Colors.white, size: 48)),
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
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.colors.primary)),
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
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.colors.primary)),
                ),
              ),
              const SizedBox(height: 80),

              // Set Button
              Center(
                child: ButtonWidget.rectangle(
                  context: context,
                  text: 'Set',
                  width: 115,
                  type: ButtonType.primary,
                  onPressed: _handleSetName,
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
