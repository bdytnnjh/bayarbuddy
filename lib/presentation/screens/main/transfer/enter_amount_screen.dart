import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/main/transfer/enter_reference_screen.dart';
import 'package:app/presentation/screens/main/transfer/providers/tranfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterAmountScreen extends StatefulWidget {
  const EnterAmountScreen({super.key});

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
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
            amount = '0.${amountWithoutDecimal.padLeft(2, '0')}';
          } else {
            // 3+ digits: remove all leading zeros, then format
            String beforeDecimal = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 2);
            String afterDecimal = amountWithoutDecimal.substring(amountWithoutDecimal.length - 2);
            // Remove leading zeros from beforeDecimal
            beforeDecimal = beforeDecimal.replaceAll(RegExp(r'^0+'), '');
            if (beforeDecimal.isEmpty) beforeDecimal = '0';
            amount = '$beforeDecimal.$afterDecimal';
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
          amount = '0.${amountWithoutDecimal.padLeft(2, '0')}';
        } else {
          // 3+ digits: remove leading zeros
          String beforeDecimal = amountWithoutDecimal.substring(0, amountWithoutDecimal.length - 2);
          String afterDecimal = amountWithoutDecimal.substring(amountWithoutDecimal.length - 2);
          beforeDecimal = beforeDecimal.replaceAll(RegExp(r'^0+'), '');
          if (beforeDecimal.isEmpty) beforeDecimal = '0';
          amount = '$beforeDecimal.$afterDecimal';
        }
      } else {
        amount = '0.00';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarGlobal(title: 'Enter Amount'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Info from Provider
                  Consumer<TransferProvider>(
                    builder: (context, transferProvider, _) {
                      final receiver = transferProvider.receiver;
                      if (receiver == null) {
                        return const SizedBox.shrink();
                      }
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFFFF1F70).withValues(alpha: 0.1),
                            backgroundImage: receiver.photoUrl != null ? NetworkImage(receiver.photoUrl!) : null,
                            child: receiver.photoUrl == null
                                ? Text(
                                    receiver.name.isNotEmpty ? receiver.name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF1F70),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receiver.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  receiver.walletNumber,
                                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Amount Input
                  const Text(
                    'Enter amount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF1F70),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      'RM $amount',
                      style: const TextStyle(
                        fontFamily: 'Amaranth',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF1F70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Keypad
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFF1F70)),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                // Row 1-3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildKeypadButton('1'), _buildKeypadButton('2'), _buildKeypadButton('3')],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildKeypadButton('4'), _buildKeypadButton('5'), _buildKeypadButton('6')],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildKeypadButton('7'), _buildKeypadButton('8'), _buildKeypadButton('9')],
                ),
                const SizedBox(height: 16),

                // Bottom row: Delete, 0, Check
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
        decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: const Center(
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
        // Validate amount
        final transferProvider = Provider.of<TransferProvider>(context, listen: false);
        final error = transferProvider.validateAmount(amount);

        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error), backgroundColor: const Color(0xFFFF1F70)));
          return;
        }

        // Save amount to provider
        transferProvider.setAmount(amount);

        // Navigate to reference screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterReferenceScreen()));
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.check, color: Colors.white, size: 28)),
      ),
    );
  }
}
