import 'package:sqflite/sqflite.dart';
import '../../../../core/data_base/pos_database.dart';
import '../model/pos_model.dart';

abstract class OrderLocalDataSource {
  // حفظ الأوردر كمعلق
  Future<void> cacheOrder(OrderModel order);

  Future<void> deleteHoldingOrder(String orderId);

  Future<void> updateHoldingOrder(OrderModel order);

  // جلب الأوردرات المعلقة
  Future<List<OrderModel>> getHoldingOrders();

  Future<OrderModel?> getOrderById(String orderId);

  // تحديث حالة الأوردر
  Future<void> updateOrderStatus(String orderId, OrderStatus status);

  Future<int> getNextOrderNumber();

  // إتمام البيع (هنكتبها بعدين)
  Future<void> completeOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<void> cacheOrder(OrderModel order) async {
    final db = await _database;


    await db.transaction((txn) async {
      // حفظ الأوردر الرئيسي
      await txn.insert('holding_orders', {
        'id': order.id,
        'order_number': order.orderNumber,
        'customer_id': order.customerId,
        'customer_address_id': order.customerAddressId,
        'user_id': null,

        'subtotal': order.subtotal,
        'discount': order.discount,
        'tax': order.tax,
        'delivery_fee': order.deliveryFee,

        'total': order.totalAmount,
        'payment_method': order.paymentMethod,

        'order_type': order.orderType.index,
        'order_status': order.orderStatus.index,

        'table_number': order.tableNumber,
        'customer_name': order.customerName,
        'customer_phone': order.customerPhone,
        'customer_address': order.customerAddress,
        'created_at': order.createdAt.toIso8601String(),
      });

      // حفظ الأصناف
      for (final item in order.items) {
        await txn.insert('holding_order_items', {
          'holding_order_id': order.id,
          'product_id': item['productId'],
          'product_name': item['name'],
          'quantity': item['quantity'],
          'price': item['price'],
          'image': item['image'],
          'note': item['note'],
          'size_name': item['size'],

        }, conflictAlgorithm: ConflictAlgorithm.replace,
        );

      }

    });
  }

