import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Пользователь не найден');
      } else if (e.code == 'wrong-password') {
        throw Exception('Неверный пароль');
      } else {
        throw Exception('Ошибка входа: ${e.message}');
      }
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Слабый пароль');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Почта уже используется');
      } else {
        throw Exception('Ошибка регистрации: ${e.message}');
      }
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}