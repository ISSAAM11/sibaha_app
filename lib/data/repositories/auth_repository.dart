import 'package:sibaha_app/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<Object?> tryAutoLogin() => _service.tryAutoLogin();

  Future<(String?, String?, String?)> retrieveToken() =>
      _service.retrieveToken();

  Future<void> login(String email, String password) =>
      _service.login(email, password);

  Future<void> logout() => _service.logoutUser();

  Future<(String?, String?, String?)> refreshToken() =>
      _service.refreshToken();
}
