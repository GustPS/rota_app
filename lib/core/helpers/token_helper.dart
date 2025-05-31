import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rota_app/modules/auth/data/driver_model.dart';

class TokenHelper {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';
  static const _driverKey = 'driver_data';

  // Salva o token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Recupera o token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove o token e os dados do usuário
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_driverKey);
  }

  // Salva os dados do usuário
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Recupera os dados do usuário
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // Salva os dados do motorista
  static Future<void> saveDriverData(DriverModel driver) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_driverKey, jsonEncode(driver.toJson()));
  }

  // Recupera os dados do motorista
  static Future<DriverModel?> getDriverData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_driverKey);
    if (data != null) {
      return DriverModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  // Salva o nome do usuário
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  // Recupera o nome do usuário
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  // (Opcional) Tenta extrair o nome do usuário diretamente do token JWT, se aplicável
  static Future<String?> getUserNameFromToken() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> data = jsonDecode(payload);

      return data['name'] ?? data['user']?['name']; // Depende da estrutura do JWT
    } catch (e) {
      return null;
    }
  }
}
