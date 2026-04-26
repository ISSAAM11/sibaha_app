part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String phone;
  final String userType;

  RegisterEvent(this.username, this.email, this.password, this.phone, this.userType);
}

class ResetAuthEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class AutoAuthEvent extends AuthEvent {}
