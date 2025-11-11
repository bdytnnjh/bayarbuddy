import 'package:app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

class FamilyMemberHelpScreen extends StatefulWidget {
  const FamilyMemberHelpScreen({super.key});

  @override
  State<FamilyMemberHelpScreen> createState() => _FamilyMemberHelpScreenState();
}

class _FamilyMemberHelpScreenState extends State<FamilyMemberHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.bgPink.withValues(alpha: 0.4),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Title Section
              Text(
                'Baba needs helps!',
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
                'RM 700.00',
                style: TextStyle(
                  color: AppTheme.colors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
              const SizedBox(height: 40),
              // Transaction Details
              _buildTransactionDetail('To', 'TOM HAALAND\n1233 3566 2352'),
              const SizedBox(height: 24),
              _buildTransactionDetail('From', 'TOM HAALAND'),
              const SizedBox(height: 24),
              _buildTransactionDetail('Transaction type', 'Transfer'),
              const SizedBox(height: 24),
              _buildTransactionDetail('Date & time', '23 May 2025, 12:03AM'),
              const SizedBox(height: 80),
              // Buttons Section
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle reject
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.colors.textPrimary,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
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
                      onPressed: () {
                        // Handle approve
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
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
            color: AppTheme.colors.grey,
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