part of 'user_details_bloc.dart';

@immutable
sealed class UserDetailsState {}

final class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final User data;
  UserDetailsLoaded(this.data);
}

class UserDetailsError extends UserDetailsState {
  final String message;
  UserDetailsError(this.message);
}

class UserDetailsTokenExpired extends UserDetailsState {}
