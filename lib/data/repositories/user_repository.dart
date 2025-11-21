import 'package:app/core/configs/firebase_query.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  static const String _usersCollection = 'users';

  Future<bool> checkUserExistsByEmail(String email) async {
    try {
      final usersSnapshot = await FirebaseQuery.getDocuments(
        collection: _usersCollection,
        queryBuilder: (collection) =>
            collection.where('email', isEqualTo: email).limit(1),
      );

      return usersSnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Check User Exists Error: $e');
      rethrow;
    }
  }

  Future<double> getUserLimitTransaction({required String uid}) async {
    try {
      final userDoc = await FirebaseQuery.getDocument(
        collection: _usersCollection,
        docId: uid,
      );

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data.containsKey('limitTransaction')) {
          return (data['limitTransaction'] as num).toDouble();
        }
      }
      return 0.0; // Default value if not found
    } catch (e) {
      debugPrint('Get User Limit Transaction Error: $e');
      rethrow;
    }
  }

  Future<bool> updateUserLimitTransaction({
    required String uid,
    required double newLimit,
  }) async {
    try {
      await FirebaseQuery.updateDocument(
        collection: _usersCollection,
        docId: uid,
        data: {'limitTransaction': newLimit},
      );
      return true;
    } catch (e) {
      debugPrint('Update User Limit Transaction Error: $e');
      return false;
    }
  }
}
