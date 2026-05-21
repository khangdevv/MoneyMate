import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String emoji;
  final String color;
  final String type;
  final bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.type,
    required this.isDefault,
  });

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      emoji: map['emoji'] ?? '💸',
      color: map['color'] ?? '#95A5A6',
      type: map['type'] ?? 'expense',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'emoji': emoji,
    'color': color,
    'type': type,
    'isDefault': isDefault,
    'createdAt': FieldValue.serverTimestamp(),
  };
}