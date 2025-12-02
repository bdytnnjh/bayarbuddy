import 'package:app/core/themes/app_theme.dart';
import 'package:app/presentation/screens/main/transfer/status_transfer_screen.dart';
import 'package:flutter/material.dart';

class NotificationFullIntentScreen extends StatefulWidget {
  final String? amount;
  final String? recipientName;
  final String? recipientPhone;
  final String? senderName;
  final String? senderUid;
  final DateTime? timestamp;

  const NotificationFullIntentScreen({
    super.key,
    this.amount,
    this.recipientName,
    this.recipientPhone,
    this.senderName,
    this.senderUid,
    this.timestamp,
  });

  @override
  State<NotificationFullIntentScreen> createState() => _NotificationFullIntentScreenState();
}

class _NotificationFullIntentScreenState extends State<NotificationFullIntentScreen> {
  bool _isProcessing = false;

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '23 May 2025, 12:03AM';

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day $month $year, $hour:$minute$period';
  }

  Future<void> _handleAction({required bool isApprove}) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isProcessing = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StatusTransferScreen(
          amount: widget.amount ?? '700.00',
          recipientName: widget.recipientName ?? 'TOM HAALAND',
          recipientPhone: widget.recipientPhone ?? '1233 3566 2352',
          senderName: widget.senderName ?? 'TOM HAALAND',
          isSuccessful: isApprove,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayAmount = widget.amount ?? '700.00';
    final displaySenderName = widget.senderName ?? 'Baba';
    final displayRecipientName = widget.recipientName ?? 'TOM HAALAND';
    final displayRecipientPhone = widget.recipientPhone ?? '1233 3566 2352';
    final displayDateTime = _formatDateTime(widget.timestamp);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE5F0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Title Section
              Text(
                '$displaySenderName needs help!',
                style: TextStyle(
                  color: AppTheme.colors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 12),
              // Secure Authorization Label
              Text(
                'Secure authorisation',
                style: TextStyle(
                  color: AppTheme.colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 16),
              // Amount
              Text(
                'RM $displayAmount',
                style: TextStyle(
                  color: AppTheme.colors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 40),
              // Transaction Details
              _buildTransactionDetail('To', '$displayRecipientName\n$displayRecipientPhone'),
              const SizedBox(height: 24),
              _buildTransactionDetail('From', displaySenderName),
              const SizedBox(height: 24),
              _buildTransactionDetail('Transaction type', 'Transfer'),
              const SizedBox(height: 24),
              _buildTransactionDetail('Date & time', displayDateTime),
              const SizedBox(height: 80),
              // Buttons Section
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : () => _handleAction(isApprove: false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.colors.textPrimary, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        backgroundColor: Colors.white,
                      ),
                      child: _isProcessing
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(
                              'Reject',
                              style: TextStyle(
                                color: AppTheme.colors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.typography.primary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : () => _handleAction(isApprove: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
                          : Text(
                              'Approve',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.typography.primary,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF878787),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: AppTheme.typography.primary,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppTheme.colors.secondary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.typography.primary,
          ),
        ),
      ],
    );
  }
}
