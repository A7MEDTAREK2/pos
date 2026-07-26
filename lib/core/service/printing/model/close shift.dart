import 'package:sqflite/sqflite.dart';
import '../../../data_base/pos_database.dart';
import '../printing_manager.dart';

class ShiftClosingService {
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
  }

  final Future<Database> _database =
      AppDatabase.instance.database;

  Future<void> printShiftReport() async {
    final db = await _database;

    // ============================
    // Sales Summary
    // ============================

    final salesResult = await db.rawQuery(
      '''
      SELECT
        COUNT(*) AS orders_count,
        SUM(subtotal) AS subtotal,
        SUM(discount) AS discount,
        SUM(tax) AS tax,
        SUM(delivery_fee) AS delivery,
        SUM(total) AS total
      FROM sales
      WHERE DATE(created_at) = DATE(?)
      ''',
      [
        DateTime.now().toIso8601String(),
      ],
    );

    final sale = salesResult.first;

    final ordersCount =
        (sale['orders_count'] as int?) ?? 0;

    final subtotal =
        (sale['subtotal'] as num?)?.toDouble() ?? 0;

    final discount =
        (sale['discount'] as num?)?.toDouble() ?? 0;

    final tax =
        (sale['tax'] as num?)?.toDouble() ?? 0;

    final delivery =
        (sale['delivery'] as num?)?.toDouble() ?? 0;

    final total =
        (sale['total'] as num?)?.toDouble() ?? 0;

    // ============================
    // Payments
    // ============================

    final paymentRows = await db.rawQuery(
      '''
      SELECT
        payment_method,
        SUM(total) AS amount
      FROM sales
      WHERE DATE(created_at) = DATE(?)
      GROUP BY payment_method
      ''',
      [
        DateTime.now().toIso8601String(),
      ],
    );

    final Map<String, double> payments = {};

    for (final row in paymentRows) {
      final method =
          row['payment_method']?.toString() ?? "Other";

      final amount =
          (row['amount'] as num?)?.toDouble() ?? 0;

      payments[method] = amount;
    }

    // ============================
    // Products
    // ============================

    final productRows = await db.rawQuery(
      '''
      SELECT
        sale_items.product_name,
        SUM(sale_items.quantity) AS quantity,
        SUM(sale_items.total) AS total
      FROM sale_items
      INNER JOIN sales
      ON sales.id = sale_items.sale_id
      WHERE DATE(sales.created_at) = DATE(?)
      GROUP BY sale_items.product_name
      ORDER BY quantity DESC
      ''',
      [
        DateTime.now().toIso8601String(),
      ],
    );

    final products = productRows.map((e) {
      return {
        "name": e['product_name'] ?? "",
        "quantity": e['quantity'] ?? 0,
        "total": (e['total'] as num?)?.toDouble() ?? 0,
      };
    }).toList();

    // ============================
    // Print
    // ============================

    await PrintingManager.instance.printDailyReport(
      storeName: "Modu POS",
      cashier: "Admin",
      ordersCount: ordersCount,
      subTotal: subtotal,
      discount: discount,
      tax: tax,
      delivery: delivery,
      netSales: total,
      paymentSummary: payments,
      products: products,
    );
  }
}