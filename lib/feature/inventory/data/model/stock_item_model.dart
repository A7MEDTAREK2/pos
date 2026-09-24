class StockItemModel {
  final int id;
  final String name;
  final String? barcode;
  final double quantity;
  final double minimumStock;
  final double costPrice;
  final double sellPrice;
  final String? categoryName;

  StockItemModel({
    required this.id,
    required this.name,
    this.barcode,
    required this.quantity,
    required this.minimumStock,
    required this.costPrice,
    required this.sellPrice,
    this.categoryName,
  });

  bool get isLowStock => minimumStock > 0 && quantity <= minimumStock;

  factory StockItemModel.fromMap(Map<String, dynamic> map) {
    return StockItemModel(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      barcode: map['barcode'] as String?,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      minimumStock: (map['minimum_stock'] as num?)?.toDouble() ?? 0.0,
      costPrice: (map['cost_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0.0,
      categoryName: map['category_name'] as String?,
    );
  }
}