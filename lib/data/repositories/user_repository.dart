import 'package:image_picker/image_picker.dart';
import 'package:sibaha_app/data/models/user.dart';
import 'package:sibaha_app/data/services/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<User> getUserDetails(String token) =>
      _service.fetchUserDetails(token);

  Future<User> uploadProfilePicture(String token, XFile imageFile) =>
      _service.uploadProfilePicture(token, imageFile);

  Future<User> updateProfile(
          String token, {String? username, String? phone}) =>
      _service.updateProfile(token, username: username, phone: phone);

  Future<void> changePassword(
          String token, String currentPassword, String newPassword) =>
      _service.changePassword(token, currentPassword, newPassword);
}
