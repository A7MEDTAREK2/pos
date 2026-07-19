import '../../../../core/data_base/pos_database.dart'; // مسار ملف قاعدة البيانات

class HomeLocalDataSource {
  final AppDatabase _dbInstance = AppDatabase.instance;

  Future<Map<String, dynamic>> getRawMetrics() async {
    final db = await _dbInstance.database;
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);

    final salesResult = await db.rawQuery('''
      SELECT SUM(total) as total_sales, COUNT(id) as invoice_count 
      FROM sales WHERE created_at LIKE '$todayStr%'
    ''');

    final productsResult = await db.rawQuery('SELECT COUNT(id) as total_products FROM products');
    final customersResult = await db.rawQuery('SELECT COUNT(id) as total_customers FROM customers');

    return {
      'today_sales': salesResult.first['total_sales'],
      'invoice_count': salesResult.first['invoice_count'],
      'total_products': productsResult.first['total_products'],
      'total_customers': customersResult.first['total_customers'],
    };
  }
}