import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String currency; 
  final DateTime createdAt;

  User({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    this.currency = 'VND',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'currency': currency,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String uid) {
    return User(
      uid: uid,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      currency: map['currency'] ?? 'VND',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
