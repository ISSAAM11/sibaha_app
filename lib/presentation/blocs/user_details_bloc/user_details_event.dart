part of 'user_details_bloc.dart';

@immutable
sealed class UserDetailsEvent {}

class FetchUserEvent extends UserDetailsEvent {
  final String token;

  FetchUserEvent(this.token);
}

class UserDetailsReset extends UserDetailsEvent {}
