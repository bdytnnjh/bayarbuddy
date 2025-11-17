import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseQuery {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// GET - Mengambil satu dokumen berdasarkan docId
  static Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      rethrow;
    }
  }

  /// GET - Mengambil semua dokumen dalam collection
  static Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
  }) async {
    try {
      return await _firestore.collection(collection).get();
    } catch (e) {
      rethrow;
    }
  }

  /// GET - Mengambil multiple dokumen dengan query (optional)
  static Future<QuerySnapshot<Map<String, dynamic>>> getDocuments({
    required String collection,
    Query<Map<String, dynamic>>? Function(
      CollectionReference<Map<String, dynamic>>,
    )?
    queryBuilder,
  }) async {
    try {
      CollectionReference<Map<String, dynamic>> collectionRef = _firestore
          .collection(collection);

      if (queryBuilder != null) {
        final query = queryBuilder(collectionRef);
        if (query != null) {
          return await query.get();
        }
      }

      return await collectionRef.get();
    } catch (e) {
      rethrow;
    }
  }

  /// STREAM - Stream satu dokumen berdasarkan docId
  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collection,
    required String docId,
  }) {
    try {
      return _firestore.collection(collection).doc(docId).snapshots();
    } catch (e) {
      rethrow;
    }
  }

  /// STREAM - Stream semua dokumen dalam collection
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collection,
  }) {
    try {
      return _firestore.collection(collection).snapshots();
    } catch (e) {
      rethrow;
    }
  }

  /// STREAM - Stream multiple dokumen dengan query (optional)
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamDocuments({
    required String collection,
    Query<Map<String, dynamic>>? Function(
      CollectionReference<Map<String, dynamic>>,
    )?
    queryBuilder,
  }) {
    try {
      CollectionReference<Map<String, dynamic>> collectionRef = _firestore
          .collection(collection);

      if (queryBuilder != null) {
        final query = queryBuilder(collectionRef);
        if (query != null) {
          return query.snapshots();
        }
      }

      return collectionRef.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  /// CREATE/ADD - Membuat dokumen baru dengan auto-generated ID
  static Future<DocumentReference<Map<String, dynamic>>> createDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      rethrow;
    }
  }

  /// CREATE/ADD - Membuat atau set dokumen dengan docId spesifik
  static Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: merge));
    } catch (e) {
      rethrow;
    }
  }

  /// UPDATE - Update dokumen berdasarkan docId
  static Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE - Hapus dokumen berdasarkan docId
  static Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
