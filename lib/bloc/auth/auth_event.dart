part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

class AuthLoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  AuthLoginWithEmailRequested(this.email, this.password);
}

class AuthRegisterWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  AuthRegisterWithEmailRequested(this.email, this.password);
}
