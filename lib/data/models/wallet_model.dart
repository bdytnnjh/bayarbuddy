import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final bool isPrimary;
  final String userId;
  final String walletNummer;
  final double balance;
  final String currency;
  final DateTime lastUpdated;

  WalletModel({
    required this.isPrimary,
    required this.userId,
    required this.walletNummer,
    required this.balance,
    required this.currency,
    required this.lastUpdated,
  });

  // Convert WalletModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'isPrimary': isPrimary,
      'userId': userId,
      'walletNummer': walletNummer,
      'balance': balance,
      'currency': currency,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // Create WalletModel from Firestore document
  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      isPrimary: map['isPrimary'] ?? false,
      userId: map['userId'] ?? '',
      walletNummer: map['walletNummer'] ?? '',
      balance: (map['balance'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'MYR',
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create WalletModel from DocumentSnapshot
  factory WalletModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return WalletModel.fromMap({...data});
  }

  // Copy with method for updating fields
  WalletModel copyWith({
    bool? isPrimary,
    String? userId,
    String? walletNummer,
    double? balance,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      isPrimary: isPrimary ?? this.isPrimary,
      userId: userId ?? this.userId,
      walletNummer: walletNummer ?? this.walletNummer,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'WalletModel(isPrimary: $isPrimary, userId: $userId, walletNummer: $walletNummer, balance: $balance, currency: $currency)';
  }
}
