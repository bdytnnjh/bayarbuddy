import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/data/models/receiver_model.dart';
import 'package:flutter/material.dart';
import 'confirm_transfer_screen.dart';

class DetailReceiverScreen extends StatelessWidget {
  final ReceiverModel receiver;
  final String amount;
  final String reference;
  final String paymentDetails;

  const DetailReceiverScreen({
    super.key,
    required this.receiver,
    this.amount = '0.00',
    this.reference = '',
    this.paymentDetails = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Transfer To'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // You're Sending Label
            Text(
              "YOU'RE SENDING",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600], letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),

            // Amount
            Text(
              'RM $amount',
              style: const TextStyle(
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
              backgroundColor: const Color(0xFFFF1F70).withValues(alpha: 0.1),
              backgroundImage: receiver.photoUrl != null ? NetworkImage(receiver.photoUrl!) : null,
              child: receiver.photoUrl == null
                  ? Text(
                      receiver.name.isNotEmpty ? receiver.name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF1F70),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 24),

            // TO Label
            Text(
              'TO',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey[600], letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),

            // Recipient Name
            Text(
              receiver.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF1F70),
              ),
            ),
            const SizedBox(height: 16),

            Container(height: 1, color: const Color(0xFFFF1F70)),
            const SizedBox(height: 24),

            // Account Details Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
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
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                    ),
                    const Text(
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
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      reference.isNotEmpty ? reference : 'No reference',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7EFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Wallet Number Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wallet Number',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      receiver.walletNumber,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7EFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Phone Number Row
                if (receiver.phoneNumber != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone Number',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        receiver.phoneNumber!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B7EFF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Email Row
                if (receiver.email != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                      ),
                      Flexible(
                        child: Text(
                          receiver.email!,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B7EFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Payment Details Row
                if (paymentDetails.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Details',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                      ),
                      Flexible(
                        child: Text(
                          paymentDetails,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B7EFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                Container(height: 1, color: const Color(0xFFFF1F70)),
              ],
            ),
            const SizedBox(height: 48),

            // Transfer Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmTransferScreen(
                        receiver: receiver,
                        amount: amount,
                        reference: reference,
                        paymentDetails: paymentDetails,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
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
