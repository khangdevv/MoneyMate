import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Budget>> getBudgetsStream(String uid) {
    return _firestore
    .collection('users')
    .doc(uid)
    .collection('budgets')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Budget.fromMap(d.data(), d.id)).toList());
  }

  Future<void> addBudget(String uid, Budget budget) async {
    await _firestore
    .collection('users')
    .doc(uid)
    .collection('budgets')
    .doc(budget.id)
    .set(budget.toMap());
  }

  Future<void> deleteBudget(String uid, String budgetId) async {
    await _firestore
    .collection('users')
    .doc(uid)
    .collection('budgets')
    .doc(budgetId)
    .delete();
  }

  Future<void> updateBudget(String uid, String budgetId, Budget budget) async {
    await _firestore
    .collection('users')
    .doc(uid)
    .collection('budgets')
    .doc(budgetId)
    .update(budget.toMap());
  }

}