class ProductReportModel {
  final int productId;
  final String productName;
  final int salesCount;
  final int totalQuantity;
  final double totalRevenue;

  ProductReportModel({
    required this.productId,
    required this.productName,
    required this.salesCount,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  factory ProductReportModel.fromMap(Map<String, dynamic> map) {
    return ProductReportModel(
      productId: map['product_id'],
      productName: map['product_name'] ?? '',
      salesCount: map['sales_count'],
      totalQuantity: map['total_quantity'],
      totalRevenue: (map['total_revenue'] as num).toDouble(),
    );
  }
}