part of 'token_bloc.dart';

@immutable
sealed class TokenState {}

final class TokenInitial extends TokenState {}

class TokenRetrieved extends TokenState {
  final String token;
  final String userName;

  TokenRetrieved(this.token, this.userName);
}

class TokenExpired extends TokenState {}

class TokenNotFound extends TokenState {}
