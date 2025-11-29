import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/configs/firebase_query.dart';
import '../models/transfer_history_model.dart';
import 'wallet_repository.dart';

class TransferRepository {
  final String _collection = 'transfer_histories';
  final WalletRepository _walletRepository = WalletRepository();

  /// Execute transfer - Update sender and receiver balance, create history
  Future<Map<String, dynamic>> executeTransfer({
    required String senderUid,
    required String senderName,
    required String senderWalletId,
    required String recipientWalletNumber,
    required String recipientName,
    required double amount,
    required String description,
    bool isDistressSignal = false,
  }) async {
    try {
      // 1. Get sender wallet
      final senderWallet = await _walletRepository.getWallet(senderWalletId);
      if (senderWallet == null) {
        return {'success': false, 'message': 'Sender wallet not found'};
      }

      // 2. Check sender balance
      if (senderWallet.balance < amount) {
        return {'success': false, 'message': 'Insufficient balance'};
      }

      // 3. Get recipient wallet
      final recipientWallet = await _walletRepository.searchWalletByNumber(recipientWalletNumber);
      if (recipientWallet == null) {
        return {'success': false, 'message': 'Recipient wallet not found'};
      }

      // 4. Create pending transfer history
      final historyRef = await FirebaseQuery.createDocument(
        collection: _collection,
        data: {
          'senderUid': senderUid,
          'senderName': senderName,
          'recipientAcc': recipientWalletNumber,
          'recipientName': recipientName,
          'amount': amount,
          'description': description,
          'status': TransferStatus.pendingApproval,
          'isDistressSignal': isDistressSignal,
          'createdAt': FieldValue.serverTimestamp(),
          'completedAt': null,
        },
      );

      return {
        'success': true,
        'message': 'Transfer pending approval',
        'historyId': historyRef.id,
        'senderBalance': senderWallet.balance,
        'recipientBalance': recipientWallet.balance,
      };
    } catch (e) {
      dev.log('Error executing transfer: $e');
      return {'success': false, 'message': 'Transfer failed: ${e.toString()}'};
    }
  }

  /// Approve transfer - Actually update balances and mark as SUCCESS
  Future<Map<String, dynamic>> approveTransfer({
    required String historyId,
    required String senderWalletId,
    required String recipientWalletNumber,
    required double amount,
  }) async {
    try {
      // 1. Get sender wallet
      final senderWallet = await _walletRepository.getWallet(senderWalletId);
      if (senderWallet == null) {
        throw Exception('Sender wallet not found');
      }

      // 2. Check sender balance again
      if (senderWallet.balance < amount) {
        // Update history to FAILED
        await updateTransferStatus(historyId, TransferStatus.failed);
        return {'success': false, 'message': 'Insufficient balance'};
      }

      // 3. Get recipient wallet
      final recipientWallet = await _walletRepository.searchWalletByNumber(recipientWalletNumber);
      if (recipientWallet == null) {
        // Update history to FAILED
        await updateTransferStatus(historyId, TransferStatus.failed);
        return {'success': false, 'message': 'Recipient wallet not found'};
      }

      // 4. Update balances using Firestore transaction for atomicity
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Deduct from sender
        final newSenderBalance = senderWallet.balance - amount;
        transaction.update(FirebaseFirestore.instance.collection('wallets').doc(senderWallet.id), {
          'balance': newSenderBalance,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // Add to recipient
        final newRecipientBalance = recipientWallet.balance + amount;
        transaction.update(FirebaseFirestore.instance.collection('wallets').doc(recipientWallet.id), {
          'balance': newRecipientBalance,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // Update transfer history to SUCCESS
        transaction.update(FirebaseFirestore.instance.collection(_collection).doc(historyId), {
          'status': TransferStatus.success,
          'completedAt': FieldValue.serverTimestamp(),
        });
      });

      return {
        'success': true,
        'message': 'Transfer successful',
        'newSenderBalance': senderWallet.balance - amount,
        'newRecipientBalance': recipientWallet.balance + amount,
      };
    } catch (e) {
      dev.log('Error approving transfer: $e');
      // Update history to FAILED
      await updateTransferStatus(historyId, TransferStatus.failed);
      return {'success': false, 'message': 'Transfer failed: ${e.toString()}'};
    }
  }

  /// Reject transfer - Mark as REJECTED
  Future<void> rejectTransfer(String historyId) async {
    await updateTransferStatus(historyId, TransferStatus.rejected);
  }

  /// Update transfer status
  Future<void> updateTransferStatus(String historyId, String status) async {
    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: historyId,
      data: {'status': status, 'completedAt': FieldValue.serverTimestamp()},
    );
  }

  /// Get transfer history by ID
  Future<TransferHistoryModel?> getTransferHistory(String historyId) async {
    final doc = await FirebaseQuery.getDocument(collection: _collection, docId: historyId);

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return TransferHistoryModel.fromSnapshot(doc);
  }

  /// Get all transfer histories for a user (as sender)
  Future<List<TransferHistoryModel>> getUserTransferHistories(String userId) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) =>
          collection.where('senderUid', isEqualTo: userId).orderBy('createdAt', descending: true),
    );

    return snapshot.docs.map((doc) => TransferHistoryModel.fromSnapshot(doc)).toList();
  }

  /// Get pending transfers for a user
  Future<List<TransferHistoryModel>> getPendingTransfers(String userId) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('senderUid', isEqualTo: userId)
          .where('status', isEqualTo: TransferStatus.pendingApproval)
          .orderBy('createdAt', descending: true),
    );

    return snapshot.docs.map((doc) => TransferHistoryModel.fromSnapshot(doc)).toList();
  }

  /// Stream transfer histories for real-time updates
  Stream<List<TransferHistoryModel>> streamUserTransferHistories(String userId) {
    return FirebaseFirestore.instance
        .collection(_collection)
        .where('senderUid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TransferHistoryModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// Get incoming transfers (where user is the recipient)
  Future<List<TransferHistoryModel>> getIncomingTransfers(String walletNumber) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('recipientAcc', isEqualTo: walletNumber)
          .where('status', isEqualTo: TransferStatus.success)
          .orderBy('createdAt', descending: true)
          .limit(10),
    );

    return snapshot.docs.map((doc) => TransferHistoryModel.fromSnapshot(doc)).toList();
  }

  /// Get outgoing transfers (where user is the sender)
  Future<List<TransferHistoryModel>> getOutgoingTransfers(String userId) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('senderUid', isEqualTo: userId)
          .where('status', isEqualTo: TransferStatus.success)
          .orderBy('createdAt', descending: true)
          .limit(10),
    );

    return snapshot.docs.map((doc) => TransferHistoryModel.fromSnapshot(doc)).toList();
  }
}
