import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String fullName;
  final String phoneNumber;
  final String? photoUrl;
  final double limitTransaction;
  final String? hashedPin;
  final String status; // 'active', 'blocked', 'inactive'
  final String? tokenDevice;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.fullName,
    required this.phoneNumber,
    this.photoUrl,
    required this.limitTransaction,
    this.hashedPin,
    this.status = 'active',
    this.tokenDevice,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'limitTransaction': limitTransaction,
      'hashedPin': hashedPin,
      'status': status,
      'tokenDevice': tokenDevice,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'],
      limitTransaction: (map['limitTransaction'] ?? 0).toDouble(),
      hashedPin: map['hashedPin'],
      status: map['status'] ?? 'active',
      tokenDevice: map['tokenDevice'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create UserModel from DocumentSnapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return UserModel.fromMap(data);
  }

  // Copy with method for updating fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? fullName,
    String? phoneNumber,
    String? photoUrl,
    double? limitTransaction,
    String? hashedPin,
    String? status,
    String? tokenDevice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      limitTransaction: limitTransaction ?? this.limitTransaction,
      hashedPin: hashedPin ?? this.hashedPin,
      status: status ?? this.status,
      tokenDevice: tokenDevice ?? this.tokenDevice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, username: $username, fullName: $fullName, phoneNumber: $phoneNumber, limitTransaction: $limitTransaction)';
  }
}
