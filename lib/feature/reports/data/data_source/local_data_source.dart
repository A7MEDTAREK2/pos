import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../../../../core/service/printing/model/daily_closing_report_model.dart';
import '../model/sale_detail_report.dart';
import '../model/sale_report_model.dart';

abstract class ReportsLocalDataSource {
  Future<List<ShiftProductModel>> getShiftProducts({
    required DateTime from,
    required DateTime to,
  });
  Future<List<SalesReportModel>> getSalesReport({
    required DateTime from,
    required DateTime to,
    String search = '',
    int limit = 20,
    int offset = 0,
  });
  Future<int> getSalesReportCount({
    required DateTime from,
    required DateTime to,
    String search = '',
  });
  Future<SaleDetailsModel?> getSaleDetails(int saleId);
}


class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<List<SalesReportModel>> getSalesReport({
    required DateTime from,
    required DateTime to,
    String search = '',
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await _database;

    final result = await db.rawQuery(
      '''
SELECT
    id,
    order_number,
    customer_name,
    order_type,
    payment_method,
    total,
    created_at
FROM sales

WHERE DATE(created_at)
BETWEEN DATE(?) AND DATE(?)

AND (
    IFNULL(customer_name,'') LIKE ?
    OR CAST(order_number AS TEXT) LIKE ?
)

ORDER BY created_at DESC

LIMIT ?
OFFSET ?
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
        '%$search%',
        '%$search%',
        limit,
        offset,
      ],
    );

    return result
        .map((e) => SalesReportModel.fromMap(e))
        .toList();
  }
  @override
  Future<int> getSalesReportCount({
    required DateTime from,
    required DateTime to,
    String search = '',
  }) async {
    final db = await _database;

    final result = await db.rawQuery(
      '''
SELECT COUNT(*) AS total
FROM sales

WHERE DATE(created_at)
BETWEEN DATE(?) AND DATE(?)

AND (
    IFNULL(customer_name,'') LIKE ?
    OR CAST(order_number AS TEXT) LIKE ?
)
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
        '%$search%',
        '%$search%',
      ],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
  @override
  Future<SaleDetailsModel?> getSaleDetails(int saleId) async {
    final db = await _database;

    final saleResult = await db.query(
      'sales',
      where: 'id=?',
      whereArgs: [saleId],
      limit: 1,
    );

    if (saleResult.isEmpty) return null;

    final itemsResult = await db.query(
      'sale_items',
      where: 'sale_id=?',
      whereArgs: [saleId],
    );

    return SaleDetailsModel(
      saleId: saleResult.first['id'] as int,
      orderNumber: saleResult.first['order_number'] as int,
      customerName: (saleResult.first['customer_name'] ?? '') as String,
      customerPhone: (saleResult.first['customer_phone'] ?? '') as String,
      customerAddress: (saleResult.first['customer_address'] ?? '') as String,
      orderType: saleResult.first['order_type'] as int,
      paymentMethod: saleResult.first['payment_method'] as String,
      subtotal: (saleResult.first['subtotal'] as num).toDouble(),
      discount: (saleResult.first['discount'] as num).toDouble(),
      tax: (saleResult.first['tax'] as num).toDouble(),
      deliveryFee: (saleResult.first['delivery_fee'] as num).toDouble(),
      total: (saleResult.first['total'] as num).toDouble(),
      createdAt: DateTime.parse(
        saleResult.first['created_at'] as String,
      ),
      items: itemsResult
          .map((e) => SaleItemModel.fromMap(e))
          .toList(),
    );
  }

  @override
  Future<List<ShiftProductModel>> getShiftProducts({
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _database;

    final result = await db.rawQuery(
      '''
SELECT
    si.product_name,
    IFNULL(si.size_name,'') AS size_name,
    SUM(si.quantity) AS quantity_sold,
    SUM(si.total) AS total_sales
FROM sale_items si
INNER JOIN sales s
    ON s.id = si.sale_id
WHERE DATETIME(s.created_at)
BETWEEN DATETIME(?) AND DATETIME(?)
GROUP BY
    si.product_name,
    si.size_name
ORDER BY
    quantity_sold DESC,
    total_sales DESC
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );

    return result
        .map((e) => ShiftProductModel.fromMap(e))
        .toList();
  }
}