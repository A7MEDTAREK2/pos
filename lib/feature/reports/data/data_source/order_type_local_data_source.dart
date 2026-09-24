import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/order_type_report.dart';

abstract class OrderTypeReportLocalDataSource {
  Future<List<OrderTypeReportModel>> getOrderTypeReport({
    required DateTime from,
    required DateTime to,
  });
}

class OrderTypeReportLocalDataSourceImpl
    implements OrderTypeReportLocalDataSource {

  @override
  Future<List<OrderTypeReportModel>> getOrderTypeReport({
    required DateTime from,
    required DateTime to,
  }) async {

    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT
          order_type AS orderType,
          COUNT(*) AS ordersCount,
          COALESCE(SUM(subtotal), 0) AS totalRevenue,          -- ✅ صافي المنتجات فقط بدون الدليفري
          COALESCE(SUM(delivery_fee), 0) AS totalDeliveryFees,  -- ✅ إجمالي رسوم الدليفري وحدها
          0 AS percentage
      FROM sales
      WHERE DATE(created_at) BETWEEN DATE(?) AND DATE(?)
      GROUP BY order_type
      ORDER BY ordersCount DESC
      ''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );

    return result
        .map((e) => OrderTypeReportModel.fromMap(e))
        .toList();
  }
}