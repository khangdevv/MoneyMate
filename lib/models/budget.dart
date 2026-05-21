import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id; 
  final int year;
  final int month;
  final double limitAmount; 
  final DateTime updatedAt;

  Budget({
    required this.id,
    required this.year,
    required this.month,
    required this.limitAmount,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'limitAmount': limitAmount,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map, String id) {
    return Budget(
      id: id,
      year: map['year'] ?? DateTime.now().year,
      month: map['month'] ?? DateTime.now().month,
      limitAmount: (map['limitAmount'] as num?)?.toDouble() ?? 0.0,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}