import 'package:flutter/material.dart';
import 'transfer_screen6.dart';

class TransferScreen5 extends StatelessWidget {
  final String amount;
  final String reference;
  final String paymentDetails;
  final String recipientName;
  final String recipientPhone;
  final String senderName;

  const TransferScreen5({
    super.key,
    required this.amount,
    required this.reference,
    required this.paymentDetails,
    this.recipientName = 'TOM HAALAND',
    this.recipientPhone = '1233 3566 2352',
    this.senderName = 'JOHN SMITH',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5F0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFE5F0),
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
        title: const SizedBox.shrink(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Secure authorisation label
                  Text(
                    'Secure authorisation',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFFB8697E),
                      letterSpacing: 0.5,
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
                  _buildDetailRow(
                    label: 'To',
                    value1: recipientName,
                    value2: recipientPhone,
                  ),
                  const SizedBox(height: 24),

                  // From Section
                  _buildDetailRow(
                    label: 'From',
                    value1: senderName,
                  ),
                  const SizedBox(height: 24),

                  // Transaction type Section
                  _buildDetailRow(
                    label: 'Transaction type',
                    value1: 'Transfer',
                  ),
                  const SizedBox(height: 24),

                  // Date & time Section
                  _buildDetailRow(
                    label: 'Date & time',
                    value1: '23 May 2025, 12:03AM',
                  ),
                ],
              ),
            ),
          ),
          // Buttons at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                // Reject and Approve buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Transfer Screen 6 with failed status
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransferScreen6(
                                amount: amount,
                                recipientName: 'TOM HAALAND',
                                recipientPhone: '1233 3566 2352',
                                senderName: 'JOHN SMITH',
                                isSuccessful: false,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Transfer Screen 6 (result screen)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransferScreen6(
                                amount: amount,
                                recipientName: 'TOM HAALAND',
                                recipientPhone: '1233 3566 2352',
                                senderName: 'JOHN SMITH',
                                isSuccessful: true,
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
                          elevation: 0,
                        ),
                        child: Text(
                          'Approve',
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
                const SizedBox(height: 16),

                // Help Me button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle help
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Help support will be contacted'),
                          backgroundColor: Color(0xFFFF1F70),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF1F70),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Help Me!',
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
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value1,
    String? value2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Color(0xFFB8697E),
          ),
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
            ]
          ],
        ),
      ],
    );
  }
}
