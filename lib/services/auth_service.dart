import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:moneymate/models/category.dart';
import 'package:moneymate/models/user.dart' as model;
class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<auth.User?> get userStream => _firebaseAuth.authStateChanges();

  auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<auth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      auth.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      auth.User? user = credential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();

        final newUser = model.User(
          uid: user.uid,
          displayName: displayName,
          email: email,
          photoUrl: '',
          currency: 'VND',
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        await seedDefaultCategories(user.uid);
      }

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      auth.UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> seedDefaultCategories(String userId) async {
    final categories = [
      Category(
        id: '1',
        name: 'Ăn Uống',
        type: 'expense',
        emoji: '🍔',
        color: '#FF6B6B',
        isDefault: true,
      ),
      Category(
        id: '2',
        name: 'Đi Lại',
        type: 'expense',
        emoji: '🚗',
        color: '#4ECDC4',
        isDefault: true,
      ),
      Category(
        id: '3',
        name: 'Mua Sắm',
        type: 'expense',
        emoji: '🛍️',
        color: '#FFD93D',
        isDefault: true,
      ),
      Category(
        id: '4',
        name: 'Hóa Đơn',
        type: 'expense',
        emoji: '💡',
        color: '#6AB1FF',
        isDefault: true,
      ),
      Category(
        id: '5',
        name: 'Thu Nhập',
        type: 'income',
        emoji: '💰',
        color: '#4CAF50',
        isDefault: true,
      ),
    ];

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc('defaults')
        .set({
          'categories': categories.map((c) => c.toMap()).toList(),
          'createdAt': DateTime.now(),
        });
  }
}
