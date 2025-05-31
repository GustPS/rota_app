import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    final url = dotenv.env['API_BASE_URL'] ?? 'http://rota.test/api';
    debugPrint('API Base URL: $url'); // Log para debug
    return url;
  }

  // Auth endpoints
  static const String login = '/login/driver';
  static const String logout = '/logout';
  static const String forgotPassword = '/forgot-password';

  // Driver endpoints
  static const String driverProfile = '/driver/profile';
  static const String driverRoutes = '/driver/routes';
  static const String driverRouteDetail = '/driver/routes/{id}';
  static const String driverDeliveries = '/driver/deliveries';
  static const String driverDeliveryDetail = '/driver/deliveries/{id}';
  static const String completeDelivery = '/driver/deliveries/{id}/complete';

  // Helper methods
  static String getRouteDetailUrl(int routeId) {
    return driverRouteDetail.replaceAll('{id}', routeId.toString());
  }

  static String getDeliveryDetailUrl(int deliveryId) {
    return driverDeliveryDetail.replaceAll('{id}', deliveryId.toString());
  }

  static String getDeliveryCompleteUrl(int deliveryId) {
    return completeDelivery.replaceAll('{id}', deliveryId.toString());
  }
} 