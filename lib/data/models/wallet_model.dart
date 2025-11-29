import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String id;
  final bool isPrimary;
  final String userId;
  final String walletNumber;
  final double balance;
  final String currency;
  final DateTime lastUpdated;

  WalletModel({
    required this.id,
    required this.isPrimary,
    required this.userId,
    required this.walletNumber,
    required this.balance,
    required this.currency,
    required this.lastUpdated,
  });

  // Convert WalletModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'isPrimary': isPrimary,
      'userId': userId,
      'walletNumber': walletNumber,
      'balance': balance,
      'currency': currency,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // Create WalletModel from Map for Firestore
  factory WalletModel.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return WalletModel(
      id: id,
      isPrimary: map['isPrimary'] ?? false,
      userId: map['userId'] ?? '',
      walletNumber: map['walletNumber'] ?? '',
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
    return WalletModel(
      id: doc.id,
      isPrimary: data['isPrimary'] ?? false,
      userId: data['userId'] ?? '',
      walletNumber: data['walletNumber'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'MYR',
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Copy with method for updating fields
  WalletModel copyWith({
    String? id,
    bool? isPrimary,
    String? userId,
    String? walletNumber,
    double? balance,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      id: id ?? this.id,
      isPrimary: isPrimary ?? this.isPrimary,
      userId: userId ?? this.userId,
      walletNumber: walletNumber ?? this.walletNumber,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'WalletModel(isPrimary: $isPrimary, userId: $userId, walletNumber: $walletNumber, balance: $balance, currency: $currency)';
  }
}
