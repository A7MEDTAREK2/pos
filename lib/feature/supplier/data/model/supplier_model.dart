// lib/feature/supplier/data/model/purchase_model.dart

class SupplierModel {
  final int? id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final bool isActive;
  final String createdAt;

  const SupplierModel({
    this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.isActive = true,
    required this.createdAt,
  });

  SupplierModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    bool? isActive,
    String? createdAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'notes': notes,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id'] as int?,
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      notes: map['notes']?.toString() ?? '',
      isActive: (map['is_active'] ?? 1) == 1,
      createdAt: map['created_at']?.toString() ?? '',
    );
  }
}