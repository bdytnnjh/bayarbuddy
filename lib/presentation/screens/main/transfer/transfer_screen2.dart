import 'package:app/presentation/screens/main/transfer/transfer_screen3.dart';
import 'package:flutter/material.dart';

class TransferScreen2 extends StatefulWidget {
  const TransferScreen2({super.key});

  @override
  State<TransferScreen2> createState() => _TransferScreen2State();
}

class _TransferScreen2State extends State<TransferScreen2> {
  String amount = '0.00';

  void _addDigit(String digit) {
    setState(() {
      if (amount == '0.00') {
        amount = digit;
      } else {
        // Remove the decimal and add new digit
        String amountWithoutDecimal = amount.replaceAll('.', '');
        if (amountWithoutDecimal.length < 10) {
          amountWithoutDecimal += digit;
          // Format with decimal - always keep last 2 digits as decimal
          if (amountWithoutDecimal.length <= 2) {
            // 1-2 digits: pad with leading zeros
            amount = '0.' + amountWithoutDecimal.padLeft(2, '0');
          } else {
            // 3+ digits: remove all leading zeros, then format
            String beforeDecimal = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 2);
            String afterDecimal = amountWithoutDecimal.substring(amountWithoutDecimal.length - 2);
            // Remove leading zeros from beforeDecimal
            beforeDecimal = beforeDecimal.replaceAll(RegExp(r'^0+'), '');
            if (beforeDecimal.isEmpty) beforeDecimal = '0';
            amount = beforeDecimal + '.' + afterDecimal;
          }
        }
      }
    });
  }

  void _deleteDigit() {
    setState(() {
      String amountWithoutDecimal = amount.replaceAll('.', '');
      if (amountWithoutDecimal.length > 1) {
        amountWithoutDecimal = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 1);
        if (amountWithoutDecimal.length <= 2) {
          // 1-2 digits: pad with leading zeros
          amount = '0.' + amountWithoutDecimal.padLeft(2, '0');
        } else {
          // 3+ digits: remove leading zeros
          String beforeDecimal = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 2);
          String afterDecimal = amountWithoutDecimal.substring(amountWithoutDecimal.length - 2);
          beforeDecimal = beforeDecimal.replaceAll(RegExp(r'^0+'), '');
          if (beforeDecimal.isEmpty) beforeDecimal = '0';
          amount = beforeDecimal + '.' + afterDecimal;
        }
      } else {
        amount = '0.00';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Color(0xFFFF1F70), borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Transfer To',
          style: TextStyle(fontFamily: 'Amaranth', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Info
                  Row(
                    children: [
                      CircleAvatar(radius: 32, backgroundImage: AssetImage('assets/imgs/user_avatar.png')),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1233 3566 2352',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'TOM HAALAND',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'MAYBANK',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Amount Input
                  Text(
                    'Enter amount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF1F70),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'RM ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: amount == '0.00' ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          amount,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: amount == '0.00' ? Colors.grey[400] : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 2, color: Color(0xFFFF1F70)),
                ],
              ),
            ),
          ),

          // Numeric Keypad
          Container(
            color: Color(0xFFFF1F70),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Row 1: 1, 2, 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildKeypadButton('1'), _buildKeypadButton('2'), _buildKeypadButton('3')],
                ),
                const SizedBox(height: 16),

                // Row 2: 4, 5, 6
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildKeypadButton('4'), _buildKeypadButton('5'), _buildKeypadButton('6')],
                ),
                const SizedBox(height: 16),

                // Row 3: 7, 8, 9
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildKeypadButton('7'), _buildKeypadButton('8'), _buildKeypadButton('9')],
                ),
                const SizedBox(height: 16),

                // Row 4: X, 0, ✓
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildDeleteButton(), _buildKeypadButton('0'), _buildCheckButton()],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return GestureDetector(
      onTap: () => _addDigit(digit),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
        child: Center(
          child: Text(
            digit,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _deleteDigit,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Center(
          child: Text(
            'X',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to Transfer Screen 3 with amount
        Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen3(amount: amount)));
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Center(child: Icon(Icons.check, color: Colors.white, size: 28)),
      ),
    );
  }
}
