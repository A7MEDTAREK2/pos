class OrderTypeReportModel {
  final int orderType;
  final int ordersCount;
  final double totalRevenue;
  final double percentage;

  OrderTypeReportModel({
    required this.orderType,
    required this.ordersCount,
    required this.totalRevenue,
    required this.percentage,
  });

  String get orderTypeName {
    switch (orderType) {
      case 0:
        return "تيك أواي";
      case 1:
        return "داخل المطعم";
      case 2:
        return "دليفري";
      default:
        return "-";
    }
  }

  // ======================
  // UI Compatibility
  // ======================

  int get orderCount => ordersCount;

  double get averageValue =>
      ordersCount == 0 ? 0 : totalRevenue / ordersCount;

  OrderTypeReportModel copyWith({
    double? percentage,
  }) {
    return OrderTypeReportModel(
      orderType: orderType,
      ordersCount: ordersCount,
      totalRevenue: totalRevenue,
      percentage: percentage ?? this.percentage,
    );
  }

  factory OrderTypeReportModel.fromMap(Map<String, dynamic> map) {
    return OrderTypeReportModel(
      orderType: map['orderType'] ?? 0,
      ordersCount: map['ordersCount'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0).toDouble(),
      percentage: (map['percentage'] ?? 0).toDouble(),
    );
  }
}