import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptImage {
  final String id;
  final String storagePath;
  final String downloadUrl;
  final DateTime uploadedAt;

  ReceiptImage({
    required this.id,
    required this.storagePath,
    required this.downloadUrl,
    required this.uploadedAt
  });

  factory ReceiptImage.fromMap(Map<String, dynamic> map) {
    return ReceiptImage(
      id: map['id'] ?? '',
      storagePath: map['storagePath'] ?? '',
      downloadUrl: map['downloadUrl'] ?? '',
      uploadedAt: map['uploadedAt'] is Timestamp
          ? (map['uploadedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
    };
  }
}