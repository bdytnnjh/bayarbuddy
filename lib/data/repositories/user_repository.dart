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
}
