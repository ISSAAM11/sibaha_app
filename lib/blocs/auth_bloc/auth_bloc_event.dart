part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class ResetAuthEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class AutoAuthEvent extends AuthEvent {}
