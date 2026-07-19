import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/stock.dart';

abstract class StockReportLocalDataSource {
  Future<List<StockReportModel>> getStockReport({
    required String search,
    required int limit,
    required int offset,
  });

  Future<int> getStockReportCount({
    required String search,
  });
}

class StockReportLocalDataSourceImpl
    implements StockReportLocalDataSource {

  @override
  Future<List<StockReportModel>> getStockReport({
    required String search,
    required int limit,
    required int offset,
  }) async {

    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery(
      '''
     SELECT
    id AS productId,

    name AS productName,

    '' AS categoryName,

    quantity,

    5 AS minimumQuantity,

    (quantity * cost_price) AS stockValue

FROM products

WHERE name LIKE ?

ORDER BY quantity ASC

LIMIT ?
OFFSET ?
      ''',
      [
        '%$search%',
        limit,
        offset,
      ],
    );

    return result
        .map((e) => StockReportModel.fromMap(e))
        .toList();
  }

  @override
  Future<int> getStockReportCount({
    required String search,
  }) async {

    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total

      FROM products

      WHERE name LIKE ?
      ''',
      [
        '%$search%',
      ],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}