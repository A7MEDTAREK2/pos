class RecentSaleModel {
  final int orderNumber;
  final String customerName;
  final double total;
  final String paymentMethod;

  RecentSaleModel({
    required this.orderNumber,
    required this.customerName,
    required this.total,
    required this.paymentMethod,
  });
}