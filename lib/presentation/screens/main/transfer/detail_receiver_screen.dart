import 'package:app/core/utils/app_util.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/data/models/receiver_model.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/presentation/screens/main/transfer/providers/transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'confirm_transfer_screen.dart';

class DetailReceiverScreen extends StatefulWidget {
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
  State<DetailReceiverScreen> createState() => _DetailReceiverScreenState();
}

class _DetailReceiverScreenState extends State<DetailReceiverScreen> {
  bool _isProcessing = false;

  /// Handle transfer initiation and navigation to confirmation screen
  Future<void> _handleTransferNow() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final transferProvider = Provider.of<TransferProvider>(context, listen: false);

      // Get current user UID
      final userUid = await AppUtil.getCurrentUserId();
      if (userUid == null) {
        _showErrorDialog('User not logged in');
        return;
      }

      // Get sender wallet ID
      final walletId = await transferProvider.getSenderWalletId(userUid);
      if (walletId == null) {
        _showErrorDialog('Wallet not found');
        return;
      }

      // Get sender name from UserRepository
      final userRepo = UserRepository();
      final userData = await userRepo.getUserByUid(uid: userUid);
      final senderName = userData?['fullName'] ?? 'Unknown';

      // Execute transfer first (creates pending history)
      final executeResult = await transferProvider.executeTransfer(
        senderUid: userUid,
        senderName: senderName,
        senderWalletId: walletId,
        isDistressSignal: false,
      );

      if (!executeResult['success']) {
        _showErrorDialog(executeResult['message'] ?? 'Transfer failed');
        return;
      }

      // Navigate to confirmation screen if still mounted
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmTransferScreen(
            receiver: widget.receiver,
            amount: widget.amount,
            reference: widget.reference,
            paymentDetails: widget.paymentDetails,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in _handleTransferNow: $e');
      _showErrorDialog(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Show error dialog with message
  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

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
              'RM ${widget.amount}',
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
              backgroundImage: widget.receiver.photoUrl != null ? NetworkImage(widget.receiver.photoUrl!) : null,
              child: widget.receiver.photoUrl == null
                  ? Text(
                      widget.receiver.name.isNotEmpty ? widget.receiver.name[0].toUpperCase() : 'U',
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
              widget.receiver.name.toUpperCase(),
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
                      widget.reference.isNotEmpty ? widget.reference : 'No reference',
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
                      widget.receiver.walletNumber,
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
                if (widget.receiver.phoneNumber != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone Number',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        widget.receiver.phoneNumber!,
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
                if (widget.receiver.email != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                      ),
                      Flexible(
                        child: Text(
                          widget.receiver.email!,
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
                if (widget.paymentDetails.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Details',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.grey[600]),
                      ),
                      Flexible(
                        child: Text(
                          widget.paymentDetails,
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
                onPressed: _isProcessing ? null : _handleTransferNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF1F70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
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
