import 'package:sqflite/sqflite.dart';
import '../../../../core/data_base/pos_database.dart';

import '../model/drive_model.dart';

class DriverReportLocalDataSource {
  Future<List<DriverReportModel>> getDriversReport({
    int limit = 10,
    int offset = 0,
  }) async {
    final db = await AppDatabase.instance.database;

    // استعلام لجلب اسم المندوب، عدد الأوردرات، ومجموع رسوم التوصيل المرتبطة بيه
    final result = await db.rawQuery('''
      SELECT 
        COALESCE(d.name, s.driver_name, 'غير معروف') as driver_name,
        COUNT(s.id) as total_orders,
        SUM(s.delivery_fee) as total_delivery_fees
      FROM sales s
      LEFT JOIN drivers d ON s.driver_id = d.id
      WHERE s.order_type = 2 -- أو الشرط اللي بيحدد إن الطلب توصيل عندك (عدلها حسب نظامك)
      GROUP BY driver_name
      LIMIT ? OFFSET ?
    ''', [limit, offset]);

    return result.map((map) {
      return DriverReportModel(
        driverName: map['driver_name'].toString(),
        totalOrders: int.tryParse(map['total_orders'].toString()) ?? 0,
        totalDeliveryFees: double.tryParse(map['total_delivery_fees'].toString()) ?? 0.0,
      );
    }).toList();
  }

  Future<int> getDriversCount() async {
    final db = await AppDatabase.instance.database;
    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT COALESCE(d.name, s.driver_name)) as count
      FROM sales s
      LEFT JOIN drivers d ON s.driver_id = d.id
      WHERE s.order_type = 1
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}