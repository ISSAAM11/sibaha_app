part of 'user_details_bloc.dart';

@immutable
sealed class UserDetailsEvent {}

class FetchUserEvent extends UserDetailsEvent {
  final String token;

  FetchUserEvent(this.token);
}

class UploadProfilePictureEvent extends UserDetailsEvent {
  final String token;
  final XFile imageFile;

  UploadProfilePictureEvent(this.token, this.imageFile);
}

class UserDetailsReset extends UserDetailsEvent {}

class UpdateProfileEvent extends UserDetailsEvent {
  final String token;
  final String? username;
  final String? phone;

  UpdateProfileEvent(this.token, {this.username, this.phone});
}

class ChangePasswordEvent extends UserDetailsEvent {
  final String token;
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent(this.token, this.currentPassword, this.newPassword);
}
