import 'package:sqflite/sqflite.dart';
import '../../../../core/data_base/pos_database.dart';
import '../model/pos_model.dart';

abstract class OrderLocalDataSource {
  Future<void> increaseOrderCounter();
  Future<void> cacheOrder(OrderModel order);
  Future<void> deleteHoldingOrder(String orderId);
  Future<void> updateHoldingOrder(OrderModel order);
  Future<List<OrderModel>> getHoldingOrders();
  Future<OrderModel?> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<int> getNextOrderNumber();
  Future<void> completeOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<void> cacheOrder(OrderModel order) async {
    final db = await _database;

    await db.transaction((txn) async {
      // 1. حفظ الأوردر الرئيسي في جدول الأوردرات المعلقة مع ربط سعر الدليفري والـ driver_name
      await txn.insert('holding_orders', {
        'id': order.id,
        'order_number': order.orderNumber,
        'customer_id': order.customerId,
        'customer_address_id': order.customerAddressId,
        'user_id': null,
        'subtotal': order.subtotal,
        'discount': order.discount,
        'tax': order.tax,
        'delivery_fee': order.deliveryFee, // حفظ قيمة الدليفري سليمة
        'total': order.totalAmount,
        'payment_method': order.paymentMethod,
        'order_type': order.orderType.index,
        'order_status': order.orderStatus.index,
        'table_number': order.tableNumber,
        'customer_name': order.customerName,
        'customer_phone': order.customerPhone,
        'customer_address': order.customerAddress,
        'driver_name': order.driverName,
        'created_at': order.createdAt.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      // 2. دمج الأصناف المتشابهة لمنع تكرارها في كروت منفصلة
      final Map<String, Map<String, dynamic>> mergedItems = {};
      for (final item in order.items) {
        final String productId = item['productId'].toString();
        final String size = item['size']?.toString() ?? '';
        final String note = item['note']?.toString() ?? '';
        final String key = '${productId}_${size}_$note';

        if (mergedItems.containsKey(key)) {
          final currentQty = (mergedItems[key]!['quantity'] as num).toDouble();
          final addQty = (item['quantity'] as num).toDouble();
          mergedItems[key]!['quantity'] = currentQty + addQty;
        } else {
          mergedItems[key] = Map<String, dynamic>.from(item);
        }
      }

      // 3. حفظ الأصناف بعد دمجها
      for (final item in mergedItems.values) {
        await txn.insert(
          'holding_order_items',
          {
            'holding_order_id': order.id,
            'product_id': item['productId'],
            'product_name': item['name'],
            'quantity': item['quantity'],
            'price': item['price'],
            'image': item['image'],
            'note': item['note'],
            'size_name': item['size'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
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
          deliveryFee: (order['delivery_fee'] as num?)?.toDouble() ?? 0.0, // قراءة سعر الدليفري بضمان تام
          paymentMethod: order['payment_method']?.toString() ?? 'Cash',
          driverName: order['driver_name']?.toString(),
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
      deliveryFee: (order['delivery_fee'] as num?)?.toDouble() ?? 0.0, // قراءة دقيقة لحقل الدليفري
      paymentMethod: order['payment_method']?.toString() ?? 'Cash',
      driverName: order['driver_name']?.toString(),
    );
  }

  @override
  Future<void> completeOrder(OrderModel order) async {
    final db = await _database;

    await db.transaction((txn) async {
      final subtotal = order.items.fold<double>(
        0,
            (sum, item) => sum + ((item['price'] as num).toDouble() * (item['quantity'] as num).toDouble()),
      );

      final discount = order.discount ?? 0.0;
      final tax = order.tax ?? 0.0;
      final deliveryFee = order.deliveryFee ?? 0.0;
      final total = subtotal - discount + tax + deliveryFee;

      final saleId = await txn.insert('sales', {
        'order_number': order.orderNumber,
        'customer_id': order.customerId,
        'customer_address_id': order.customerAddressId,
        'customer_name': order.customerName ?? '',
        'customer_phone': order.customerPhone ?? '',
        'customer_address': order.customerAddress ?? '',
        'driver_name': order.driverName ?? '',
        'user_id': null,
        'order_type': order.orderType.index,
        'subtotal': subtotal,
        'discount': discount,
        'tax': tax,
        'delivery_fee': deliveryFee,
        'total': total,
        'payment_method': order.paymentMethod ?? 'Cash',
        'created_at': order.createdAt.toIso8601String(),
      });

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

      final activeShiftResult = await txn.query(
        'shifts',
        where: 'status = ?',
        whereArgs: ['open'],
        orderBy: 'id DESC',
        limit: 1,
      );

      if (activeShiftResult.isNotEmpty) {
        final shiftId = activeShiftResult.first['id'] as int;

        if (order.paymentMethod == 'Cash' || order.paymentMethod == 'كاش') {
          final cashForDrawer = total - deliveryFee;

          if (cashForDrawer > 0) {
            await txn.insert('cash_transactions', {
              'shift_id': shiftId,
              'user_id': activeShiftResult.first['user_id'],
              'type': 'cash_in',
              'amount': cashForDrawer,
              'reason': 'مبيعات أوردر رقم #${order.orderNumber}',
              'created_at': order.createdAt.toIso8601String(),
            });

            final currentExpected = (activeShiftResult.first['expected_cash'] as num).toDouble();
            await txn.update(
              'shifts',
              {'expected_cash': currentExpected + cashForDrawer},
              where: 'id = ?',
              whereArgs: [shiftId],
            );
          }
        }
      }

      await txn.delete('holding_order_items', where: 'holding_order_id = ?', whereArgs: [order.id]);
      await txn.delete('holding_orders', where: 'id = ?', whereArgs: [order.id]);
    });
  }

  @override
  Future<int> getNextOrderNumber() async {
    final db = await _database;

    // 1. جلب أكبر رقم أوردر من جدول المبيعات (sales)
    final salesResult = await db.rawQuery(
      'SELECT MAX(order_number) as max_order FROM sales',
    );
    int maxSalesOrder = 0;
    if (salesResult.isNotEmpty && salesResult.first['max_order'] != null) {
      maxSalesOrder = salesResult.first['max_order'] as int;
    }

    // 2. جلب أكبر رقم أوردر من جدول الأوردرات المعلقة (holding_orders)
    final holdingResult = await db.rawQuery(
      'SELECT MAX(order_number) as max_order FROM holding_orders',
    );
    int maxHoldingOrder = 0;
    if (holdingResult.isNotEmpty && holdingResult.first['max_order'] != null) {
      maxHoldingOrder = holdingResult.first['max_order'] as int;
    }

    // 3. مقارنة الرقمين واختيار الأعلى ثم إضافة 1
    int currentHighest = maxSalesOrder > maxHoldingOrder ? maxSalesOrder : maxHoldingOrder;

    return currentHighest + 1;
  }

  @override
  Future<void> deleteHoldingOrder(String orderId) async {
    final db = await _database;
    await db.delete('holding_order_items', where: 'holding_order_id = ?', whereArgs: [orderId]);
    await db.delete('holding_orders', where: 'id = ?', whereArgs: [orderId]);
  }

  @override
  Future<void> updateHoldingOrder(OrderModel order) async {
    final db = await _database;

    await db.transaction((txn) async {
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
          'driver_name': order.driverName,
          'subtotal': order.subtotal,
          'discount': order.discount,
          'tax': order.tax,
          'delivery_fee': order.deliveryFee, // تحديث رسوم التوصيل بدقة
          'payment_method': order.paymentMethod,
        },
        where: 'id = ?',
        whereArgs: [order.id],
      );

      await txn.delete('holding_order_items', where: 'holding_order_id = ?', whereArgs: [order.id]);

      // دمج الأصناف المتشابهة عند تحديث الأوردر لمنع تكرار الكروت
      final Map<String, Map<String, dynamic>> mergedItems = {};
      for (final item in order.items) {
        final String productId = item['productId'].toString();
        final String size = item['size']?.toString() ?? '';
        final String note = item['note']?.toString() ?? '';
        final String key = '${productId}_${size}_$note';

        if (mergedItems.containsKey(key)) {
          final currentQty = (mergedItems[key]!['quantity'] as num).toDouble();
          final addQty = (item['quantity'] as num).toDouble();
          mergedItems[key]!['quantity'] = currentQty + addQty;
        } else {
          mergedItems[key] = Map<String, dynamic>.from(item);
        }
      }

      for (final item in mergedItems.values) {
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

  @override
  Future<void> increaseOrderCounter() async {
    // تم إلغاء الاعتماد عليها لضمان عدم حدوث أي لخبطة، والاعتماد بالكامل على MAX(order_number)
  }
}