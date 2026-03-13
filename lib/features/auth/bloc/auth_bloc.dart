import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // BLoC координирует сценарии авторизации через FirebaseAuth.
  final FirebaseAuth _auth;

  AuthBloc(this._auth) : super(AuthInitial()) {
    // Регистрируем обработчики основных auth-событий.
    on<AuthLoginRequested>(_onLoginAnonymously);
    on<AuthLoginWithEmailRequested>(_onLoginWithEmail);
    on<AuthRegisterWithEmailRequested>(_onRegisterWithEmail);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onLoginAnonymously(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Единый паттерн: loading -> операция -> success/error.
    emit(AuthLoading());
    try {
      await _auth.signInAnonymously();
      emit(AuthInitial());
    } on FirebaseAuthException catch (e) {
      // После ошибки возвращаемся в базовое состояние экрана.
      emit(AuthError(e.message ?? 'Login failed'));
      emit(AuthInitial());
    }
  }

  Future<void> _onLoginWithEmail(
    AuthLoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthInitial());
    } on FirebaseAuthException {
      // Текст ошибки упрощен для дружелюбного UX.
      emit(AuthError('Email or password is wrong'));
      emit(AuthInitial());
    }
  }

  Future<void> _onRegisterWithEmail(
    AuthRegisterWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthInitial());
    } on FirebaseAuthException catch (e) {
      // Пробрасываем системное сообщение, если оно доступно.
      emit(AuthError(e.message ?? 'Registration failed'));
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Явно завершаем сессию и синхронизируем UI с исходным состоянием.
    await _auth.signOut();
    emit(AuthInitial());
  }
}
