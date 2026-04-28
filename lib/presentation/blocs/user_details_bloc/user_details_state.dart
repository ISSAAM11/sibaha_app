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

class UploadPictureLoading extends UserDetailsState {}

class UpdateProfileLoading extends UserDetailsState {}

class UpdateProfileSuccess extends UserDetailsState {}

class UpdateProfileError extends UserDetailsState {
  final String message;
  UpdateProfileError(this.message);
}

class ChangePasswordLoading extends UserDetailsState {}

class ChangePasswordSuccess extends UserDetailsState {}

class ChangePasswordError extends UserDetailsState {
  final String message;
  ChangePasswordError(this.message);
}
