import 'package:sqflite/sqflite.dart';

import '../../../data_base/pos_database.dart';
import '../printing_manager.dart';


class ShiftClosingService {

  final Future<Database> _database =
      AppDatabase.instance.database;


  Future<void> printShiftReport() async {

    final db = await _database;


    // =========================
    // Sales Summary
    // =========================

    final salesResult = await db.rawQuery(
      '''
      SELECT
        COUNT(*) as orders_count,
        SUM(total) as total_sales,
        SUM(IFNULL(discount,0)) as discount,
        SUM(IFNULL(tax,0)) as tax,
        SUM(IFNULL(delivery_fee,0)) as delivery
      FROM sales
      WHERE DATE(created_at) = DATE(?)
      ''',
      [
        DateTime.now().toIso8601String(),
      ],
    );


    final sales = salesResult.first;


    final ordersCount =
        (sales['orders_count'] as int?) ?? 0;


    final total =
        (sales['total_sales'] as num?)?.toDouble() ?? 0;


    final discount =
        (sales['discount'] as num?)?.toDouble() ?? 0;


    final tax =
        (sales['tax'] as num?)?.toDouble() ?? 0;


    final delivery =
        (sales['delivery'] as num?)?.toDouble() ?? 0;



    // =========================
    // Payment Summary
    // =========================

    final paymentResult = await db.rawQuery(
      '''
      SELECT
        payment_method,
        SUM(total) as amount
      FROM sales
      WHERE DATE(created_at) = DATE(?)
      GROUP BY payment_method
      ''',
      [
        DateTime.now().toIso8601String(),
      ],
    );


    final Map<String,double> payments = {};


    for(final row in paymentResult){

      final method =
          row['payment_method']?.toString() ?? "Other";


      final amount =
          (row['amount'] as num?)?.toDouble() ?? 0;


      payments[method] = amount;

    }



    // =========================
    // Products
    // =========================

    final productsResult = await db.rawQuery(
      '''
      SELECT
    si.product_name,
    SUM(si.quantity) AS quantity,
    SUM(si.total) AS total
FROM sale_items si
INNER JOIN sales s
ON s.id = si.sale_id
WHERE DATE(s.created_at) = DATE(?)
GROUP BY si.product_name
ORDER BY quantity DESC
      ''',
      [
        DateTime.now().toIso8601String(),
      ],
    );

    final products =
    productsResult.map((e){

      return {

        "name": e['product_name'],

        "quantitySold":
        e['quantity'],

        "totalSales":
        (e['total'] as num?)?.toDouble() ?? 0,

      };

    }).toList();



    // =========================
    // Print
    // =========================


    await PrintingManager.instance.printDailyReport(

      storeName: "Modu POS",

      cashier: "Admin",

      ordersCount: ordersCount,

      subTotal: total,

      discount: discount,

      tax: tax,

      delivery: delivery,

      netSales: total,

      paymentSummary: payments,

      products: products,

    );

  }
  Future<void> resetShift() async {
    final db = await _database;

    await db.insert(
      'shift_session',
      {
        'id': 1,
        'shift_start': DateTime.now().toIso8601String(),
        'order_counter': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final result = await db.query('shift_session');
    print(result);
  }

}