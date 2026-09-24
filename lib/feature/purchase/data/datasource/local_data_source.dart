import 'package:sqflite/sqflite.dart';

import '../../../../core/data_base/pos_database.dart';
import '../model/purchase_item_model.dart';
import '../model/purchase_model.dart';
import '../model/purchase_product_model.dart';

abstract class PurchaseLocalDataSource {
  Future<List<PurchaseModel>> getPurchases();

  Future<List<PurchaseProductModel>> getPurchaseProducts();

  Future<List<Map<String, dynamic>>> getSuppliers();

  Future<int> createPurchase(PurchaseModel purchase);

  Future<void> deletePurchase(int purchaseId);

  Future<int> createPurchaseProduct(PurchaseProductModel product);

  Future<void> updatePurchaseProduct(PurchaseProductModel product);

  Future<void> deletePurchaseProduct(int productId);
}

class PurchaseLocalDataSourceImpl implements PurchaseLocalDataSource {
  final AppDatabase database;

  PurchaseLocalDataSourceImpl({
    AppDatabase? database,
  }) : database = database ?? AppDatabase.instance;

  // =========================================================
  // Purchases
  // =========================================================

  @override
  Future<List<PurchaseModel>> getPurchases() async {
    final db = await database.database;

    final purchases = await db.query(
      'purchases',
      orderBy: 'created_at DESC, id DESC',
    );

    final result = <PurchaseModel>[];

    for (final purchase in purchases) {
      final items = await db.query(
        'purchase_items',
        where: 'purchase_id = ?',
        whereArgs: [purchase['id']],
      );

      final map = Map<String, dynamic>.from(purchase);
      map['items'] = items;

      result.add(
        PurchaseModel.fromMap(map),
      );
    }

    return result;
  }

  // =========================================================
  // Purchase Products
  // =========================================================

  @override
  Future<List<PurchaseProductModel>> getPurchaseProducts() async {
    final db = await database.database;

    final rows = await db.query(
      'purchase_products',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );

    return rows
        .map(
          (row) => PurchaseProductModel.fromMap(
        Map<String, dynamic>.from(row),
      ),
    )
        .toList();
  }

  @override
  Future<int> createPurchaseProduct(
      PurchaseProductModel product,
      ) async {
    final db = await database.database;

    return db.insert(
      'purchase_products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<void> updatePurchaseProduct(
      PurchaseProductModel product,
      ) async {
    if (product.id == null) {
      throw Exception(
        'لا يمكن تعديل منتج مشتريات بدون ID',
      );
    }

    final db = await database.database;

    await db.update(
      'purchase_products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<void> deletePurchaseProduct(int productId) async {
    final db = await database.database;

    await db.update(
      'purchase_products',
      {
        'is_active': 0,
      },
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // =========================================================
  // Suppliers
  // =========================================================

  @override
  Future<List<Map<String, dynamic>>> getSuppliers() async {
    final db = await database.database;

    return db.query(
      'suppliers',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
  }

  // =========================================================
  // Create Purchase
  // =========================================================

  @override
  Future<int> createPurchase(
      PurchaseModel purchase,
      ) async {
    final db = await database.database;

    return db.transaction<int>((txn) async {
      // -------------------------------------------------------
      // 1. Insert Purchase
      // -------------------------------------------------------

      final purchaseId = await txn.insert(
        'purchases',
        purchase.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      // -------------------------------------------------------
      // 2. Insert Items + Update Purchase Product Stock
      // -------------------------------------------------------

      for (final item in purchase.items) {
        final itemMap = item
            .copyWith(
          purchaseId: purchaseId,
        )
            .toMap();

        await txn.insert(
          'purchase_items',
          itemMap,
          conflictAlgorithm: ConflictAlgorithm.abort,
        );

        // زيادة مخزون منتج المشتريات
        await txn.rawUpdate(
          '''
          UPDATE purchase_products
          SET
            quantity = quantity + ?,
            cost_price = ?
          WHERE id = ?
          ''',
          [
            item.quantity,
            item.costPrice,
            item.purchaseProductId,
          ],
        );
      }

      return purchaseId;
    });
  }

  // =========================================================
  // Delete Purchase
  // =========================================================

  @override
  Future<void> deletePurchase(int purchaseId) async {
    final db = await database.database;

    await db.transaction((txn) async {
      // -------------------------------------------------------
      // Get Purchase Items
      // -------------------------------------------------------

      final items = await txn.query(
        'purchase_items',
        where: 'purchase_id = ?',
        whereArgs: [purchaseId],
      );

      // -------------------------------------------------------
      // Reverse Stock Safely
      // -------------------------------------------------------

      for (final row in items) {
        // قراءة آمنة لـ ID المادة والكمية بدعم المسميين وتجنب Null
        final purchaseProductId =
        ((row['purchase_product_id'] ?? row['product_id']) as num?)
            ?.toInt();

        final quantity = (row['quantity'] as num?)?.toInt() ?? 0;

        if (purchaseProductId != null && quantity > 0) {
          await txn.rawUpdate(
            '''
            UPDATE purchase_products
            SET quantity = quantity - ?
            WHERE id = ?
            ''',
            [
              quantity,
              purchaseProductId,
            ],
          );
        }
      }

      // -------------------------------------------------------
      // Delete Items
      // -------------------------------------------------------

      await txn.delete(
        'purchase_items',
        where: 'purchase_id = ?',
        whereArgs: [purchaseId],
      );

      // -------------------------------------------------------
      // Delete Purchase
      // -------------------------------------------------------

      await txn.delete(
        'purchases',
        where: 'id = ?',
        whereArgs: [purchaseId],
      );
    });
  }
}