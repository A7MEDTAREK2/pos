class PurchaseItemModel {
  final int? id;
  final int? purchaseId;

  /// ID من جدول purchase_products
  final int purchaseProductId;

  final String productName;
  final int quantity;
  final double costPrice;
  final double total;
  final String? note;

  const PurchaseItemModel({
    this.id,
    this.purchaseId,
    required this.purchaseProductId,
    required this.productName,
    required this.quantity,
    required this.costPrice,
    required this.total,
    this.note,
  });

  factory PurchaseItemModel.fromMap(Map<String, dynamic> map) {
    return PurchaseItemModel(
      id: (map['id'] as num?)?.toInt(),
      purchaseId: (map['purchase_id'] as num?)?.toInt(),
      // معالجة آمنة لاسم العمود وتفادي قيم null
      purchaseProductId:
      ((map['product_id'] ?? map['purchase_product_id']) as num?)?.toInt() ?? 0,
      productName: map['product_name']?.toString() ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      costPrice: (map['cost_price'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      note: map['note']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      // يرسل product_id لتطابق اسم عمود قاعدة بيانات SQLite
      'product_id': purchaseProductId,
      'product_name': productName,
      'quantity': quantity,
      'cost_price': costPrice,
      'total': total,
      'note': note,
    };
  }

  PurchaseItemModel copyWith({
    int? id,
    int? purchaseId,
    int? purchaseProductId,
    String? productName,
    int? quantity,
    double? costPrice,
    double? total,
    String? note,
  }) {
    return PurchaseItemModel(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      purchaseProductId: purchaseProductId ?? this.purchaseProductId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      costPrice: costPrice ?? this.costPrice,
      total: total ?? this.total,
      note: note ?? this.note,
    );
  }
}