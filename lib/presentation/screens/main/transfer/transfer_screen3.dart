import 'package:app/presentation/screens/main/transfer/transfer_screen4.dart';
import 'package:flutter/material.dart';

class TransferScreen3 extends StatefulWidget {
  final String amount;

  const TransferScreen3({super.key, this.amount = '0.00'});

  @override
  State<TransferScreen3> createState() => _TransferScreen3State();
}

class _TransferScreen3State extends State<TransferScreen3> {
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _paymentDetailsController = TextEditingController();

  @override
  void dispose() {
    _referenceController.dispose();
    _paymentDetailsController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
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
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2)),
                hintText: 'Enter reference',
                hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[400]),
              ),
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black),
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
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF1F70), width: 2)),
                hintText: 'Enter payment details',
                hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[400]),
              ),
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 48),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_referenceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter recipient reference'), backgroundColor: Color(0xFFFF1F70)),
                    );
                  } else {
                    // Navigate to Transfer Screen 4 with reference and payment details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferScreen4(
                          reference: _referenceController.text,
                          paymentDetails: _paymentDetailsController.text,
                          amount: widget.amount,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
