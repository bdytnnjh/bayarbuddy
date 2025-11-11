import 'package:flutter/material.dart';
import 'transfer_screen5.dart';

class TransferScreen4 extends StatelessWidget {
  final String reference;
  final String paymentDetails;
  final String amount;

  const TransferScreen4({
    super.key,
    required this.reference,
    required this.paymentDetails,
    this.amount = '700.00',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFF1F70),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Transfer To',
          style: TextStyle(
            fontFamily: 'Amaranth',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // You're Sending Label
            Text(
              "YOU'RE SENDING",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey[600],
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // Amount
            Text(
              'RM $amount',
              style: TextStyle(
                fontFamily: 'Amaranth',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF1F70),
              ),
            ),
            const SizedBox(height: 24),

            // Recipient Avatar
            CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/imgs/user_avatar.png'),
            ),
            const SizedBox(height: 24),

            // TO Label
            Text(
              'TO',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey[600],
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // Recipient Name
            Text(
              'TOM HAALAND',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF1F70),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              height: 1,
              color: Color(0xFFFF1F70),
            ),
            const SizedBox(height: 24),

            // Account Details Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Details:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF1F70),
                  ),
                ),
                const SizedBox(height: 16),

                // Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7EFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Reference Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recipient reference',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      reference,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7EFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bank Name Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bank Name',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'MAYBANK',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7EFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bank Name Row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bank Name',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Optional',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7EFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  height: 1,
                  color: Color(0xFFFF1F70),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Transfer Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Transfer Screen 5 for secure authorisation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferScreen5(
                        amount: amount,
                        reference: reference,
                        paymentDetails: paymentDetails,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Transfer Now',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
