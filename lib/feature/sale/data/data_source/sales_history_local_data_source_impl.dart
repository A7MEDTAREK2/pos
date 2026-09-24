// lib/feature/sales_history/data/data_source/sales_history_local_data_source_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/data_base/pos_database.dart';
import 'local_data_source.dart';
import '../../../cashier/data/data_source/local_data_source.dart';
import '../../../cashier/data/model/pos_model.dart';

class SalesHistoryLocalDataSourceImpl implements SalesHistoryLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await _database;
    return await db.query('sales', orderBy: 'created_at DESC');
  }

  @override
  Future<List<Map<String, dynamic>>> searchSales(String keyword) async {
    final db = await _database;
    final search = keyword.trim().toLowerCase();

    int? orderType;

    if (search == "takeaway" || search == "take away" || search == "سفري") {
      orderType = 0;
    } else if (search == "dinein" || search == "dine in" || search == "صالة") {
      orderType = 1;
    } else if (search == "delivery" || search == "دليفري") {
      orderType = 2;
    }

    return await db.query(
      'sales',
      where: '''
      CAST(order_number AS TEXT) LIKE ?
      OR LOWER(IFNULL(customer_name,'')) LIKE ?
      OR LOWER(IFNULL(customer_phone,'')) LIKE ?
      OR LOWER(IFNULL(payment_method,'')) LIKE ?
      ${orderType != null ? 'OR order_type = ?' : ''}
    ''',
      whereArgs: [
        '%$search%',
        '%$search%',
        '%$search%',
        '%$search%',
        if (orderType != null) orderType,
      ],
      orderBy: 'created_at DESC',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getSaleItems(int saleId) async {
    final db = await _database;
    return await db.query(
      'sale_items',
      where: 'sale_id = ?',
      whereArgs: [saleId],
    );
  }

  @override
  Future<void> deleteSale(int saleId) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.delete('sale_items', where: 'sale_id = ?', whereArgs: [saleId]);
      await txn.delete('sales', where: 'id = ?', whereArgs: [saleId]);
    });
  }

  // إعادة فتح الأوردر ونقله إلى جدول الطلبات المعلقة مع الحفاظ على قيم التوصيل والصافي
  @override
  Future<void> reopenOrder(int saleId) async {
    final db = await _database;

    await db.transaction((txn) async {
      final sales = await txn.query(
        'sales',
        where: 'id = ?',
        whereArgs: [saleId],
      );

      if (sales.isEmpty) {
        throw Exception("Sale Not Found");
      }

      final sale = sales.first;

      final items = await txn.query(
        'sale_items',
        where: 'sale_id = ?',
        whereArgs: [saleId],
      );

      final order = OrderModel(
        id: const Uuid().v4(),
        orderNumber: sale['order_number'] as int,
        items: items
            .map(
              (item) => {
            'productId': item['product_id'].toString(),
            'name': item['product_name'],
            'quantity': item['quantity'],
            'price': (item['price'] as num).toDouble(),
            'image': null,
            'note': item['note'] ?? '',
            'size': item['size_name'],
          },
        )
            .toList(),
        totalAmount: (sale['total'] as num).toDouble(),
        orderType: OrderType.values[sale['order_type'] as int],
        orderStatus: OrderStatus.holding,
        customerId: sale['customer_id'] as int?,
        customerAddressId: sale['customer_address_id'] as int?,
        customerName: sale['customer_name'] as String?,
        customerPhone: sale['customer_phone'] as String?,
        customerAddress: sale['customer_address']?.toString(),
        createdAt: DateTime.now(),
      );

      // حفظ الأوردر في جدول الطلبات المعلقة مع تمرير الصافي ورسوم التوصيل
      await txn.insert(
        'holding_orders',
        {
          'id': order.id,
          'order_number': order.orderNumber,
          'customer_id': order.customerId,
          'customer_address_id': order.customerAddressId,
          'customer_name': order.customerName,
          'customer_phone': order.customerPhone,
          'customer_address': order.customerAddress,
          'order_type': order.orderType.index,
          'order_status': order.orderStatus.index,
          'subtotal': (sale['subtotal'] as num?)?.toDouble() ?? 0.0,
          'discount': (sale['discount'] as num?)?.toDouble() ?? 0.0,
          'tax': (sale['tax'] as num?)?.toDouble() ?? 0.0,
          'delivery_fee': (sale['delivery_fee'] as num?)?.toDouble() ?? 0.0,
          'total': order.totalAmount,
          'created_at': order.createdAt.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // حفظ أصناف الأوردر المعلق
      for (final item in order.items) {
        await txn.insert(
          'holding_order_items',
          {
            'holding_order_id': order.id,
            'product_id': item['productId'],
            'product_name': item['name'],
            'quantity': item['quantity'],
            'price': item['price'],
            'size_name': item['size'],
            'note': item['note'] ?? '',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // حذف الأوردر القديم من سجل المبيعات نهائياً
      await txn.delete('sale_items', where: 'sale_id = ?', whereArgs: [saleId]);
      await txn.delete('sales', where: 'id = ?', whereArgs: [saleId]);
    });
  }

  @override
  Future<OrderModel> getSaleAsOrder(int saleId) async {
    final db = await _database;

    final saleResult = await db.query(
      'sales',
      where: 'id = ?',
      whereArgs: [saleId],
    );

    if (saleResult.isEmpty) {
      throw Exception("Sale not found");
    }

    final sale = saleResult.first;

    final items = await db.query(
      'sale_items',
      where: 'sale_id = ?',
      whereArgs: [saleId],
    );

    return OrderModel(
      id: saleId.toString(),
      orderNumber: sale['order_number'] as int,
      items: items.map((item) {
        return {
          'productId': item['product_id'],
          'name': item['product_name'],
          'quantity': item['quantity'],
          'price': (item['price'] as num).toDouble(),
          'image': null,
          'note': item['note'] ?? '',
          'size': item['size_name'],
        };
      }).toList(),
      totalAmount: (sale['total'] as num).toDouble(),
      orderType: OrderType.values[sale['order_type'] as int],
      orderStatus: OrderStatus.paid,
      customerId: sale['customer_id'] as int?,
      customerAddressId: sale['customer_address_id'] as int?,
      customerName: sale['customer_name']?.toString(),
      customerPhone: sale['customer_phone']?.toString(),
      customerAddress: sale['customer_address']?.toString(),
      subtotal: (sale['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (sale['discount'] as num?)?.toDouble() ?? 0,
      tax: (sale['tax'] as num?)?.toDouble() ?? 0,
      deliveryFee: (sale['delivery_fee'] as num?)?.toDouble() ?? 0,
      paymentMethod: sale['payment_method']?.toString() ?? 'Cash',
      createdAt: DateTime.parse(sale['created_at'].toString()),
    );
  }
}