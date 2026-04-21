import 'package:sibaha_app/data/models/user.dart';
import 'package:sibaha_app/data/services/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<User> getUserDetails(String token) =>
      _service.fetchUserDetails(token);
}
