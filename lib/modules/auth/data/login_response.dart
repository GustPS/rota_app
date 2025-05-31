class LoginResponse {
  final String token;
  final Map<String, dynamic> user;
  final Map<String, dynamic> driver;

  LoginResponse({
    required this.token,
    required this.user,
    required this.driver,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};
    final driver = user['driver'] ?? {};

    return LoginResponse(
      token: data['token'] ?? '',
      user: user,
      driver: driver,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'token': token,
        'user': user,
      }
    };
  }

  bool get isDriverActive => driver['status'] == true;
  String get driverName => driver['name'] ?? '';
  String get driverPhone => driver['phone'] ?? '';
  int get driverId => driver['id'] ?? 0;
}
