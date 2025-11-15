import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class TransferScreen6 extends StatelessWidget {
  final String amount;
  final String recipientName;
  final String recipientPhone;
  final String senderName;
  final bool isSuccessful;

  const TransferScreen6({
    super.key,
    required this.amount,
    this.recipientName = 'TOM HAALAND',
    this.recipientPhone = '1233 3566 2352',
    this.senderName = 'JOHN SMITH',
    this.isSuccessful = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5F0),
      body: Column(
        children: [
          // Padding space instead of AppBar
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status label
                  Text(
                    isSuccessful ? 'Transaction successful' : 'Transaction failed',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isSuccessful ? Color(0xFF4CAF50) : Color(0xFFFF1F70),
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // To Section
                  _buildDetailRow(label: 'To', value1: recipientName, value2: recipientPhone),
                  const SizedBox(height: 24),

                  // From Section
                  _buildDetailRow(label: 'From', value1: senderName),
                  const SizedBox(height: 24),

                  // Transaction type Section
                  _buildDetailRow(label: 'Transaction type', value1: 'Transfer'),
                  const SizedBox(height: 24),

                  // Date & time Section
                  _buildDetailRow(label: 'Date & time', value1: '23 May 2025, 12:03AM'),
                ],
              ),
            ),
          ),
          // Done button at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Home Screen
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value1, String? value2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFB8697E)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value1,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B7EFF),
              ),
            ),
            if (value2 != null) ...[
              const SizedBox(height: 4),
              Text(
                value2,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5B7EFF),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
