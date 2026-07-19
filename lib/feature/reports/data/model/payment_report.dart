class PaymentReportModel {
  final String paymentMethod;
  final int ordersCount;
  final double totalRevenue;
  final double percentage;

  PaymentReportModel({
    required this.paymentMethod,
    required this.ordersCount,
    required this.totalRevenue,
    required this.percentage,
  });

  // ======================
  // UI Compatibility
  // ======================

  int get transactionCount => ordersCount;

  double get averageValue =>
      ordersCount == 0 ? 0 : totalRevenue / ordersCount;

  factory PaymentReportModel.fromMap(Map<String, dynamic> map) {
    return PaymentReportModel(
      paymentMethod: map['paymentMethod'] ?? '',
      ordersCount: map['ordersCount'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0).toDouble(),
      percentage: (map['percentage'] ?? 0).toDouble(),
    );
  }
}