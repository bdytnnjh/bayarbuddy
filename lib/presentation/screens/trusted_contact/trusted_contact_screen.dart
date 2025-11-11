import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:flutter/material.dart';

class TrustedContactScreen extends StatefulWidget {
  const TrustedContactScreen({super.key});

  @override
  State<TrustedContactScreen> createState() => _TrustedContactScreenState();
}

class _TrustedContactScreenState extends State<TrustedContactScreen> {
  List<Map<String, String>> trustedContacts = [
    {'name': 'John Lewis', 'relationship': 'Son'},
    {'name': 'Amanda Zahra', 'relationship': 'Wife'},
  ];

  bool _isViewMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGlobal(title: _isViewMode ? 'Trusted Contact' : 'Edit Trusted Contact'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Personal Information Section (only in add/edit mode)
              if (!_isViewMode)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Personal Information'),
                    const SizedBox(height: 16),
                    _buildInputField('Username', 'John Leil'),
                    _buildInputField('Email', 'john.monopseed@apple.com'),
                    _buildInputField('Mobile Phone', '+6209329382232'),
                    _buildInputField('Relationship', 'Son'),
                    const SizedBox(height: 60),
                  ],
                ),
              // Trusted Contact List Section
              _buildSectionTitle(_isViewMode ? 'Trusted Contact List' : 'Trusted Contact List'),
              const SizedBox(height: 16),
              ..._buildContactsList(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: _buildButtonsSection(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.colors.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: AppTheme.typography.primary,
      ),
    );
  }

  Widget _buildInputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppTheme.colors.primary,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.colors.primary),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContactsList() {
    return trustedContacts.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, String> contact = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['name']!,
                    style: TextStyle(
                      color: AppTheme.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.typography.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact['relationship']!,
                    style: TextStyle(
                      color: AppTheme.colors.grey,
                      fontSize: 12,
                      fontFamily: AppTheme.typography.primary,
                    ),
                  ),
                ],
              ),
              if (_isViewMode)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.colors.primary,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isViewMode = false);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppTheme.colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => trustedContacts.removeAt(index));
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildButtonsSection() {
    if (_isViewMode) {
      // View mode - Show Add button
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            setState(() => _isViewMode = false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.colors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.typography.primary,
            ),
          ),
        ),
      );
    } else {
      // Edit mode - Show Edit and Add buttons
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() => _isViewMode = true);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.colors.primary,
                  width: 2,
                ),
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
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle add new contact
                setState(() => _isViewMode = true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Add',
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
      );
    }
  }
}