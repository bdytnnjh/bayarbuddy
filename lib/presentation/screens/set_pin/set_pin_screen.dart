import 'package:app/core/utils/session_util.dart';
import 'package:app/core/widgets/button_widget.dart';
import 'package:app/presentation/screens/set_pin/providers/set_pin_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetPinScreen extends StatelessWidget {
  final bool isVerifyMode;
  final String? hashedPin;

  const SetPinScreen({super.key, this.isVerifyMode = false, this.hashedPin});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider(
      create: (_) =>
          SetPinProvider()..setVerifyMode(isVerifyMode, hashedPin: hashedPin),
      child: _SetPinContent(uid: user?.uid ?? ''),
    );
  }
}

class _SetPinContent extends StatelessWidget {
  final String uid;

  const _SetPinContent({required this.uid});

  @override
  Widget build(BuildContext context) {
    final pinProvider = context.watch<SetPinProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Error Message
              if (pinProvider.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pinProvider.errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => pinProvider.clearError(),
                        color: Colors.red.shade700,
                      ),
                    ],
                  ),
                ),

              // Header with back button and title
              Text(
                pinProvider.isVerifyMode ? 'Enter Pin Code' : 'Set Pin Code',
                style: TextStyle(
                  fontFamily: 'Amaranth',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              // Failed attempts indicator (only in verify mode)
              if (pinProvider.isVerifyMode && pinProvider.failedAttempts > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Failed attempts: ${pinProvider.failedAttempts}/${pinProvider.maxFailedAttempts}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

              // Subtitle
              Text(
                pinProvider.isVerifyMode
                    ? 'Please enter your'
                    : 'Please set your own',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                'Pin Code',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),

              // PIN length indicator
              Text(
                'Set Pin Code (5-digit)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // PIN dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pinProvider.maxPinLength,
                  (index) => Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < pinProvider.pin.length
                          ? Color(0xFFFF1F70)
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Numeric keypad
              // Row 1: 1, 2, 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('1', context),
                  _buildKeypadButton('2', context),
                  _buildKeypadButton('3', context),
                ],
              ),
              const SizedBox(height: 24),

              // Row 2: 4, 5, 6
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('4', context),
                  _buildKeypadButton('5', context),
                  _buildKeypadButton('6', context),
                ],
              ),
              const SizedBox(height: 24),

              // Row 3: 7, 8, 9
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeypadButton('7', context),
                  _buildKeypadButton('8', context),
                  _buildKeypadButton('9', context),
                ],
              ),
              const SizedBox(height: 24),

              // Row 4: Face ID, 0, Fingerprint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCloseButton(context),
                  _buildKeypadButton('0', context),
                  _buildFingerprintButton(context),
                ],
              ),
              const SizedBox(height: 48),

              ButtonWidget.rectangle(
                width: 117,
                context: context,
                text: pinProvider.isVerifyMode ? 'Verify' : 'Set',
                type: ButtonType.primary,
                onPressed:
                    pinProvider.isLoading ||
                        (pinProvider.isVerifyMode &&
                            pinProvider.failedAttempts >=
                                pinProvider.maxFailedAttempts)
                    ? null
                    : () async {
                        if (pinProvider.isVerifyMode) {
                          // Verify PIN mode
                          final success = await pinProvider.verifyPin(uid: uid);
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else if (!success && context.mounted) {
                            // Check if account is blocked
                            if (pinProvider.failedAttempts >=
                                pinProvider.maxFailedAttempts) {
                              // Logout user if blocked
                              await SessionUtil().deleteSession(
                                SessionUtil().userKey,
                              );
                              Navigator.pushReplacementNamed(context, '/login');
                            }

                            // Show error snackbar when PIN is incorrect
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        pinProvider.errorMessage ??
                                            'Incorrect PIN. Please try again.',
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red.shade700,
                                duration: const Duration(seconds: 4),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } else {
                          // Set PIN mode
                          final success = await pinProvider.setPin(uid: uid);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PIN successfully set!'),
                                backgroundColor: Color(0xFFFF1F70),
                              ),
                            );
                            // Save session and navigate to home
                            await SessionUtil().writeSession(
                              SessionUtil().userKey,
                              uid,
                            );
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit, BuildContext context) {
    final pinProvider = context.read<SetPinProvider>();

    return ButtonWidget.circle(
      context: context,
      onPressed: () => pinProvider.addDigit(digit),
      type: ButtonType.secondary,
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    final pinProvider = context.read<SetPinProvider>();

    return GestureDetector(
      onTap: () {
        pinProvider.deleteDigit();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: Center(child: Icon(Icons.close, color: Colors.white, size: 28)),
      ),
    );
  }

  Widget _buildFingerprintButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Fingerprint action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fingerprint not implemented'),
            backgroundColor: Color(0xFFFF1F70),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: Center(
          child: Icon(Icons.fingerprint, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
