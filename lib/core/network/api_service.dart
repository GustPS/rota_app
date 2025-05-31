import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rota_app/core/helpers/token_helper.dart';
import 'package:rota_app/core/config/dev_config.dart';
import 'package:rota_app/core/config/api_config.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: DevConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('🌐 API Request: ${options.method} ${options.uri}');
        debugPrint('📦 Request Data: ${options.data}');
        
        final token = await TokenHelper.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          debugPrint('🔑 Token adicionado ao header: Bearer ${token.substring(0, 10)}...');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ API Response: ${response.statusCode}');
        debugPrint('📦 Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('❌ API Error: ${e.type}');
        debugPrint('❌ Status Code: ${e.response?.statusCode}');
        debugPrint('❌ Response Data: ${e.response?.data}');
        
        // Se for erro 401, limpa o token local
        if (e.response?.statusCode == 401) {
          TokenHelper.clearToken();
          debugPrint('🔑 Token local limpo devido a erro 401');
        }
        
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }

  Future<Response> postMultipart(String path, FormData formData) {
    return _dio.post(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }
}
