part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailed extends AuthState {
  final String error;

  AuthFailed(this.error);
}

class AuthLogout extends AuthState {}

class AuthVisitor extends AuthState {}

class PasswordResetEmailSent extends AuthState {}

class PasswordResetCodeVerified extends AuthState {}

class PasswordResetSuccess extends AuthState {}
