class StockReportModel {
  final int productId;
  final String productName;
  final String categoryName;
  final int quantity;
  final int minimumQuantity;
  final double stockValue;

  StockReportModel({
    required this.productId,
    required this.productName,
    required this.categoryName,
    required this.quantity,
    required this.minimumQuantity,
    required this.stockValue,
  });

  bool get isOutOfStock => quantity == 0;

  bool get isLowStock =>
      quantity > 0 && quantity <= minimumQuantity;

  factory StockReportModel.fromMap(Map<String, dynamic> map) {
    return StockReportModel(
      productId: map['productId'],
      productName: map['productName'] ?? '',
      categoryName: map['categoryName'] ?? '',
      quantity: map['quantity'] ?? 0,
      minimumQuantity: map['minimumQuantity'] ?? 0,
      stockValue: (map['stockValue'] ?? 0).toDouble(),
    );
  }
}