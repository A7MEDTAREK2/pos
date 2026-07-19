import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/product_report.dart';

abstract class ProductReportLocalDataSource {
  Future<List<ProductReportModel>> getProductReport({
    required DateTime from,
    required DateTime to,
    String search,
    int limit,
    int offset,
  });

  Future<int> getProductReportCount({
    required DateTime from,
    required DateTime to,
    String search,
  });
}

class ProductReportLocalDataSourceImpl
    implements ProductReportLocalDataSource {

  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<List<ProductReportModel>> getProductReport({
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
sale_items.product_id,
sale_items.product_name,
COUNT(sale_items.id) sales_count,
SUM(sale_items.quantity) total_quantity,
SUM(sale_items.total) total_revenue

FROM sale_items

INNER JOIN sales
ON sales.id = sale_items.sale_id

WHERE DATE(sales.created_at)
BETWEEN DATE(?) AND DATE(?)

AND sale_items.product_name LIKE ?

GROUP BY sale_items.product_id,sale_items.product_name

ORDER BY total_revenue DESC

LIMIT ?
OFFSET ?
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
        '%$search%',
        limit,
        offset,
      ],
    );

    return result.map(ProductReportModel.fromMap).toList();
  }

  @override
  Future<int> getProductReportCount({
    required DateTime from,
    required DateTime to,
    String search = '',
  }) async {

    final db = await _database;

    final result = await db.rawQuery(
      '''
SELECT COUNT(*) total
FROM(
SELECT sale_items.product_id
FROM sale_items
INNER JOIN sales
ON sales.id=sale_items.sale_id

WHERE DATE(sales.created_at)
BETWEEN DATE(?) AND DATE(?)

AND sale_items.product_name LIKE ?

GROUP BY sale_items.product_id
)
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
        '%$search%',
      ],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}