import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  // Репозиторий инкапсулирует все операции авторизации через FirebaseAuth.
  final FirebaseAuth _auth;

  UserRepository(this._auth);

  // Поток состояния сессии: используется для реактивной навигации в приложении.
  Stream<User?> get authState => _auth.authStateChanges();

  // Текущий пользователь (если уже авторизован).
  User? get currentUser => _auth.currentUser;

  Future<void> signInAnonymously() async {
    // Быстрый гостевой вход для демо и первого запуска.
    await _auth.signInAnonymously();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Авторизация по email и паролю.
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<User> registerWithEmail({
    required String email,
    required String password,
  }) async {
    // Создаем новый аккаунт и возвращаем созданного пользователя.
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!;
  }

  Future<void> signOut() async {
    // Завершаем текущую сессию пользователя.
    await _auth.signOut();
  }
}
