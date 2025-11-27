import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/configs/firebase_query.dart';
import '../models/wallet_model.dart';

class WalletRepository {
  final String _collection = 'wallets';

  // Create
  Future<void> createWallet({
    required String userId,
    double balance = 0.0,
    String currency = 'MYR',
  }) async {
    // Generate random 12-digit wallet number
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final walletNumber = random.substring(random.length - 12);

    await FirebaseQuery.createDocument(
      collection: _collection,
      data: {
        'isPrimary': true,
        'userId': userId,
        'balance': balance,
        'currency': currency,
        'walletNumber': walletNumber,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
    );
  }

  // Read - Get wallet by ID
  Future<WalletModel?> getWallet(String walletId) async {
    final doc = await FirebaseQuery.getDocument(
      collection: _collection,
      docId: walletId,
    );

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return WalletModel.fromSnapshot(doc);
  }

  // Read - Get wallet by user ID
  Future<List<WalletModel>> getWalletByUserId(String userId) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) =>
          collection.where('userId', isEqualTo: userId),
    );

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => WalletModel.fromSnapshot(doc)).toList();
  }

  Future<WalletModel?> searchWalletByNumber(String walletNumber) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) =>
          collection.where('walletNumber', isEqualTo: walletNumber).limit(1),
    );

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return WalletModel.fromSnapshot(snapshot.docs.first);
  }

  // Update - Update balance
  Future<void> updateBalance({
    required String walletId,
    required double newBalance,
  }) async {
    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: walletId,
      data: {
        'balance': newBalance,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
    );
  }

  // Update - Full update
  Future<void> updateWallet({
    required String walletId,
    String? userId,
    double? balance,
    String? currency,
  }) async {
    Map<String, dynamic> data = {'lastUpdated': FieldValue.serverTimestamp()};

    if (userId != null) data['userId'] = userId;
    if (balance != null) data['balance'] = balance;
    if (currency != null) data['currency'] = currency;

    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: walletId,
      data: data,
    );
  }

  // Delete
  Future<void> deleteWallet(String walletId) async {
    await FirebaseQuery.deleteDocument(
      collection: _collection,
      docId: walletId,
    );
  }

  // Stream - Real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> walletStream(String walletId) {
    return FirebaseQuery.streamDocument(
      collection: _collection,
      docId: walletId,
    );
  }
}
