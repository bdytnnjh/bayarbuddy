import 'package:cloud_firestore/cloud_firestore.dart';

class TransferHistoryModel {
  final String id;
  final String senderUid;
  final String recipientAcc;
  final String recipientName;
  final double amount;
  final String description;
  final String status; // 'PENDING_APPROVAL', 'SUCCESS', 'FAILED', 'REJECTED'
  final bool isDistressSignal;
  final DateTime createdAt;
  final DateTime? completedAt;

  TransferHistoryModel({
    required this.id,
    required this.senderUid,
    required this.recipientAcc,
    required this.recipientName,
    required this.amount,
    required this.description,
    required this.status,
    this.isDistressSignal = false,
    required this.createdAt,
    this.completedAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'recipientAcc': recipientAcc,
      'recipientName': recipientName,
      'amount': amount,
      'description': description,
      'status': status,
      'isDistressSignal': isDistressSignal,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  // Create from Firestore snapshot
  factory TransferHistoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TransferHistoryModel(
      id: doc.id,
      senderUid: data['senderUid'] ?? '',
      recipientAcc: data['recipientAcc'] ?? '',
      recipientName: data['recipientName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      status: data['status'] ?? 'PENDING_APPROVAL',
      isDistressSignal: data['isDistressSignal'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Create from Map
  factory TransferHistoryModel.fromMap(Map<String, dynamic> data, String id) {
    return TransferHistoryModel(
      id: id,
      senderUid: data['senderUid'] ?? '',
      recipientAcc: data['recipientAcc'] ?? '',
      recipientName: data['recipientName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      status: data['status'] ?? 'PENDING_APPROVAL',
      isDistressSignal: data['isDistressSignal'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  // CopyWith method
  TransferHistoryModel copyWith({
    String? id,
    String? senderUid,
    String? recipientAcc,
    String? recipientName,
    double? amount,
    String? description,
    String? status,
    bool? isDistressSignal,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TransferHistoryModel(
      id: id ?? this.id,
      senderUid: senderUid ?? this.senderUid,
      recipientAcc: recipientAcc ?? this.recipientAcc,
      recipientName: recipientName ?? this.recipientName,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      isDistressSignal: isDistressSignal ?? this.isDistressSignal,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// Transfer status constants
class TransferStatus {
  static const String pendingApproval = 'PENDING_APPROVAL';
  static const String success = 'SUCCESS';
  static const String failed = 'FAILED';
  static const String rejected = 'REJECTED';
}
