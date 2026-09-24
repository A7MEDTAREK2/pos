class PurchaseProductModel {
  final int? id;
  final String name;
  final String? barcode;
  final String unit;
  final double costPrice;
  final double quantity;
  final double minimumStock;
  final bool isActive;
  final DateTime createdAt;

  const PurchaseProductModel({
    this.id,
    required this.name,
    this.barcode,
    required this.unit,
    required this.costPrice,
    required this.quantity,
    this.minimumStock = 0,
    required this.isActive,
    required this.createdAt,
  });

  factory PurchaseProductModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return PurchaseProductModel(
      id: map['id'] as int?,
      name: map['name']?.toString() ?? '',
      barcode: map['barcode']?.toString(),
      unit: map['unit']?.toString() ?? 'piece',
      costPrice: (map['cost_price'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
      minimumStock: (map['minimum_stock'] as num?)?.toDouble() ?? 0,
      isActive: (map['is_active'] as num?)?.toInt() == 1,
      createdAt: DateTime.tryParse(
        map['created_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'barcode': barcode,
      'unit': unit,
      'cost_price': costPrice,
      'quantity': quantity,
      'minimum_stock': minimumStock,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PurchaseProductModel copyWith({
    int? id,
    String? name,
    String? barcode,
    String? unit,
    double? costPrice,
    double? quantity,
    double? minimumStock,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return PurchaseProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}