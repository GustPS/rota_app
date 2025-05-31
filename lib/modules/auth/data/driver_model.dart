class DriverModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final bool status;

  DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
    };
  }

  DriverModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    bool? status,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
    );
  }
} 