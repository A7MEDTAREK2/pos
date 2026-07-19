class HomeMetricsModel {
  final double todaySales;
  final int invoiceCount;
  final int totalProducts;
  final int totalCustomers;

  HomeMetricsModel({
    required this.todaySales,
    required this.invoiceCount,
    required this.totalProducts,
    required this.totalCustomers,
  });

  // ميزة الـ Model إنه بيتحكم في تحويل الـ Map اللي جاية من الـ Database
  factory HomeMetricsModel.fromMap(Map<String, dynamic> map) {
    return HomeMetricsModel(
      todaySales: (map['today_sales'] as num?)?.toDouble() ?? 0.0,
      invoiceCount: map['invoice_count'] as int? ?? 0,
      totalProducts: map['total_products'] as int? ?? 0,
      totalCustomers: map['total_customers'] as int? ?? 0,
    );
  }
}