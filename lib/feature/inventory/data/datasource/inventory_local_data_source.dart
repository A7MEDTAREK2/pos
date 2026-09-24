import 'package:sqflite/sqflite.dart';
import '../../../../core/data_base/pos_database.dart';
import '../model/inventory_movement_model.dart';
import '../model/stock_item_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<StockItemModel>> getStockItems({
    String search = '',
    int limit = 20,
    int offset = 0,
  });

  Future<int> getStockItemsCount({String search = ''});

  Future<List<StockItemModel>> getLowStockItems();

  Future<void> updateStockQuantity({
    required int productId,
    required double newQuantity,
    required String reason,
    String? note,
    int? userId,
  });

  Future<int> addInventoryMovement(InventoryMovementModel movement);

  Future<List<InventoryMovementModel>> getInventoryMovements({
    required DateTime from,
    required DateTime to,
    int? productId,
    String? movementType,
    int limit = 50,
    int offset = 0,
  });
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Future<Database> _database = AppDatabase.instance.database;

  @override
  Future<List<StockItemModel>> getStockItems({
    String search = '',
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await _database;
    final result = await db.rawQuery('''
      SELECT p.id, p.name, p.barcode, p.quantity, p.minimum_stock, p.cost_price, p.sell_price, c.name as category_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      WHERE p.name LIKE ? OR IFNULL(p.barcode, '') LIKE ?
      ORDER BY p.name ASC
      LIMIT ? OFFSET ?
    ''', ['%$search%', '%$search%', limit, offset]);

    return result.map((e) => StockItemModel.fromMap(e)).toList();
  }

  @override
  Future<int> getStockItemsCount({String search = ''}) async {
    final db = await _database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total FROM products
      WHERE name LIKE ? OR IFNULL(barcode, '') LIKE ?
    ''', ['%$search%', '%$search%']);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<List<StockItemModel>> getLowStockItems() async {
    final db = await _database;
    final result = await db.rawQuery('''
      SELECT p.id, p.name, p.barcode, p.quantity, p.minimum_stock, p.cost_price, p.sell_price, c.name as category_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      WHERE p.quantity <= p.minimum_stock AND p.minimum_stock > 0
      ORDER BY p.quantity ASC
    ''');


    return result.map((e) => StockItemModel.fromMap(e)).toList();
  }

  @override
  Future<void> updateStockQuantity({
    required int productId,
    required double newQuantity,
    required String reason,
    String? note,
    int? userId,
  }) async {
    final db = await _database;
    await db.transaction((txn) async {
      // 1. جلب الكمية الحالية لحساب الفرق
      final currentRes = await txn.query('products', columns: ['quantity'], where: 'id = ?', whereArgs: [productId]);
      if (currentRes.isEmpty) return;
      final double currentQty = (currentRes.first['quantity'] as num).toDouble();
      final double diff = newQuantity - currentQty;

      // 2. تحديث الكمية في الجدول الرئيسي
      await txn.update(
        'products',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [productId],
      );

      // 3. تسديل حركة المخزون
      final String movementType = diff >= 0 ? 'in' : 'out';
      await txn.insert('inventory_movements', {
        'product_id': productId,
        'product_type': 'product',
        'quantity': diff,
        'movement_type': movementType,
        'reason': reason,
        'note': note ?? 'تعديل يدوي للمخزون',
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
  }

  @override
  Future<int> addInventoryMovement(InventoryMovementModel movement) async {
    final db = await _database;
    return await db.insert('inventory_movements', movement.toMap());
  }

  @override
  Future<List<InventoryMovementModel>> getInventoryMovements({
    required DateTime from,
    required DateTime to,
    int? productId,
    String? movementType,
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _database;
    String whereClause = 'DATETIME(m.created_at) BETWEEN DATETIME(?) AND DATETIME(?)';
    List<dynamic> args = [from.toIso8601String(), to.toIso8601String()];

    if (productId != null) {
      whereClause += ' AND m.product_id = ?';
      args.add(productId);
    }
    if (movementType != null) {
      whereClause += ' AND m.movement_type = ?';
      args.add(movementType);
    }

    args.addAll([limit, offset]);

    final result = await db.rawQuery('''
      SELECT m.*, p.name as product_name
      FROM inventory_movements m
      LEFT JOIN products p ON m.product_id = p.id
      WHERE $whereClause
      ORDER BY m.created_at DESC
      LIMIT ? OFFSET ?
    ''', args);

    return result.map((e) => InventoryMovementModel.fromMap(e)).toList();
  }
}