part of 'token_bloc.dart';

@immutable
sealed class TokenEvent {}

class TokenFetch extends TokenEvent {}

class TokenRefresh extends TokenEvent {}

class TokenDelete extends TokenEvent {}
