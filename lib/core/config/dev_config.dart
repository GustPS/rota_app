import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api_config.dart';

class DevConfig {
  /// Define se o app está rodando em modo desenvolvimento (manual ou automático)
  static bool get isDev => dotenv.env['APP_ENV'] == 'development';

  /// Define se deve exibir logs em debug
  static const bool enableLogs = true;

  /// Simula delay em chamadas de repositório (mock)
  static bool get simulateDelay => isDev;

  /// Força uso de repositórios mockados mesmo fora do dev
  static bool get forceMock => dotenv.env['FORCE_MOCK'] == 'true';

  /// Acesso à API definida no .env
  static String get apiBaseUrl {
    try {
      final url = dotenv.env['API_URL'] ?? 'http://rota.test/api';
      debugPrint('🌐 API Base URL: $url');
      return url;
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar API_URL do .env, usando URL padrão');
      return 'http://rota.test/api';
    }
  }

  /// Nome do ambiente (opcional para exibir no app ou log)
  static String get appEnv {
    try {
      return dotenv.env['APP_ENV'] ?? 'development';
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar APP_ENV do .env, usando ambiente padrão');
      return 'development';
    }
  }
}
