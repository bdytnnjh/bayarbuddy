import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:flutter/material.dart';

class LimitTransactionScreen extends StatefulWidget {
  const LimitTransactionScreen({super.key});

  @override
  State<LimitTransactionScreen> createState() => _LimitTransactionScreenState();
}

class _LimitTransactionScreenState extends State<LimitTransactionScreen> {
  double _transactionLimit = 800;
  bool _isEditing = false;
  final double _minLimit = 0;
  final double _maxLimit = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: 'Limit Transaction'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Description
              Text(
                _isEditing ? 'Transfer Limit Successfully Updated' : 'Limit Transaction',
                style: TextStyle(
                  color: AppTheme.colors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isEditing
                    ? 'Your custom limit and emergency trigger settings have been saved.'
                    : 'Drag the slider to set the minimum transaction amount that will trigger the Help button or require third-party verification',
                style: TextStyle(
                  color: AppTheme.colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              // Limit Amount Display
              Center(
                child: Column(
                  children: [
                    Text(
                      'Limit Transactions:',
                      style: TextStyle(
                        color: AppTheme.colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'RM ${_transactionLimit.toStringAsFixed(0)}',
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
              if (!_isEditing)
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 8.0,
                        activeTrackColor: AppTheme.colors.primary,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: AppTheme.colors.primary,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                      ),
                      child: Slider(
                        value: _transactionLimit,
                        min: _minLimit,
                        max: _maxLimit,
                        onChanged: (value) {
                          setState(() {
                            _transactionLimit = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RM ${_minLimit.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppTheme.colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'RM ${_maxLimit.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppTheme.colors.grey,
                            fontSize: 12,
                          ),
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
                  style: TextStyle(
                    color: AppTheme.colors.grey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Buttons
              if (!_isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.colors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
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
                          // Handle done action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
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
        ? Image.asset(
            icon,
            width: 28,
            height: 28,
            color: isActive ? Colors.white : const Color(0xFFB0B0B0),
          )
        : Icon(
            icon,
            color: isActive ? Colors.white : const Color(0xFFB0B0B0),
            size: 28,
          ),
  );
}
}