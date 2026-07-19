// lib/feature/sales_history/data/model/sales_history_model.dart

class SalesHistoryModel {
  final int id;
  final int orderNumber;
  final int? customerId;
  final String customerName;
  final String customerPhone;
  final int? userId;
  final int orderType; // 0: Take Away, 1: Dine In, 2: Delivery
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  List<SaleItemModel> items;


  SalesHistoryModel({
    required this.id,
    required this.orderNumber,
    this.customerId,
    required this.customerName,
    required this.customerPhone,
    this.userId,
    required this.orderType,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.items = const [],
  });

  factory SalesHistoryModel.fromMap(Map<String, dynamic> map) {
    return SalesHistoryModel(
      id: map['id'] as int,
      orderNumber: map['order_number'] as int,
      customerId: map['customer_id'] as int?,
      customerName: map['customer_name'] ?? '',
      customerPhone: map['customer_phone'] ?? '',
      userId: map['user_id'] as int?,
      orderType: map['order_type'] as int? ?? 0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num).toDouble(),
      paymentMethod: map['payment_method'] as String? ?? 'Cash',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'user_id': userId,
      'order_type': orderType,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'delivery_fee': deliveryFee,
      'total': total,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get orderTypeString {
    switch (orderType) {
      case 0:
        return 'Take Away';
      case 1:
        return 'Dine In';
      case 2:
        return 'Delivery';
      default:
        return 'Unknown';
    }
  }

  String get orderTypeStringAr {
    switch (orderType) {
      case 0:
        return 'طلبية خارجية';
      case 1:
        return 'تناول داخل';
      case 2:
        return 'توصيل';
      default:
        return 'غير معروف';
    }
  }

  String get displayCustomerName {
    return customerName.isEmpty ? 'عميل نقدي' : customerName;
  }
}

class SaleItemModel {
  final int id;
  final int saleId;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final String? sizeName;
  final double total;
  final String? note;

  SaleItemModel({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.sizeName,
    required this.total,
    this.note,
  });

  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      id: map['id'] as int,
      saleId: map['sale_id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] ?? '',
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      sizeName: map['size_name'] as String?,
      total: (map['total'] as num?)?.toDouble() ??
          ((map['price'] as num).toDouble() * (map['quantity'] as int).toDouble()),
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'size_name': sizeName,
      'total': total,
      'note': note,
    };
  }
}