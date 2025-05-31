import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/core/network/api_service.dart';
import 'package:rota_app/modules/auth/data/auth_repository.dart';
import 'package:rota_app/modules/auth/data/login_response.dart';
import 'package:rota_app/core/config/api_config.dart';

class AuthRepositoryAPI implements AuthRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔑 Tentando login com email: $email');
      
      final response = await _apiService.post(ApiConfig.login, data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      debugPrint('📦 Resposta do login: $data');
      
      if (data['success'] == true) {
        final result = LoginResponse.fromJson(data);

        if (!result.isDriverActive) {
          debugPrint('❌ Motorista inativo');
          throw Exception('Sua conta está desativada. Entre em contato com o suporte.');
        }

        await TokenHelper.saveToken(result.token);
        await TokenHelper.saveUserName(result.driverName);
        await TokenHelper.saveUserData({
          'name': result.driverName,
          'email': result.user['email'],
          'phone': result.driverPhone,
          'id': result.driverId,
        });
        debugPrint('✅ Login realizado com sucesso');
        debugPrint('👤 Dados do usuário: ${result.driverName} (${result.user['email']})');

        return result;
      } else {
        final message = data['message'] ?? 'Erro ao fazer login';
        debugPrint('❌ Erro no login: $message');
        throw Exception(message);
      }
    } on DioException catch (e) {
      debugPrint('❌ Erro DioException: ${e.type}');
      debugPrint('❌ Status Code: ${e.response?.statusCode}');
      debugPrint('❌ Response Data: ${e.response?.data}');

      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Erro desconhecido';

      if (statusCode == 401) {
        throw Exception('Credenciais inválidas. Verifique seu e-mail e senha.');
      } else if (statusCode == 403) {
        throw Exception('Acesso negado. Você não tem permissão para acessar o aplicativo.');
      } else if (statusCode == 422) {
        throw Exception('Dados inválidos. Preencha corretamente.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Erro de conexão. Verifique sua internet e tente novamente.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Não foi possível conectar ao servidor. Verifique se a API está online.');
      } else {
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('❌ Erro inesperado: $e');
      throw Exception('Erro inesperado ao fazer login. Tente novamente.');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      debugPrint('🔑 Tentando recuperar senha para: $email');
      
      final response = await _apiService.post(ApiConfig.forgotPassword, data: {
        'email': email,
      });

      final data = response.data;
      debugPrint('📦 Resposta da recuperação: $data');
      
      if (data['success'] != true) {
        final message = data['message'] ?? 'Erro ao solicitar recuperação de senha';
        debugPrint('❌ Erro na recuperação: $message');
        throw Exception(message);
      }
      
      debugPrint('✅ Recuperação solicitada com sucesso');
    } on DioException catch (e) {
      debugPrint('❌ Erro DioException: ${e.type}');
      debugPrint('❌ Status Code: ${e.response?.statusCode}');
      debugPrint('❌ Response Data: ${e.response?.data}');

      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Erro desconhecido';

      if (statusCode == 404) {
        throw Exception('E-mail não encontrado.');
      } else if (statusCode == 422) {
        throw Exception('E-mail inválido.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Erro de conexão. Verifique sua internet e tente novamente.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Não foi possível conectar ao servidor. Verifique se a API está online.');
      } else {
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('❌ Erro inesperado: $e');
      throw Exception('Erro inesperado ao solicitar recuperação. Tente novamente.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      debugPrint('🔑 Realizando logout...');
      
      // Primeiro limpa o token local para garantir que não ficará token inválido
      await TokenHelper.clearToken();
      
      // Tenta fazer o logout na API, mas não falha se der erro
      try {
        final response = await _apiService.post(ApiConfig.logout);
        final data = response.data;
        
        if (data['success'] == true) {
          debugPrint('✅ Logout realizado com sucesso na API');
        } else {
          debugPrint('⚠️ API retornou erro no logout, mas token local foi limpo');
        }
      } on DioException catch (e) {
        // Se der erro 429 (rate limit) ou 401 (token inválido), apenas loga
        if (e.response?.statusCode == 429 || e.response?.statusCode == 401) {
          debugPrint('⚠️ Erro na API durante logout: ${e.response?.statusCode}');
        } else {
          // Para outros erros, relança a exceção
          rethrow;
        }
      }
      
      debugPrint('✅ Logout finalizado');
    } catch (e) {
      debugPrint('❌ Erro inesperado: $e');
      throw Exception('Erro inesperado ao realizar logout');
    }
  }
}
