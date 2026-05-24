import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _service = CategoryService();
  List<Category> _categories = [];
  Map<String, Category> _categoryMap = {};
  StreamSubscription<List<Category>>? _subscription;

  List<Category> get categories => _categories;
  Map<String, Category> get categoryMap => _categoryMap;

  void init(String uid) {
    _subscription?.cancel();
    _subscription = _service.getCategoriesStream(uid).listen(
      (data) {
        _categories = data;
        _categoryMap = {for (final cat in data) cat.id: cat};
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  Future<void> createCategory(
      String uid, String name, String emoji, String color, String type) async {
    final category = Category(
      id: '',
      name: name,
      emoji: emoji,
      color: color,
      type: type,
      isDefault: false,
    );
    await _service.addCategory(uid, category);
  }

  Future<void> removeCategory(String uid, String categoryId) async {
    await _service.deleteCategory(uid, categoryId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
