import 'package:cloud_firestore/cloud_firestore.dart';

class TrustedContactModel {
  final String contactId;
  final String userId;
  final String name;
  final String phoneNumber;
  final String email;
  final String relationship;
  final bool isActive;
  final String? linkedUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrustedContactModel({
    required this.contactId,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.relationship,
    required this.isActive,
    this.linkedUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'contactId': contactId,
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'relationship': relationship,
      'isActive': isActive,
      'linkedUserId': linkedUserId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory TrustedContactModel.fromMap(Map<String, dynamic> map) {
    return TrustedContactModel(
      contactId: map['contactId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      relationship: map['relationship'] ?? '',
      isActive: map['isActive'] ?? true,
      linkedUserId: map['linkedUserId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory TrustedContactModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return TrustedContactModel.fromMap({...data, 'contactId': doc.id});
  }

  TrustedContactModel copyWith({
    String? contactId,
    String? userId,
    String? name,
    String? phoneNumber,
    String? email,
    String? relationship,
    bool? isActive,
    String? linkedUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrustedContactModel(
      contactId: contactId ?? this.contactId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      isActive: isActive ?? this.isActive,
      linkedUserId: linkedUserId ?? this.linkedUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TrustedContactModel(contactId: $contactId, userId: $userId, name: $name, phoneNumber: $phoneNumber, email: $email, relationship: $relationship, isActive: $isActive, linkedUserId: $linkedUserId)';
  }
}
