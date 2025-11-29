import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/data/models/receiver_model.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/presentation/screens/main/transfer/providers/tranfer_provider.dart';
import 'package:app/presentation/shared/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'status_transfer_screen.dart';
import 'family_member.dart';

class ConfirmTransferScreen extends StatefulWidget {
  final ReceiverModel receiver;
  final String amount;
  final String reference;
  final String paymentDetails;

  const ConfirmTransferScreen({
    super.key,
    required this.receiver,
    required this.amount,
    this.reference = '',
    this.paymentDetails = '',
  });

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  bool _isProcessing = false;

  Future<void> _handleApprove(BuildContext context) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final transferProvider = Provider.of<TransferProvider>(context, listen: false);
      final appProvider = Provider.of<AppProvider>(context, listen: false);

      // Get current user UID
      final userUid = appProvider.loginStatus;
      if (userUid == null) {
        throw Exception('User not logged in');
      }

      // Get sender wallet ID
      final walletId = await transferProvider.getSenderWalletId(userUid);
      if (walletId == null) {
        throw Exception('Wallet not found');
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
        throw Exception(executeResult['message']);
      }

      // Approve transfer (updates balances)
      final approveResult = await transferProvider.approveTransfer(senderWalletId: walletId);

      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      // Navigate to status screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatusTransferScreen(
            amount: widget.amount,
            recipientName: widget.receiver.name,
            recipientPhone: widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
            senderName: 'You',
            isSuccessful: approveResult['success'],
          ),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Transfer failed: ${e.toString()}'), backgroundColor: Colors.red));

      // Navigate to failed status
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatusTransferScreen(
            amount: widget.amount,
            recipientName: widget.receiver.name,
            recipientPhone: widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
            senderName: 'You',
            isSuccessful: false,
          ),
        ),
      );
    }
  }

  Future<void> _handleReject(BuildContext context) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final transferProvider = Provider.of<TransferProvider>(context, listen: false);

      // Reject transfer
      await transferProvider.rejectTransfer();

      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      // Navigate to rejected status
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatusTransferScreen(
            amount: widget.amount,
            recipientName: widget.receiver.name,
            recipientPhone: widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
            senderName: 'You',
            isSuccessful: false,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5F0),
      appBar: AppBarGlobal(title: 'Confirm Transfer'),
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
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFB8697E), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),

                  // Amount
                  Text(
                    'RM ${widget.amount}',
                    style: const TextStyle(
                      fontFamily: 'Amaranth',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // To Section
                  _buildDetailRow(label: 'To', value1: widget.receiver.name, value2: widget.receiver.walletNumber),
                  const SizedBox(height: 24),

                  // From Section
                  _buildDetailRow(label: 'From', value1: 'Your Wallet'),
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
                        onPressed: _isProcessing ? null : () => _handleReject(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: _isProcessing
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text(
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
                        onPressed: _isProcessing ? null : () => _handleApprove(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1F70),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyMemberHelpScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF1F70),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
