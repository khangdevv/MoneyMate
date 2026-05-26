import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/transaction.dart';

class TransactionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Transaction>> getTransactionsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Transaction.fromMap(d.data(), d.id)).toList());
  }

  Future<void> addTransaction(String uid, Transaction tx) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add(tx.toMap());
  }

  Future<void> deleteTransaction(String uid, String txId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(txId)
        .delete();
  }
}
