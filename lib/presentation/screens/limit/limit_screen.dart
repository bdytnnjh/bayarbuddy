import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/presentation/screens/limit/providers/limit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LimitTransactionScreen extends StatelessWidget {
  const LimitTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LimitProvider>(
      create: (_) => LimitProvider()..initializeLimit(),
      child: Scaffold(
        appBar: AppBarGlobal(title: 'Limit Transaction'),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Consumer<LimitProvider>(
              builder: (context, limitProvider, child) {
                if (limitProvider.isLoading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 400,
                    width: double.infinity,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error Message
                    if (limitProvider.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(limitProvider.errorMessage!, style: TextStyle(color: Colors.red.shade700)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => limitProvider.clearError(),
                              color: Colors.red.shade700,
                            ),
                          ],
                        ),
                      ),
                    // Title and Description
                    Text(
                      limitProvider.isEditing ? 'Transfer Limit Successfully Updated' : 'Limit Transaction',
                      style: TextStyle(color: AppTheme.colors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      limitProvider.isEditing
                          ? 'Your custom limit and emergency trigger settings have been saved.'
                          : 'Drag the slider to set the minimum transaction amount that will trigger the Help button or require third-party verification',
                      style: TextStyle(color: AppTheme.colors.grey, fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    // Limit Amount Display
                    Center(
                      child: Column(
                        children: [
                          Text('Limit Transactions:', style: TextStyle(color: AppTheme.colors.grey, fontSize: 14)),
                          const SizedBox(height: 8),
                          Text(
                            'RM ${limitProvider.transactionLimit.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: AppTheme.colors.textPrimary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Slider
                    if (!limitProvider.isEditing)
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 8.0,
                              activeTrackColor: AppTheme.colors.primary,
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: AppTheme.colors.primary,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                            ),
                            child: Slider(
                              value: limitProvider.transactionLimit,
                              min: limitProvider.minLimit,
                              max: limitProvider.maxLimit,
                              onChanged: (value) {
                                limitProvider.setTransactionLimit(value);
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RM ${limitProvider.minLimit.toStringAsFixed(0)}',
                                style: TextStyle(color: AppTheme.colors.grey, fontSize: 12),
                              ),
                              Text(
                                'RM ${limitProvider.maxLimit.toStringAsFixed(0)}',
                                style: TextStyle(color: AppTheme.colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 60),
                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.bgPink.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'If a transaction exceeds your emergency threshold, your trusted contact will be alerted for verification.',
                        style: TextStyle(color: AppTheme.colors.grey, fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Buttons
                    if (!limitProvider.isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: limitProvider.isLoading
                              ? null
                              : () async {
                                  await limitProvider.updateLimit();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: limitProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                limitProvider.setIsEditing(false);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppTheme.colors.primary),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  color: AppTheme.colors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.colors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                              child: Text(
                                'Done',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 30),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('assets/imgs/icn_home.png', false),
          _buildNavItem('assets/imgs/icn_wallet.png', false),
          _buildNavItem('assets/imgs/icn_chart.png', false),
          _buildNavItem('assets/imgs/icn_user.png', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(dynamic icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF1F70) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon is String
          ? Image.asset(icon, width: 28, height: 28, color: isActive ? Colors.white : const Color(0xFFB0B0B0))
          : Icon(icon, color: isActive ? Colors.white : const Color(0xFFB0B0B0), size: 28),
    );
  }
}
