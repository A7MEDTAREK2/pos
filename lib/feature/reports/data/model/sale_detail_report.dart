class SaleItemModel {
  final int productId;
  final String productName;
  final String? sizeName;
  final int quantity;
  final double price;
  final double total;

  SaleItemModel({
    required this.productId,
    required this.productName,
    this.sizeName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      productId: map['product_id'],
      productName: map['product_name'] ?? '',
      sizeName: map['size_name'],
      quantity: map['quantity'],
      price: (map['price'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
    );
  }
}

class SaleDetailsModel {
  final int saleId;
  final int orderNumber;

  final String customerName;
  final String customerPhone;
  final String customerAddress;

  final int orderType;
  final String paymentMethod;

  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryFee;
  final double total;

  final DateTime createdAt;

  final List<SaleItemModel> items;

  SaleDetailsModel({
    required this.saleId,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.orderType,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    required this.items,
  });
}