import 'package:sibaha_app/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<Object?> tryAutoLogin() => _service.tryAutoLogin();

  Future<(String?, String?, String?)> retrieveToken() =>
      _service.retrieveToken();

  Future<void> login(String email, String password) =>
      _service.login(email, password);

  Future<void> register(
          String username, String email, String password, String phone, String userType) =>
      _service.register(username, email, password, phone, userType);

  Future<void> logout() => _service.logoutUser();

  Future<(String?, String?, String?)> refreshToken() =>
      _service.refreshToken();

  Future<void> requestPasswordReset(String email) =>
      _service.requestPasswordReset(email);

  Future<void> verifyResetCode(String email, String code) =>
      _service.verifyResetCode(email, code);

  Future<void> setNewPassword(String email, String code, String newPassword) =>
      _service.setNewPassword(email, code, newPassword);
}
