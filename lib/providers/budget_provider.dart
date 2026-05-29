import 'dart:async';
import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../services/budget_service.dart';

class BudgetProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  List<Budget> _budgets = [];
  StreamSubscription<List<Budget>>? _subscription;

  List<Budget> get budgets => _budgets;

  void init(String uid) {
    _subscription?.cancel();
    _subscription = _budgetService.getBudgetsStream(uid).listen((budget) {
      _budgets = budget;
      notifyListeners();
    },
    onError: (_) {},
    );
  }

  String _budgetId(int year, int month) {
  return '${year}_${month.toString().padLeft(2, '0')}';
  }

  double budgetLimit(int year, int month) => _budgets
      .where((b) => b.year == year && b.month == month)
      .map((b) => b.limitAmount)
      .firstWhere((b) => true, orElse: () => 0.0);

  Future<void> createBudget(String uid, int year, int month, double limitAmount, 
  DateTime updatedAt) async {
    final budget = 
    Budget(id: _budgetId(year, month), year: year, month: month, limitAmount: limitAmount, updatedAt: updatedAt);
    await _budgetService.addBudget(uid, budget);
  }

  Future<void> updateBudget(String uid, int year, int month, double limitAmount, 
  DateTime updatedAt, String budgetId) async {
    final budget = Budget(id: budgetId, year: year, month: month, limitAmount: limitAmount, updatedAt: updatedAt);
    await _budgetService.updateBudget(uid, budgetId, budget);
  }

  Future<void> removeBudget(String uid, String budgetId) async {
    await _budgetService.deleteBudget(uid, budgetId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}