  @override
  Future<List<OrderModel>> getHoldingOrders() async {
    final db = await _database;

    final orders = await db.query('holding_orders', orderBy: 'created_at DESC');

    List<OrderModel> result = [];

    for (final order in orders) {
      final items = await db.query(
        'holding_order_items',
        where: 'holding_order_id = ?',
        whereArgs: [order['id']],
      );

      result.add(
        OrderModel(
          id: order['id'].toString(),
          orderNumber: order['order_number'] as int,
          items: items.map((e) {
            return {
              'productId': e['product_id'],
              'name': e['product_name'],
              'quantity': e['quantity'],
              'price': (e['price'] as num).toDouble(),
              'image': e['image'],
              'note': e['note'] ?? "",
              'size': e['size_name'],
            };
          }).toList(),
          totalAmount: (order['total'] as num).toDouble(),
          orderType: OrderType.values[order['order_type'] as int],
          orderStatus: OrderStatus.values[order['order_status'] as int],
          tableNumber: order['table_number']?.toString(),
          customerName: order['customer_name']?.toString(),
          customerPhone: order['customer_phone']?.toString(),
          customerAddress: order['customer_address']?.toString(),
          createdAt: DateTime.parse(order['created_at'].toString()),
          customerId: order['customer_id'] as int?,
          customerAddressId: order['customer_address_id'] as int?,
          subtotal: (order['subtotal'] as num?)?.toDouble() ?? 0,
          discount: (order['discount'] as num?)?.toDouble() ?? 0,
          tax: (order['tax'] as num?)?.toDouble() ?? 0,
          deliveryFee: (order['delivery_fee'] as num?)?.toDouble() ?? 0,
          paymentMethod: order['payment_method']?.toString() ?? 'Cash',
        ),
      );
    }

    return result;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final db = await _database;

    await db.update(
      'holding_orders',
      {'order_status': status.index},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    final db = await _database;

    final orders = await db.query(
      'holding_orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );

    if (orders.isEmpty) {
      return null;
    }

    final order = orders.first;

    final items = await db.query(
      'holding_order_items',
      where: 'holding_order_id = ?',
      whereArgs: [orderId],
    );

    return OrderModel(
      id: order['id'].toString(),
      orderNumber: order['order_number'] as int,
      items: items.map((e) {
        return {
          'productId': e['product_id'],
          'name': e['product_name'],
          'quantity': e['quantity'],
          'price': (e['price'] as num).toDouble(),
          'image': e['image'],
          'note': e['note'] ?? "",
          'size': e['size_name'],

        };
      }).toList(),
      totalAmount: (order['total'] as num).toDouble(),
      orderType: OrderType.values[order['order_type'] as int],
      orderStatus: OrderStatus.values[order['order_status'] as int],
      tableNumber: order['table_number']?.toString(),
      customerName: order['customer_name']?.toString(),
      customerPhone: order['customer_phone']?.toString(),
      customerAddress: order['customer_address']?.toString(),
      createdAt: DateTime.parse(order['created_at'].toString()),
      customerId: order['customer_id'] as int?,
      customerAddressId: order['customer_address_id'] as int?,
      subtotal: (order['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (order['discount'] as num?)?.toDouble() ?? 0,
      tax: (order['tax'] as num?)?.toDouble() ?? 0,
      deliveryFee: (order['delivery_fee'] as num?)?.toDouble() ?? 0,
      paymentMethod: order['payment_method']?.toString() ?? 'Cash',
    );
  }

  @override
  Future<void> completeOrder(OrderModel order) async {
    print('📊 Order Items: ${order.items}');
    print('📊 Order Discount: ${order.discount}');
    print('📊 Order Tax: ${order.tax}');
    print('📊 Order DeliveryFee: ${order.deliveryFee}');
    print('📊 Payment Method: ${order.paymentMethod}');
    final db = await _database;

    await db.transaction((txn) async {
      // ====== حساب الإجمالي الفرعي ======
      final subtotal = order.items.fold<double>(
        0,
            (sum, item) => sum + ((item['price'] as num).toDouble() * (item['quantity'] as num).toDouble()),
      );

      // ====== حساب الخصم (إذا موجود) ======
      final discount = order.discount ?? 0.0;

      // ====== حساب الضريبة (إذا موجودة) ======
      final tax = order.tax ?? 0.0;

      // ====== رسوم التوصيل (إذا موجودة) ======
      final deliveryFee = order.deliveryFee ?? 0.0;

      // ====== حساب الإجمالي النهائي ======
      final total = subtotal - discount + tax + deliveryFee;
      print("Customer Name: ${order.customerName}");
      print("Customer Phone: ${order.customerPhone}");
      print("Customer Address: ${order.customerAddress}");
      // ====== إنشاء فاتورة بيع ======
      final saleId = await txn.insert('sales', {
        'order_number': order.orderNumber,

        // بيانات العميل
        'customer_id': order.customerId,
        'customer_address_id': order.customerAddressId,
        'customer_name': order.customerName ?? '',
        'customer_phone': order.customerPhone ?? '',
        'customer_address': order.customerAddress ?? '',

        // المستخدم
        'user_id': null,

        // نوع الأوردر
        'order_type': order.orderType.index,

        // الحسابات
        'subtotal': subtotal,
        'discount': discount,
        'tax': tax,
        'delivery_fee': deliveryFee,
        'total': total,

        // طريقة الدفع
        'payment_method': order.paymentMethod ?? 'Cash',

        // التاريخ
        'created_at': order.createdAt.toIso8601String(),
      });

      // ====== حفظ الأصناف ======
      for (final item in order.items) {
        await txn.insert('sale_items', {
          'sale_id': saleId,
          'product_id': item['productId'],
          'product_name': item['name'] ?? '',
          'quantity': item['quantity'],
          'price': item['price'],
          'size_name': item['size'],
          'total': (item['price'] as num).toDouble() * (item['quantity'] as num).toDouble(),
        });
      }

      // ====== خصم الكمية من المخزون ======
      for (final item in order.items) {
        await txn.rawUpdate(
          '''
        UPDATE products
        SET quantity = quantity - ?
        WHERE id = ?
        ''',
          [item['quantity'], item['productId']],
        );
      }

      // ====== حذف أصناف الأوردر المعلق ======
      await txn.delete(
        'holding_order_items',
        where: 'holding_order_id = ?',
        whereArgs: [order.id],
      );

      // ====== حذف الأوردر المعلق ======
      await txn.delete(
        'holding_orders',
        where: 'id = ?',
        whereArgs: [order.id],
      );
    });
  }

  @override
  Future<int> getNextOrderNumber() async {
    final db = await _database;

    final holding = await db.rawQuery(
      'SELECT MAX(order_number) as maxNo FROM holding_orders',
    );

    final sales = await db.rawQuery(
      'SELECT MAX(order_number) as maxNo FROM sales',
    );

    final holdingNo = (holding.first['maxNo'] as int?) ?? 0;
    final salesNo = (sales.first['maxNo'] as int?) ?? 0;

    return (holdingNo > salesNo ? holdingNo : salesNo) + 1;
  }

  @override
  Future<void> deleteHoldingOrder(String orderId) async {
    final db = await _database;

    await db.delete(
      'holding_order_items',
      where: 'holding_order_id = ?',
      whereArgs: [orderId],
    );

    await db.delete('holding_orders', where: 'id = ?', whereArgs: [orderId]);
  }

  @override
  Future<void> updateHoldingOrder(OrderModel order) async {
    final db = await _database;

    await db.transaction((txn) async {
      // تحديث بيانات الأوردر
      await txn.update(
        'holding_orders',
        {
          'total': order.totalAmount,
          'order_type': order.orderType.index,
          'table_number': order.tableNumber,
          'customer_id': order.customerId,
          'customer_address_id': order.customerAddressId,
          'customer_name': order.customerName,
          'customer_phone': order.customerPhone,
          'customer_address': order.customerAddress,
          'subtotal': order.subtotal,
          'discount': order.discount,
          'tax': order.tax,
          'delivery_fee': order.deliveryFee,
          'payment_method': order.paymentMethod,

        },
        where: 'id = ?',
        whereArgs: [order.id],
      );

      // حذف الأصناف القديمة
      await txn.delete(
        'holding_order_items',
        where: 'holding_order_id = ?',
        whereArgs: [order.id],
      );

      // إضافة الأصناف الجديدة
      for (final item in order.items) {
        await txn.insert('holding_order_items', {
          'holding_order_id': order.id,
          'product_id': item['productId'],
          'product_name': item['name'],
          'quantity': item['quantity'],
          'price': item['price'],
          'image': item['image'],
          'note': item['note'],
          'size_name': item['size'],
        });
      }
    });

  }

}

