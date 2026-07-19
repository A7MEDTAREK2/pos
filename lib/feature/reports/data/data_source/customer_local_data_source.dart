import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/customer.dart';

abstract class CustomerReportLocalDataSource {
  Future<List<CustomerReportModel>> getCustomerReport({
    required DateTime from,
    required DateTime to,
    required String search,
    required int limit,
    required int offset,
  });

  Future<int> getCustomerReportCount({
    required DateTime from,
    required DateTime to,
    required String search,
  });
}

class CustomerReportLocalDataSourceImpl
    implements CustomerReportLocalDataSource {

  @override
  Future<List<CustomerReportModel>> getCustomerReport({
    required DateTime from,
    required DateTime to,
    required String search,
    required int limit,
    required int offset,
  }) async {

    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery(
      '''
     SELECT
    c.id AS customerId,
    c.name AS customerName,
    c.phone,

    COUNT(DISTINCT s.id) AS ordersCount,

    COALESCE(SUM(s.total),0) AS totalSpent,

    COALESCE(AVG(s.total),0) AS averageOrder,

    MAX(s.created_at) AS lastOrderDate,

    COALESCE(SUM(s.total),0) AS totalPurchases,

    COALESCE(MAX(s.created_at),'') AS lastPurchase

FROM customers c

LEFT JOIN sales s
ON s.customer_id = c.id
AND DATE(s.created_at)
BETWEEN DATE(?) AND DATE(?)

WHERE
c.name LIKE ?
OR c.phone LIKE ?

GROUP BY c.id

ORDER BY totalSpent DESC

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
        .map((e) => CustomerReportModel.fromMap(e))
        .toList();
  }

  @override
  Future<int> getCustomerReportCount({
    required DateTime from,
    required DateTime to,
    required String search,
  }) async {

    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total

      FROM customers

      WHERE
      name LIKE ?
      OR phone LIKE ?
      ''',
      [
        '%$search%',
        '%$search%',
      ],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}