class AuthService {
  Future<String> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    return "token";
  }

  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
  }
}
