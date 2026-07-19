class ShiftProductModel {
  final String name;
  final int quantitySold;
  final double totalSales;

  const ShiftProductModel({
    required this.name,
    required this.quantitySold,
    required this.totalSales,
  });

  factory ShiftProductModel.fromMap(Map<String, dynamic> map) {
    final productName = map['product_name']?.toString() ?? '';
    final sizeName = map['size_name']?.toString() ?? '';

    return ShiftProductModel(
      name: sizeName.isEmpty
          ? productName
          : '$productName ($sizeName)',
      quantitySold: (map['quantity_sold'] as num?)?.toInt() ?? 0,
      totalSales: (map['total_sales'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_name': name,
      'quantity_sold': quantitySold,
      'total_sales': totalSales,
    };
  }
}