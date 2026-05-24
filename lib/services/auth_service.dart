import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(displayName);
    await user.reload();
    await _seedNewUser(user.uid, displayName, email);
    return credential;
  }

  Future<auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _seedNewUser(String uid, String displayName, String email) async {
    final batch = _firestore.batch();

    batch.set(_firestore.collection('users').doc(uid), {
      'displayName': displayName,
      'email': email,
      'photoUrl': '',
      'currency': 'VND',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final catRef = _firestore.collection('users').doc(uid).collection('categories');
    for (final cat in _defaultCategories) {
      batch.set(catRef.doc(), {
        ...cat,
        'isDefault': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  static const List<Map<String, dynamic>> _defaultCategories = [
    {'name': 'Ăn uống',   'emoji': '🍔', 'color': '#E67E22', 'type': 'expense'},
    {'name': 'Di chuyển', 'emoji': '🚗', 'color': '#3498DB', 'type': 'expense'},
    {'name': 'Mua sắm',   'emoji': '🛍️', 'color': '#9B59B6', 'type': 'expense'},
    {'name': 'Nhà ở',     'emoji': '🏠', 'color': '#1ABC9C', 'type': 'expense'},
    {'name': 'Y tế',      'emoji': '💊', 'color': '#E74C3C', 'type': 'expense'},
    {'name': 'Học tập',   'emoji': '📚', 'color': '#2ECC71', 'type': 'expense'},
    {'name': 'Giải trí',  'emoji': '🎮', 'color': '#F39C12', 'type': 'expense'},
    {'name': 'Khác',      'emoji': '💸', 'color': '#95A5A6', 'type': 'expense'},
    {'name': 'Lương',     'emoji': '💼', 'color': '#27AE60', 'type': 'income'},
    {'name': 'Quà tặng',  'emoji': '🎁', 'color': '#E91E63', 'type': 'income'},
    {'name': 'Đầu tư',    'emoji': '📈', 'color': '#00BCD4', 'type': 'income'},
    {'name': 'Khác',      'emoji': '💰', 'color': '#8BC34A', 'type': 'income'},
  ];
}