import '../../../../core/data_base/pos_database.dart';
import '../model/payment_report.dart';

abstract class PaymentReportLocalDataSource {
  Future<List<PaymentReportModel>> getPaymentReport({
    required DateTime from,
    required DateTime to,
  });
}

class PaymentReportLocalDataSourceImpl
    implements PaymentReportLocalDataSource {

  @override
  Future<List<PaymentReportModel>> getPaymentReport({
    required DateTime from,
    required DateTime to,
  }) async {

    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT
        payment_method AS paymentMethod,
        COUNT(*) AS ordersCount,
        COALESCE(SUM(subtotal), 0) AS totalRevenue,
        0 AS percentage
      FROM sales
      WHERE DATE(created_at) BETWEEN DATE(?) AND DATE(?)
      GROUP BY payment_method
      ORDER BY totalRevenue DESC
      ''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );

    return result
        .map((e) => PaymentReportModel.fromMap(e))
        .toList();
  }
}