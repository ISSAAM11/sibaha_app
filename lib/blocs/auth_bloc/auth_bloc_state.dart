part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailed extends AuthState {
  final String error;

  AuthFailed(this.error);
}

class AuthLogout extends AuthState {}
