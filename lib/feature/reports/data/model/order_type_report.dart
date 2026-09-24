class OrderTypeReportModel {
  final int orderType;
  final int ordersCount;
  final double totalRevenue;
  final double totalDeliveryFees; // ✅ حقل جديد لإجمالي الدليفري
  final double percentage;

  OrderTypeReportModel({
    required this.orderType,
    required this.ordersCount,
    required this.totalRevenue,
    required this.totalDeliveryFees,
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

  int get orderCount => ordersCount;

  // إجمالي الإيراد شامل الدليفري لو احتجته في عرض إجمالي إيرادات نوع الطلب
  double get totalWithDelivery => totalRevenue + totalDeliveryFees;

  double get averageValue =>
      ordersCount == 0 ? 0 : totalWithDelivery / ordersCount;

  OrderTypeReportModel copyWith({
    double? percentage,
  }) {
    return OrderTypeReportModel(
      orderType: orderType,
      ordersCount: ordersCount,
      totalRevenue: totalRevenue,
      totalDeliveryFees: totalDeliveryFees,
      percentage: percentage ?? this.percentage,
    );
  }

  factory OrderTypeReportModel.fromMap(Map<String, dynamic> map) {
    return OrderTypeReportModel(
      orderType: map['orderType'] ?? 0,
      ordersCount: map['ordersCount'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0).toDouble(),
      totalDeliveryFees: (map['totalDeliveryFees'] ?? 0).toDouble(), // ✅ استقبال قيمة الدليفري
      percentage: (map['percentage'] ?? 0).toDouble(),
    );
  }
}