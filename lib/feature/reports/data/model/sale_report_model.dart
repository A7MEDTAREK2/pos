class SalesReportModel {
  final int saleId;
  final int orderNumber;
  final String customerName;
  final int orderType;
  final String paymentMethod;
  final double total;
  final DateTime createdAt;

  const SalesReportModel({
    required this.saleId,
    required this.orderNumber,
    required this.customerName,
    required this.orderType,
    required this.paymentMethod,
    required this.total,
    required this.createdAt,
  });

  factory SalesReportModel.fromMap(Map<String, dynamic> map) {
    return SalesReportModel(
      saleId: map['id'] as int,
      orderNumber: map['order_number'] as int,
      customerName:
      map['customer_name']?.toString().isNotEmpty == true
          ? map['customer_name'].toString()
          : "عميل نقدي",
      orderType: map['order_type'] as int,
      paymentMethod: map['payment_method'].toString(),
      total: (map['total'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'].toString()),
    );
  }
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
}