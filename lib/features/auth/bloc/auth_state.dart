part of 'auth_bloc.dart';

abstract class AuthState {
  User? get user;
}

class AuthInitial extends AuthState {
  @override
  User? get user => FirebaseAuth.instance.currentUser;
}

class AuthLoading extends AuthState {
  @override
  User? get user => FirebaseAuth.instance.currentUser;
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  User? get user => FirebaseAuth.instance.currentUser;
}
