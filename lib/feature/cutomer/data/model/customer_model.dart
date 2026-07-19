class CustomerModel {
  final int? id;
  final String name;
  final String phone;
  final DateTime createdAt;

  const CustomerModel({
    this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
  });

  factory CustomerModel.empty() {
    return CustomerModel(
      id: null,
      name: '',
      phone: '',
      createdAt: DateTime.now(),
    );
  }

  CustomerModel copyWith({
    int? id,
    String? name,
    String? phone,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}


class CustomerAddressModel {
  final int? id;
  final int customerId;
  final String? title;
  final String area;
  final String address;
  final String? notes;
  final bool isDefault;
  final DateTime createdAt;

  CustomerAddressModel({
    this.id,
    required this.customerId,
    this.title,
    required this.area,
    required this.address,
    this.notes,
    this.isDefault = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'title': title,
      'area': area,
      'address': address,
      'notes': notes,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CustomerAddressModel.fromMap(Map<String, dynamic> map) {
    return CustomerAddressModel(
      id: map['id'],
      customerId: map['customer_id'],
      title: map['title'],
      area: map['area'],
      address: map['address'],
      notes: map['notes'],
      isDefault: map['is_default'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}