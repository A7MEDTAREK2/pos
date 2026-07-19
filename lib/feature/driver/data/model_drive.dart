class DriverModel {
  final int? id;
  final String name;
  final String? phone;
  final bool isActive;
  final String createdAt;

  DriverModel({
    this.id,
    required this.name,
    this.phone,
    this.isActive = true,
    required this.createdAt,
  });

  DriverModel copyWith({
    int? id,
    String? name,
    String? phone,
    bool? isActive,
    String? createdAt,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'],
      isActive: map['is_active'] == 1,
      createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }
}