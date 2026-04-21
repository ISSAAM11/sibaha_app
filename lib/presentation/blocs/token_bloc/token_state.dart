part of 'token_bloc.dart';

@immutable
sealed class TokenState {}

final class TokenInitial extends TokenState {}

class TokenRetrieved extends TokenState {
  final String token;
  final String username;
  final String userType;

  TokenRetrieved(this.token, this.username, this.userType);
}

class TokenExpired extends TokenState {}

class TokenNotFound extends TokenState {}
