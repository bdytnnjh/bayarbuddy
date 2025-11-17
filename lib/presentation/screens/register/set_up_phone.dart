import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/button_widget.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/register/providers/register_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetUpPhoneScreen extends StatefulWidget {
  const SetUpPhoneScreen({super.key});

  @override
  State<SetUpPhoneScreen> createState() => _SetUpPhoneScreenState();
}

class _SetUpPhoneScreenState extends State<SetUpPhoneScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    // Validate input
    if (_phoneNumberController.text.trim().isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    // Save phone and create profile
    final registerProvider = Provider.of<RegisterProvider>(
      context,
      listen: false,
    );
    final success = await registerProvider.savePhoneAndCreateProfile(
      phoneNumber: _phoneNumberController.text.trim(),
    );

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else if (registerProvider.error != null && mounted) {
      _showError(registerProvider.error!);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Phone Number'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Consumer<RegisterProvider>(
            builder: (context, registerProvider, child) {
              return Column(
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
                    enabled: !registerProvider.isLoading,
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
                  Center(
                    child: registerProvider.isLoading
                        ? CircularProgressIndicator()
                        : ButtonWidget.rectangle(
                            context: context,
                            text: 'Confirm',
                            width: 150,
                            type: ButtonType.primary,
                            onPressed: _handleConfirm,
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
