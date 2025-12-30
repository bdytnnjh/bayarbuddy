import 'package:app/core/utils/app_util.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/data/models/receiver_model.dart';
import 'package:app/data/repositories/notification_repository.dart';
import 'package:app/data/repositories/scam_trigger_histories_repository.dart';
import 'package:app/data/repositories/trusted_contact_repository.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/presentation/screens/main/transfer/providers/confirm_transfer_provider.dart';
import 'package:app/presentation/screens/main/transfer/providers/transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'status_transfer_screen.dart';

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
  bool _isSendingHelp = false;

  final NotificationRepository _notificationRepo = NotificationRepository();
  final TrustedContactRepository _trustedContactRepo =
      TrustedContactRepository();
  final UserRepository _userRepo = UserRepository();
  final ScamTriggerHistoriesRepository _scamRepo =
      ScamTriggerHistoriesRepository();

  /// Handle "Help Me!" button - Send distress notification to all trusted contacts
  Future<void> _handleHelpMe() async {
    if (_isSendingHelp) return;

    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Send Help Request?',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will send an urgent notification to all your trusted contacts about this transaction. Continue?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF1F70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Oval shape
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ), // Smaller size
            ),
            child: const Text(
              'Send Help Request',
              style: TextStyle(
                color: Colors.white, // White text color
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSendingHelp = true);

    try {
      // Get current user ID
      final userUid = await AppUtil.getCurrentUserId();
      if (userUid == null) {
        throw Exception('User not logged in');
      }

      // Create scam trigger history for manual help request
      final scamTriggerId = await _scamRepo.createScamTrigger(
        userId: userUid,
        transferId: 'transfer_${DateTime.now().millisecondsSinceEpoch}',
        recipientName: widget.receiver.name,
        recipientWalletNumber:
            widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
        amount: double.tryParse(widget.amount) ?? 0.0,
        triggerType: 'help_me',
        approveAttempts: 0, // Manual help, no approve attempts
      );

      debugPrint('Help Me trigger history created: $scamTriggerId');

      // Get current user data
      final userData = await _userRepo.getUserByUid(uid: userUid);
      final userName =
          userData?['fullName'] ?? userData?['username'] ?? 'Someone';

      // Get all trusted contacts for this user
      final trustedContacts = await _trustedContactRepo
          .getTrustedContactsByUserId(userUid);

      if (trustedContacts.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No trusted contacts found. Please add trusted contacts first.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isSendingHelp = false);
        return;
      }

      // Send notifications to all trusted contacts who have linkedUserId
      int successCount = 0;
      // ignore: unused_local_variable
      int failCount = 0;

      // Prepare notification data payload
      final notificationData = {
        'type': 'help_request',
        'amount': widget.amount,
        'recipientName': widget.receiver.name,
        'recipientPhone':
            widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
        'senderName': userName,
        'senderUid': userUid,
        'scamTriggerId': scamTriggerId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      for (final contact in trustedContacts) {
        if (contact.linkedUserId != null && contact.linkedUserId!.isNotEmpty) {
          try {
            await _notificationRepo.sendNotificationWithData(
              userId: contact.linkedUserId!,
              title: '🚨 URGENT: ${userName.toUpperCase()} NEEDS HELP!',
              body:
                  'Help request for transfer of RM ${widget.amount} to ${widget.receiver.name}. Tap to view details.',
              data: notificationData,
            );
            successCount++;
          } catch (e) {
            debugPrint('Failed to send notification to ${contact.name}: $e');
            failCount++;
          }
        } else {
          debugPrint('Skipping ${contact.name} - no linked user ID');
          failCount++;
        }
      }

      setState(() => _isSendingHelp = false);

      if (!mounted) return;

      // Show result
      if (successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Help request sent to $successCount trusted contact(s)!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send help requests. Please ensure your trusted contacts are linked.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in _handleHelpMe: $e');

      setState(() => _isSendingHelp = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleApprove(BuildContext context) async {
    if (_isProcessing) return;

    final provider = Provider.of<ConfirmTransferProvider>(
      context,
      listen: false,
    );

    // If still in waiting period, count as suspicious attempt
    if (provider.isWaitingPeriod) {
      await provider.handleApproveAttempt(
        recipientName: widget.receiver.name,
        recipientWalletNumber:
            widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
        amount: double.tryParse(widget.amount) ?? 0.0,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please wait ${provider.remainingSeconds} seconds before approving',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // If scam detected, prevent approval
    if (provider.isScamDetected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Transaction locked. Waiting for trusted contact verification.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final transferProvider = Provider.of<TransferProvider>(
        context,
        listen: false,
      );

      // Get current user UID
      final userUid = await AppUtil.getCurrentUserId();
      if (userUid == null) {
        throw Exception('User not logged in');
      }

      // Get sender wallet ID
      final walletId = await transferProvider.getSenderWalletId(userUid);
      if (walletId == null) {
        throw Exception('Wallet not found');
      }

      // Approve transfer (updates balances)
      final approveResult = await transferProvider.approveTransfer(
        senderWalletId: walletId,
      );

      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      // Navigate to status screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatusTransferScreen(
            amount: widget.amount,
            recipientName: widget.receiver.name,
            recipientPhone:
                widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
            senderName: 'You',
            isSuccessful: approveResult['success'],
          ),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      // Navigate to failed status
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatusTransferScreen(
            amount: widget.amount,
            recipientName: widget.receiver.name,
            recipientPhone:
                widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
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
      final transferProvider = Provider.of<TransferProvider>(
        context,
        listen: false,
      );

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
            recipientPhone:
                widget.receiver.phoneNumber ?? widget.receiver.walletNumber,
            senderName: 'You',
            isSuccessful: false,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back behavior
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final transferProvider = Provider.of<TransferProvider>(
            context,
            listen: false,
          );
          transferProvider.rejectTransfer();
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false);
          // Handle back manually
        }
      },
      child: ChangeNotifierProvider(
        create: (_) => ConfirmTransferProvider()..startWaitingPeriod(),
        child: Consumer<ConfirmTransferProvider>(
          builder: (context, confirmProvider, _) {
            return Scaffold(
              backgroundColor: const Color(0xFFFFE5F0),
              appBar: AppBarGlobal(
                title: 'Confirm Transfer',
                onBackPressed: () {
                  final transferProvider = Provider.of<TransferProvider>(
                    context,
                    listen: false,
                  );
                  transferProvider.rejectTransfer();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/home', (route) => false);
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Waiting period or scam alert banner
                          if (confirmProvider.isWaitingPeriod)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Security wait period: ${confirmProvider.remainingSeconds}s remaining',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (confirmProvider.isScamDetected)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text(
                                          '⚠️ SCAM ALERT',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Suspicious activity detected! Help request sent to your trusted contacts.',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Colors.red.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Secure authorisation label
                          Text(
                            'Secure authorisation',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFFB8697E),
                              letterSpacing: 0.5,
                            ),
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
                          _buildDetailRow(
                            label: 'To',
                            value1: widget.receiver.name,
                            value2: widget.receiver.walletNumber,
                          ),
                          const SizedBox(height: 24),

                          // From Section
                          _buildDetailRow(label: 'From', value1: 'Your Wallet'),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      children: [
                        // Reject and Approve buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    (_isProcessing ||
                                        !confirmProvider.canReject)
                                    ? null
                                    : () => _handleReject(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
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
                                onPressed: (_isProcessing)
                                    ? null
                                    : !confirmProvider.canApprove
                                    ? () async {
                                        await confirmProvider
                                            .handleApproveAttempt(
                                              recipientName:
                                                  widget.receiver.name,
                                              recipientWalletNumber:
                                                  widget.receiver.phoneNumber ??
                                                  widget.receiver.walletNumber,
                                              amount:
                                                  double.tryParse(
                                                    widget.amount,
                                                  ) ??
                                                  0.0,
                                            );

                                        // Show UI feedback when scam detected
                                        // Provider already handles notification & history in _triggerScamDetection()
                                        if (confirmProvider.isScamDetected &&
                                            context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Emergency alert sent to your trusted contacts',
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      }
                                    : () => _handleApprove(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF1F70),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        confirmProvider.isWaitingPeriod
                                            ? 'Wait ${confirmProvider.remainingSeconds}s'
                                            : confirmProvider.isScamDetected
                                            ? 'Locked'
                                            : 'Approve',
                                        style: const TextStyle(
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
                            onPressed:
                                (_isProcessing ||
                                    _isSendingHelp ||
                                    confirmProvider.isScamDetected)
                                ? null
                                : _handleHelpMe,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF1F70),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: _isSendingHelp
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
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
          },
        ),
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
            ],
          ],
        ),
      ],
    );
  }
}
