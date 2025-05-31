import 'login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login({
    required String email,
    required String password,
  });
  Future<void> forgotPassword(String email);
  Future<void> logout();
}

