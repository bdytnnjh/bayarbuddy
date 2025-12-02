import 'package:cloud_firestore/cloud_firestore.dart';

class ScamTriggerHistoryModel {
  final String historyId;
  final String userId;
  final String transferId;
  final String recipientName;
  final String recipientWalletNumber;
  final double amount;
  final String triggerType; // 'panic_button', 'multiple_approve_attempts', 'help_me'
  final int approveAttempts;
  final bool isResolved;
  final String? resolvedBy; // 'user', 'trusted_contact'
  final String? resolution; // 'approved', 'rejected', 'timeout'
  final DateTime triggeredAt;
  final DateTime? resolvedAt;

  ScamTriggerHistoryModel({
    required this.historyId,
    required this.userId,
    required this.transferId,
    required this.recipientName,
    required this.recipientWalletNumber,
    required this.amount,
    required this.triggerType,
    required this.approveAttempts,
    required this.isResolved,
    this.resolvedBy,
    this.resolution,
    required this.triggeredAt,
    this.resolvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'transferId': transferId,
      'recipientName': recipientName,
      'recipientWalletNumber': recipientWalletNumber,
      'amount': amount,
      'triggerType': triggerType,
      'approveAttempts': approveAttempts,
      'isResolved': isResolved,
      'resolvedBy': resolvedBy,
      'resolution': resolution,
      'triggeredAt': Timestamp.fromDate(triggeredAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
    };
  }

  factory ScamTriggerHistoryModel.fromMap(Map<String, dynamic> map, String id) {
    return ScamTriggerHistoryModel(
      historyId: id,
      userId: map['userId'] ?? '',
      transferId: map['transferId'] ?? '',
      recipientName: map['recipientName'] ?? '',
      recipientWalletNumber: map['recipientWalletNumber'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      triggerType: map['triggerType'] ?? '',
      approveAttempts: map['approveAttempts'] ?? 0,
      isResolved: map['isResolved'] ?? false,
      resolvedBy: map['resolvedBy'],
      resolution: map['resolution'],
      triggeredAt: (map['triggeredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (map['resolvedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ScamTriggerHistoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return ScamTriggerHistoryModel.fromMap(data, doc.id);
  }

  ScamTriggerHistoryModel copyWith({
    String? historyId,
    String? userId,
    String? transferId,
    String? recipientName,
    String? recipientWalletNumber,
    double? amount,
    String? triggerType,
    int? approveAttempts,
    bool? isResolved,
    String? resolvedBy,
    String? resolution,
    DateTime? triggeredAt,
    DateTime? resolvedAt,
  }) {
    return ScamTriggerHistoryModel(
      historyId: historyId ?? this.historyId,
      userId: userId ?? this.userId,
      transferId: transferId ?? this.transferId,
      recipientName: recipientName ?? this.recipientName,
      recipientWalletNumber: recipientWalletNumber ?? this.recipientWalletNumber,
      amount: amount ?? this.amount,
      triggerType: triggerType ?? this.triggerType,
      approveAttempts: approveAttempts ?? this.approveAttempts,
      isResolved: isResolved ?? this.isResolved,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolution: resolution ?? this.resolution,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
