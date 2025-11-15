import 'package:flutter/material.dart';
import '../login/login_screen.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  String pin = '';
  final int maxPinLength = 5;

  void _addDigit(String digit) {
    if (pin.length < maxPinLength) {
      setState(() {
        pin += digit;
      });
    }
  }

  // void _deleteDigit() {
  //   if (pin.isNotEmpty) {
  //     setState(() {
  //       pin = pin.substring(0, pin.length - 1);
  //     });
  //   }
  // }

  void _setPin() {
    if (pin.length == maxPinLength) {
      debugPrint('PIN set: $pin');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a 5-digit PIN'),
          backgroundColor: Color(0xFFFF1F70),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Header with back button and title
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF1F70),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Set Pin Code',
                  style: TextStyle(
                    fontFamily: 'Amaranth',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Subtitle
            Text(
              'Please set your own',
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
                maxPinLength,
                (index) => Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < pin.length
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
                _buildKeypadButton('1'),
                _buildKeypadButton('2'),
                _buildKeypadButton('3'),
              ],
            ),
            const SizedBox(height: 24),

            // Row 2: 4, 5, 6
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKeypadButton('4'),
                _buildKeypadButton('5'),
                _buildKeypadButton('6'),
              ],
            ),
            const SizedBox(height: 24),

            // Row 3: 7, 8, 9
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKeypadButton('7'),
                _buildKeypadButton('8'),
                _buildKeypadButton('9'),
              ],
            ),
            const SizedBox(height: 24),

            // Row 4: Face ID, 0, Fingerprint
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFaceIdButton(),
                _buildKeypadButton('0'),
                _buildFingerprintButton(),
              ],
            ),
            const SizedBox(height: 48),

            // Set button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _setPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Set',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    final List<String> highlightedDigits = ['2', '5', '0', '6', '7'];
    bool isSelected = highlightedDigits.contains(digit);

    return GestureDetector(
      onTap: () => _addDigit(digit),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Color(0xFFFF1F70) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Color(0xFFFF1F70) : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            digit,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaceIdButton() {
    return GestureDetector(
      onTap: () {
        // Face ID action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Face ID not implemented'),
            backgroundColor: Color(0xFFFF1F70),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: Center(child: Icon(Icons.face, color: Colors.white, size: 28)),
      ),
    );
  }

  Widget _buildFingerprintButton() {
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
