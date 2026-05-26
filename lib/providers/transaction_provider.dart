import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _service = TransactionService();
  List<Transaction> _transactions = [];
  StreamSubscription<List<Transaction>>? _subscription;

  List<Transaction> get transactions => _transactions;

  void init(String uid) {
    _subscription?.cancel();
    _subscription = _service.getTransactionsStream(uid).listen(
      (data) {
        _transactions = data;
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  double monthlyIncome(int year, int month) => _transactions
      .where((t) =>
          t.type == 'income' &&
          t.date.year == year &&
          t.date.month == month)
      .fold(0.0, (sum, t) => sum + t.amount);

  double monthlyExpense(int year, int month) => _transactions
      .where((t) =>
          t.type == 'expense' &&
          t.date.year == year &&
          t.date.month == month)
      .fold(0.0, (sum, t) => sum + t.amount);

  List<Transaction> byMonth(int year, int month) => _transactions
      .where((t) => t.date.year == year && t.date.month == month)
      .toList();

  Future<void> add(String uid, Transaction tx) =>
      _service.addTransaction(uid, tx);

  Future<void> remove(String uid, String txId) =>
      _service.deleteTransaction(uid, txId);

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
