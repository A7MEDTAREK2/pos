class CustomerReportModel {
  final int customerId;
  final String customerName;
  final String phone;
  final int ordersCount;
  final double totalSpent;
  final double averageOrder;
  final DateTime? lastOrderDate;
  final double totalPurchases;
  final String lastPurchase;

  CustomerReportModel({
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.ordersCount,
    required this.totalSpent,
    required this.averageOrder,
    required this.lastOrderDate,
    required this.totalPurchases,
    required this.lastPurchase,
  });

  factory CustomerReportModel.fromMap(Map<String, dynamic> map) {
    return CustomerReportModel(
      customerId: map['customerId'] ?? 0,
      customerName: map['customerName'] ?? '',
      phone: map['phone'] ?? '',
      ordersCount: map['ordersCount'] ?? 0,
      totalSpent: (map['totalSpent'] ?? 0).toDouble(),
      averageOrder: (map['averageOrder'] ?? 0).toDouble(),
      lastOrderDate: map['lastOrderDate'] != null &&
          map['lastOrderDate'].toString().isNotEmpty
          ? DateTime.parse(map['lastOrderDate'])
          : null,
      totalPurchases: (map['totalPurchases'] ?? 0).toDouble(),
      lastPurchase: map['lastPurchase'] ?? '',
    );
  }
}