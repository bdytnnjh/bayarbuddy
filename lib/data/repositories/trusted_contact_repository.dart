import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/configs/firebase_query.dart';
import '../models/trusted_contact_model.dart';

class TrustedContactRepository {
  final String _collection = 'trusted_contacts';

  // Create - Add new trusted contact
  Future<String> createTrustedContact({
    required String userId,
    required String name,
    required String phoneNumber,
    required String email,
    required String relationship,
    String? linkedUserId,
  }) async {
    final docRef = await FirebaseQuery.createDocument(
      collection: _collection,
      data: {
        'userId': userId,
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'relationship': relationship,
        'isActive': true,
        'linkedUserId': linkedUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
    return docRef.id;
  }

  // Read - Get trusted contact by ID
  Future<TrustedContactModel?> getTrustedContact(String contactId) async {
    final doc = await FirebaseQuery.getDocument(
      collection: _collection,
      docId: contactId,
    );

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return TrustedContactModel.fromSnapshot(doc);
  }

  // Read - Get all trusted contacts by user ID
  Future<List<TrustedContactModel>> getTrustedContactsByUserId(
    String userId,
  ) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true),
    );

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => TrustedContactModel.fromSnapshot(doc))
        .toList();
  }

  // Read - Get all trusted contacts (including inactive)
  Future<List<TrustedContactModel>> getAllTrustedContactsByUserId(
    String userId,
  ) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true),
    );

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => TrustedContactModel.fromSnapshot(doc))
        .toList();
  }

  // Read - Search trusted contacts by name
  Future<List<TrustedContactModel>> searchTrustedContactsByName({
    required String userId,
    required String searchQuery,
  }) async {
    final snapshot = await FirebaseQuery.getDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('name'),
    );

    if (snapshot.docs.isEmpty) {
      return [];
    }

    // Filter locally by search query (Firestore doesn't support case-insensitive search)
    final contacts = snapshot.docs
        .map((doc) => TrustedContactModel.fromSnapshot(doc))
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return contacts;
  }

  // Update - Update trusted contact
  Future<void> updateTrustedContact({
    required String contactId,
    String? name,
    String? phoneNumber,
    String? email,
    String? relationship,
    bool? isActive,
    String? linkedUserId,
  }) async {
    Map<String, dynamic> data = {'updatedAt': FieldValue.serverTimestamp()};

    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (email != null) data['email'] = email;
    if (relationship != null) data['relationship'] = relationship;
    if (isActive != null) data['isActive'] = isActive;
    if (linkedUserId != null) data['linkedUserId'] = linkedUserId;

    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: contactId,
      data: data,
    );
  }

  // Update - Deactivate trusted contact (soft delete)
  Future<void> deactivateTrustedContact(String contactId) async {
    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: contactId,
      data: {'isActive': false, 'updatedAt': FieldValue.serverTimestamp()},
    );
  }

  // Update - Reactivate trusted contact
  Future<void> reactivateTrustedContact(String contactId) async {
    await FirebaseQuery.updateDocument(
      collection: _collection,
      docId: contactId,
      data: {'isActive': true, 'updatedAt': FieldValue.serverTimestamp()},
    );
  }

  // Delete - Permanently delete trusted contact
  Future<void> deleteTrustedContact(String contactId) async {
    await FirebaseQuery.deleteDocument(
      collection: _collection,
      docId: contactId,
    );
  }

  // Stream - Real-time updates for a specific trusted contact
  Stream<DocumentSnapshot<Map<String, dynamic>>> trustedContactStream(
    String contactId,
  ) {
    return FirebaseQuery.streamDocument(
      collection: _collection,
      docId: contactId,
    );
  }

  // Stream - Real-time updates for user's trusted contacts
  Stream<QuerySnapshot<Map<String, dynamic>>> trustedContactsStream(
    String userId,
  ) {
    return FirebaseQuery.streamDocuments(
      collection: _collection,
      queryBuilder: (collection) => collection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true),
    );
  }
}
