class ReceiverModel {
  final String userId;
  final String name;
  final String walletNumber;
  final String? photoUrl;
  final String? phoneNumber;
  final String? email;

  ReceiverModel({
    required this.userId,
    required this.name,
    required this.walletNumber,
    this.photoUrl,
    this.phoneNumber,
    this.email,
  });

  factory ReceiverModel.fromUserAndWallet({
    required Map<String, dynamic> userData,
    required String walletNumber,
  }) {
    return ReceiverModel(
      userId: userData['uid'] ?? '',
      name: userData['fullName'] ?? userData['username'] ?? 'Unknown',
      walletNumber: walletNumber,
      photoUrl: userData['photoUrl'],
      phoneNumber: userData['phoneNumber'],
      email: userData['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'walletNumber': walletNumber,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'ReceiverModel(userId: $userId, name: $name, walletNumber: $walletNumber)';
  }
}
