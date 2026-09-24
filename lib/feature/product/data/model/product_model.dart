enum OrderStatus { holding, paid }

enum OrderType { takeAway, dineIn, delivery }

class OrderModel {
  final String id;
  final int orderNumber;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final OrderType orderType;
  final OrderStatus orderStatus;

  // البيانات الإضافية التي نحتاجها
  final String? tableNumber;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;

  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.orderType,
    required this.orderStatus,
    this.tableNumber,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    required this.createdAt,
  });

  // دالة لإنشاء أوردر جديد فارغ (للبدء من الصفر)
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

  // دالة copyWith لتحديث بيانات الأوردر الحالي بسهولة (Immutability)
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
    };
  }
}

// ✅ موديل حجم المنتج (صغير / وسط / كبير ... إلخ)
class ProductSize {
  final int? id;
  final int? productId;
  final String sizeName;
  final double price;

  ProductSize({
    this.id,
    this.productId,
    required this.sizeName,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'size_name': sizeName,
      'price': price,
    };
  }

  factory ProductSize.fromMap(Map<String, dynamic> map) {
    return ProductSize(
      id: map['id'] as int?,
      productId: map['product_id'] as int?,
      sizeName: map['size_name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  ProductSize copyWith({
    int? id,
    int? productId,
    String? sizeName,
    double? price,
  }) {
    return ProductSize(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sizeName: sizeName ?? this.sizeName,
      price: price ?? this.price,
    );
  }
}

// ✅ موديل المنتج المحدث مع دعم الحد الأدنى للمخزون (minimumStock)
class ProductModel {
  final int? id;
  final String? barcode;
  final String name;
  final double? costPrice;
  final double? sellPrice;
  final int quantity;
  final double minimumStock; // ✅ حقل الحد الأدنى للمخزون
  final int? categoryId;
  final String? image;
  final String createdAt;
  final String? categoryName;

  final List<ProductSize>? sizes;

  ProductModel({
    this.id,
    this.barcode,
    required this.name,
    required this.costPrice,
    required this.sellPrice,
    this.quantity = 0,
    this.minimumStock = 0.0,
    this.categoryId,
    this.image,
    required this.createdAt,
    this.sizes,
    this.categoryName,
  });

  bool get hasSizes => sizes != null && sizes!.isNotEmpty;

  double get displayPrice {
    if (hasSizes) {
      return sizes!.map((s) => s.price).reduce((a, b) => a < b ? a : b);
    }
    return sellPrice ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': (barcode == null || barcode!.isEmpty) ? null : barcode,
      'name': name,
      'cost_price': costPrice,
      'sell_price': sellPrice,
      'quantity': quantity,
      'minimum_stock': minimumStock, // ✅ إضافته للـ Map
      'category_id': categoryId,
      'image': image,
      'created_at': createdAt,
    };
  }

  factory ProductModel.fromMap(
      Map<String, dynamic> map, {
        List<ProductSize>? sizes,
      }) {
    return ProductModel(
      id: map['id'] as int?,
      barcode: map['barcode'] as String?,
      name: map['name'] as String,
      costPrice: (map['cost_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] as int? ?? 0,
      minimumStock: (map['minimum_stock'] as num?)?.toDouble() ?? 0.0, // ✅ قراءته من قاعدة البيانات
      categoryId: map['category_id'] as int?,
      image: map['image'] as String?,
      createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
      sizes: sizes,
      categoryName: map['category_name'] as String?,
    );
  }

  ProductModel copyWith({
    int? id,
    String? barcode,
    String? name,
    double? costPrice,
    double? sellPrice,
    int? quantity,
    double? minimumStock,
    int? categoryId,
    String? image,
    String? createdAt,
    List<ProductSize>? sizes,
    String? categoryName,
  }) {
    return ProductModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      sizes: sizes ?? this.sizes,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}