import 'package:app/presentation/screens/set_pin/set_pin_screen.dart';
import 'package:app/presentation/shared/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPinScreen extends StatelessWidget {
  const VerifyPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();

    return FutureBuilder<String?>(
      future: appProvider.getHashedPin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF1F70)),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          // If no hashed PIN found, redirect to set PIN
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/set-pin');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return SetPinScreen(isVerifyMode: true, hashedPin: snapshot.data);
      },
    );
  }
}
