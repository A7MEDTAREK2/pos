import 'purchase_item_model.dart';

class PurchaseModel {
  final int? id;
  final int supplierId;
  final String supplierName;
  final double subtotal;
  final double discount;
  final double total;
  final String paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final List<PurchaseItemModel> items;

  const PurchaseModel({
    this.id,
    required this.supplierId,
    required this.supplierName,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.items,
  });

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];

    final items = rawItems is List
        ? rawItems
        .whereType<Map>()
        .map(
          (item) => PurchaseItemModel.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList()
        : <PurchaseItemModel>[];

    return PurchaseModel(
      id: map['id'] as int?,
      supplierId: (map['supplier_id'] as num).toInt(),
      supplierName: map['supplier_name']?.toString() ?? '',
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      total: (map['total'] as num?)?.toDouble() ?? 0,
      paymentMethod:
      map['payment_method']?.toString() ?? 'Cash',
      notes: map['notes']?.toString(),
      createdAt: DateTime.tryParse(
        map['created_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
      items: items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'payment_method': paymentMethod,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PurchaseModel copyWith({
    int? id,
    int? supplierId,
    String? supplierName,
    double? subtotal,
    double? discount,
    double? total,
    String? paymentMethod,
    String? notes,
    DateTime? createdAt,
    List<PurchaseItemModel>? items,
  }) {
    return PurchaseModel(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}