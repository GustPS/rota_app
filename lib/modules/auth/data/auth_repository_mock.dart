import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/login_response.dart';
import 'package:rota_app/core/helpers/token_helper.dart';

class AuthRepositoryMock implements AuthRepository {
  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'teste@rota.com' && password == '123456') {
      const tokenFalso = 'mocked-token-123456';

      await TokenHelper.saveToken(tokenFalso);
      await TokenHelper.saveUserName('Motorista Teste');

      return LoginResponse(
        token: tokenFalso,
        user: {
          'id': 1,
          'name': 'Motorista Teste',
          'email': email,
          'type': 'driver',
        },
        driver: {
          'id': 1,
          'name': 'Motorista Teste',
          'email': email,
          'phone': '(11) 99999-9999',
          'status': true,
        },
      );
    } else {
      throw Exception('Usuário ou senha inválidos (modo mock)');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('[Mock] Simulando envio de recuperação para $email');

    if (!email.contains('@')) {
      throw Exception('E-mail inválido (simulado)');
    }

    // Aqui você poderia simular o sucesso ou falha condicionalmente também
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 800));
    debugPrint('[Mock] Simulando logout');
    await TokenHelper.clearToken();
  }
}
