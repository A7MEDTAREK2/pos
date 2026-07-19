enum OrderStatus { holding, paid }

enum OrderType { takeAway, dineIn, delivery }

class OrderModel {
  final String id;
  final int orderNumber;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final OrderType orderType;
  final OrderStatus orderStatus;
  final int? customerId;
  final int? customerAddressId;
  final String? driverName;  // فقط اسم المندوب

  // البيانات الإضافية
  final String? tableNumber;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final String? customerArea;

  // ====== الحقول الجديدة للمبيعات ======
  final double? discount;      // الخصم
  final double? tax;           // الضريبة
  final double? deliveryFee;   // رسوم التوصيل
  final double? subtotal;
  final String? paymentMethod;

  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.orderType,
    required this.orderStatus,
    this.customerId,
    this.customerAddressId,
    this.tableNumber,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.discount,
    this.tax,
    this.deliveryFee,
    required this.createdAt,
    this.subtotal,
    this.paymentMethod,
    this.customerArea,
    this.driverName,  // فقط اسم المندوب
  });

  // دالة لإنشاء أوردر جديد فارغ
  factory OrderModel.empty() {
    return OrderModel(
      id: '',
      orderNumber: 0,
      items: [],
      totalAmount: 0.0,
      orderType: OrderType.takeAway,
      orderStatus: OrderStatus.holding,
      createdAt: DateTime.now(),
    );
  }

  // دالة copyWith
  OrderModel copyWith({
    String? id,
    int? orderNumber,
    List<Map<String, dynamic>>? items,
    double? totalAmount,
    OrderType? orderType,
    OrderStatus? orderStatus,
    String? tableNumber,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    int? customerId,
    int? customerAddressId,
    double? discount,
    double? tax,
    double? deliveryFee,
    double? subtotal,
    String? paymentMethod,
    String? customerArea,
    String? driverName,  // فقط اسم المندوب
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      orderType: orderType ?? this.orderType,
      orderStatus: orderStatus ?? this.orderStatus,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      createdAt: this.createdAt,
      customerId: customerId ?? this.customerId,
      customerAddressId: customerAddressId ?? this.customerAddressId,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      subtotal: subtotal ?? this.subtotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerArea: customerArea ?? this.customerArea,
      driverName: driverName ?? this.driverName,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      orderNumber: map['order_number'] ?? 0,
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      orderType: OrderType.values[map['orderType'] ?? 0],
      orderStatus: OrderStatus.values[map['orderStatus'] ?? 0],
      tableNumber: map['tableNumber'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerAddress: map['customerAddress'],
      createdAt: DateTime.parse(map['createdAt']),
      customerId: map['customerId'] as int?,
      customerAddressId: map['customerAddressId'] as int?,
      discount: map['discount']?.toDouble(),
      tax: map['tax']?.toDouble(),
      deliveryFee: map['deliveryFee']?.toDouble(),
      subtotal: map['subtotal']?.toDouble(),
      paymentMethod: map['paymentMethod'],
      customerArea: map['customerArea'],
      driverName: map['driverName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'items': items,
      'totalAmount': totalAmount,
      'orderType': orderType.index,
      'orderStatus': orderStatus.index,
      'tableNumber': tableNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'createdAt': createdAt.toIso8601String(),
      'customerId': customerId,
      'customerAddressId': customerAddressId,
      'discount': discount,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'subtotal': subtotal,
      'paymentMethod': paymentMethod,
      'customerArea': customerArea,
      'driverName': driverName,
    };
  }
}