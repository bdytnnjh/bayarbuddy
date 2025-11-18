import 'package:app/core/themes/app_theme.dart';
import 'package:app/core/widgets/customs/app_bar_global.dart';
import 'package:app/data/models/trusted_contact_model.dart';
import 'package:app/presentation/screens/trusted_contact/add_contact_screen.dart';
import 'package:app/presentation/screens/trusted_contact/edit_contact_screen.dart';
import 'package:app/presentation/screens/trusted_contact/providers/trusted_contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrustedContactScreen extends StatefulWidget {
  const TrustedContactScreen({super.key});

  @override
  State<TrustedContactScreen> createState() => _TrustedContactScreenState();
}

class _TrustedContactScreenState extends State<TrustedContactScreen> {
  final TrustedContactProvider _provider = TrustedContactProvider();

  @override
  void initState() {
    super.initState();
    _provider.loadContacts();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _navigateToAddContact() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddContactScreen()));

    if (result == true && mounted) {
      // Refresh the list after adding
      await _provider.refreshContacts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact added successfully')));
      }
    }
  }

  void _navigateToEditContact(TrustedContactModel contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: _provider,
          child: EditContactScreen(contact: contact),
        ),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact updated successfully')));
    }
  }

  void _handleDeleteContact(TrustedContactModel contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _provider.deleteContact(contact.contactId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact deleted successfully')));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${_provider.error ?? "Failed to delete contact"}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: const AppBarGlobal(title: 'Trusted Contact'),
        backgroundColor: Colors.white,
        body: Consumer<TrustedContactProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null && provider.contacts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading contacts',
                        style: TextStyle(color: Colors.red, fontFamily: AppTheme.typography.primary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => provider.refreshContacts(), child: const Text('Retry')),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshContacts(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Trusted Contact List',
                        style: TextStyle(
                          color: AppTheme.colors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.typography.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (provider.contacts.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'No trusted contacts yet',
                              style: TextStyle(color: Colors.grey[600], fontFamily: AppTheme.typography.primary),
                            ),
                          ),
                        )
                      else
                        ..._buildContactsList(provider.contacts),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToAddContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: Text(
                'Add New Contact',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.typography.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContactsList(List<TrustedContactModel> contacts) {
    return contacts.map((contact) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: TextStyle(
                        color: AppTheme.colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.typography.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.relationship,
                      style: TextStyle(
                        color: AppTheme.colors.grey,
                        fontSize: 12,
                        fontFamily: AppTheme.typography.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: AppTheme.colors.primary, size: 20),
                    onPressed: () => _navigateToEditContact(contact),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppTheme.colors.red, size: 20),
                    onPressed: () => _handleDeleteContact(contact),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
