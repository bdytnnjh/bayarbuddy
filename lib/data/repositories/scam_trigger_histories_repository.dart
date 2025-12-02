import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/configs/firebase_query.dart';
import '../models/scam_trigger_history_model.dart';

class ScamTriggerHistoriesRepository {
  final String _collection = 'scam_trigger_histories';

  /// Create new scam trigger history
  Future<String> createScamTrigger({
    required String userId,
    required String transferId,
    required String recipientName,
    required String recipientWalletNumber,
    required double amount,
    required String triggerType,
    required int approveAttempts,
  }) async {
    final docRef = await FirebaseQuery.createDocument(
      collection: _collection,
      data: {
        'userId': userId,
        'transferId': transferId,
        'recipientName': recipientName,
        'recipientWalletNumber': recipientWalletNumber,
        'amount': amount,
        'triggerType': triggerType,
        'approveAttempts': approveAttempts,
        'isResolved': false,
        'resolvedBy': null,
        'resolution': null,
        'triggeredAt': FieldValue.serverTimestamp(),
        'resolvedAt': null,
      },
    );
    return docRef.id;
  }

  /// Get scam trigger by ID
  Future<ScamTriggerHistoryModel?> getScamTrigger(String historyId) async {
    final doc = await FirebaseQuery.getDocument(collection: _collection, docId: historyId);

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return ScamTriggerHistoryModel.fromSnapshot(doc);
  }

  /// Get all scam triggers for a user
  Future<List<ScamTriggerHistoryModel>> getUserScamTriggers(String userId) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) =>
          collection.where('userId', isEqualTo: userId).orderBy('triggeredAt', descending: true),
    );

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => ScamTriggerHistoryModel.fromSnapshot(doc)).toList();
  }

  /// Get unresolved scam triggers for a user
  Future<List<ScamTriggerHistoryModel>> getUnresolvedScamTriggers(String userId) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('userId', isEqualTo: userId)
          .where('isResolved', isEqualTo: false)
          .orderBy('triggeredAt', descending: true),
    );

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => ScamTriggerHistoryModel.fromSnapshot(doc)).toList();
  }

  /// Resolve scam trigger
  Future<void> resolveScamTrigger({
    required String historyId,
    required String resolvedBy,
    required String resolution,
  }) async {
    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: historyId,
      data: {
        'isResolved': true,
        'resolvedBy': resolvedBy,
        'resolution': resolution,
        'resolvedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  /// Update approve attempts
  Future<void> updateApproveAttempts({required String historyId, required int attempts}) async {
    await FirebaseQuery.updateDocument(collection: _collection, docId: historyId, data: {'approveAttempts': attempts});
  }

  /// Delete scam trigger
  Future<void> deleteScamTrigger(String historyId) async {
    await FirebaseQuery.deleteDocument(collection: _collection, docId: historyId);
  }

  /// Stream scam triggers for a user
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserScamTriggers(String userId) {
    return FirebaseQuery.streamDocuments(
      collection: _collection,
      queryBuilder: (collection) =>
          collection.where('userId', isEqualTo: userId).orderBy('triggeredAt', descending: true),
    );
  }
}
