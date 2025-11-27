import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/main/transfer/detail_receiver_screen.dart';
import 'package:app/presentation/screens/main/transfer/providers/tranfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterReferenceScreen extends StatefulWidget {
  const EnterReferenceScreen({super.key});

  @override
  State<EnterReferenceScreen> createState() => _EnterReferenceScreenState();
}

class _EnterReferenceScreenState extends State<EnterReferenceScreen> {
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _paymentDetailsController =
      TextEditingController();

  @override
  void dispose() {
    _referenceController.dispose();
    _paymentDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Enter Reference'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Info
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/imgs/user_avatar.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1233 3566 2352',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TOM HAALAND',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'MAYBANK',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recipient Reference
            Text(
              'Enter recipient reference',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF1F70),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _referenceController,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2),
                ),
                hintText: 'Enter reference',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),

            // Payment Details
            Text(
              'Enter payment details (Optional)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF1F70),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _paymentDetailsController,
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2),
                ),
                hintText: 'Enter payment details',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 48),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_referenceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter recipient reference'),
                        backgroundColor: Color(0xFFFF1F70),
                      ),
                    );
                  } else {
                    // Save reference and payment details to provider
                    final transferProvider = Provider.of<TransferProvider>(
                      context,
                      listen: false,
                    );
                    transferProvider.setReference(_referenceController.text);
                    transferProvider.setPaymentDetails(
                      _paymentDetailsController.text,
                    );

                    // Navigate to Detail Receiver Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailReceiverScreen(
                          receiver: transferProvider.receiver!,
                          amount: transferProvider.amount,
                          reference: transferProvider.reference,
                          paymentDetails: transferProvider.paymentDetails,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continue',
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
