import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Category>> getCategoriesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Category.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addCategory(String uid, Category category) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .add(category.toMap());
  }

  Future<void> updateCategory(
      String uid, String categoryId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .doc(categoryId)
        .update(data);
  }

  Future<void> deleteCategory(String uid, String categoryId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }
}
