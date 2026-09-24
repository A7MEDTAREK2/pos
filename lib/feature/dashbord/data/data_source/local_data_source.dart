import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/dash_model.dart';
import '../model/low_stock_model.dart';
import '../model/order_type_model.dart';
import '../model/payment_method_model.dart';
import '../model/recent_sale_model.dart';
import '../model/sales_chart_model.dart';
import '../model/top_product_model.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardModel> getDashboardSummary({
    required DateTime from,
    required DateTime to,
  });

  Future<List<SalesChartModel>> getSalesChart({
    required DateTime from,
    required DateTime to,
  });

  Future<List<TopProductModel>> getTopProducts({
    required DateTime from,
    required DateTime to,
    int limit = 5,
  });

  Future<List<RecentSaleModel>> getRecentSales({
    required DateTime from,
    required DateTime to,
    int limit = 10,
  });

  Future<List<PaymentMethodModel>> getPaymentMethods({
    required DateTime from,
    required DateTime to,
  });

  Future<List<OrderTypeModel>> getOrderTypes({
    required DateTime from,
    required DateTime to,
  });

  Future<List<LowStockModel>> getLowStockProducts({
    int limit = 10,
  });
}

class DashboardLocalDataSourceImpl
    implements DashboardLocalDataSource {
  final Future<Database> _database =
      AppDatabase.instance.database;

  //========================================================
  // Dashboard Summary
  //========================================================

  @override
  Future<DashboardModel> getDashboardSummary({
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _database;

    final summaryResult = await db.rawQuery(
      '''
SELECT
COUNT(*) AS total_orders,
IFNULL(SUM(subtotal), 0) AS total_sales,
IFNULL(AVG(subtotal), 0) AS average_order
FROM sales
WHERE DATE(created_at)
BETWEEN DATE(?) AND DATE(?)
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );

    final summary = summaryResult.first;

    final totalOrders = (summary['total_orders'] as num).toInt();

    final totalSales =
        (summary['total_sales'] as num?)?.toDouble() ?? 0;

    final averageOrder =
        (summary['average_order'] as num?)?.toDouble() ?? 0;

    final profitResult = await db.rawQuery('''
SELECT
IFNULL(
SUM((si.price - p.cost_price) * si.quantity),
0
) AS total_profit
FROM sale_items si
INNER JOIN sales s
ON si.sale_id = s.id
INNER JOIN products p
ON si.product_id = p.id
WHERE DATE(s.created_at)
BETWEEN DATE(?) AND DATE(?)
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );

    final totalProfit =
        (profitResult.first['total_profit'] as num?)?.toDouble() ?? 0;

    final customers = await db.rawQuery(
        "SELECT COUNT(*) total FROM customers");

    final products = await db.rawQuery(
        "SELECT COUNT(*) total FROM products");

    return DashboardModel(
      totalSales: totalSales,
      totalProfit: totalProfit,
      totalOrders: totalOrders,
      averageOrder: averageOrder,
      totalCustomers: (customers.first["total"] as num).toInt(),
      totalProducts: (products.first["total"] as num).toInt(),

      salesChart: [],
      topProducts: [],
      recentSales: [],
      paymentMethods: [],
      orderTypes: [],
      lowStockProducts: [],
    );
  }

  //========================================================
  // Sales Chart
  //========================================================

  @override
  Future<List<SalesChartModel>> getSalesChart({
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _database;

    final result = await db.rawQuery(
      '''
SELECT
DATE(created_at) AS day,
SUM(subtotal) AS total
FROM sales
WHERE DATE(created_at)
BETWEEN DATE(?) AND DATE(?)
GROUP BY DATE(created_at)
ORDER BY DATE(created_at)
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
    );

    return result
        .map(
          (e) => SalesChartModel(
        label: e["day"].toString(),
        amount: (e["total"] as num).toDouble(),
      ),
    )
        .toList();
  }

  //========================================================
  // Top Products
  //========================================================

  @override
  Future<List<TopProductModel>> getTopProducts({
    required DateTime from,
    required DateTime to,
    int limit = 5,
  }) async {
    final db = await _database;

    final result = await db.rawQuery(
      '''
SELECT
si.product_name,
SUM(si.quantity) qty,
SUM(si.total) total
FROM sale_items si
INNER JOIN sales s
ON si.sale_id = s.id
WHERE DATE(s.created_at)
BETWEEN DATE(?) AND DATE(?)
GROUP BY si.product_id
ORDER BY qty DESC
LIMIT ?
''',
      [
        from.toIso8601String(),
        to.toIso8601String(),
        limit,
      ],
    );

    return result
        .map(
          (e) => TopProductModel(
        name: e["product_name"].toString(),
        quantity: (e["qty"] as num).toInt(),
        total: (e["total"] as num).toDouble(),
      ),
    )
        .toList();
  }

  //========================================================
  // Recent Sales
  //========================================================

  @override
  Future<List<RecentSaleModel>> getRecentSales({
    required DateTime from,
    required DateTime to,
    int limit = 10,
  }) async {
    final db = await _database;

    final result = await db.query(
      "sales",
      where: "DATE(created_at) BETWEEN DATE(?) AND DATE(?)",
      whereArgs: [
        from.toIso8601String(),
        to.toIso8601String(),
      ],
      orderBy: "created_at DESC",
      limit: limit,
    );
    return result
        .map(
          (e) => RecentSaleModel(
        orderNumber: e["order_number"] as int,
        customerName: e["customer_name"]?.toString() ?? "عميل نقدي",
        total: (e["total"] as num).toDouble(),
        paymentMethod: e["payment_method"].toString(),
      ),
    )
        .toList();
  }

  //========================================================
  // Payment Methods
  //========================================================

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods({
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _database;

    final result = await db.rawQuery('''
SELECT
payment_method,
COUNT(*) count,
SUM(subtotal) total
FROM sales
WHERE DATE(created_at)
BETWEEN DATE(?) AND DATE(?)
GROUP BY payment_method
ORDER BY total DESC
''', [
      from.toIso8601String(),
      to.toIso8601String(),
    ]);

    return result.map((e) {
      return PaymentMethodModel(
        method: e["payment_method"].toString(),
        count: (e["count"] as num).toInt(),
        total: (e["total"] as num).toDouble(),
      );
    }).toList();
  }

  //========================================================
  // Order Types
  //========================================================

  @override
  Future<List<OrderTypeModel>> getOrderTypes({
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _database;

    final result = await db.rawQuery('''
SELECT
order_type,
COUNT(*) total
FROM sales
WHERE DATE(created_at)
BETWEEN DATE(?) AND DATE(?)
GROUP BY order_type
''', [
      from.toIso8601String(),
      to.toIso8601String(),
    ]);

    return result.map((e) {
      final orderType = (e["order_type"] as num).toInt();

      String type;
      switch (orderType) {
        case 0:
          type = "تيك أواي";
          break;
        case 1:
          type = "داخل المطعم";
          break;
        case 2:
          type = "دليفري";
          break;
        default:
          type = "غير معروف";
      }

      return OrderTypeModel(
        type: type,
        count: (e["total"] as num).toInt(),
      );
    }).toList();
  }

  //========================================================
  // Low Stock
  //========================================================

  @override
  Future<List<LowStockModel>> getLowStockProducts({
    int limit = 10,
  }) async {
    final db = await _database;

    final result = await db.query(
      "products",
      where: "quantity <= ?",
      whereArgs: [10],
      orderBy: "quantity ASC",
      limit: limit,
    );

    return result
        .map(
          (e) => LowStockModel(
        name: e["name"].toString(),
        quantity: e["quantity"] as int,
      ),
    )
        .toList();
  }
}