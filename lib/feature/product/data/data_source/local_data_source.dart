import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../model/product_model.dart';

class ProductLocalDataSource {
  final Future<Database> _database;

  ProductLocalDataSource(this._database);

  // ================= Products =================

  // 1. إضافة منتج جديد (مع أحجامه لو موجودة)
  Future<int> insertProduct(
      Map<String, dynamic> productMap, {
        List<ProductSize>? sizes,
      }) async {
    final db = await _database;

    return await db.transaction((txn) async {
      final productId = await txn.insert(
        'products',
        productMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      if (sizes != null && sizes.isNotEmpty) {
        for (final size in sizes) {
          await txn.insert(
            'product_sizes',
            {
              'product_id': productId,
              'size_name': size.sizeName,
              'price': size.price,
            },
          );
        }
      }

      return productId;
    });
  }

  // 2. جلب كل المنتجات
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await _database;

    final data = await db.rawQuery('''
SELECT
  products.*,
  categories.name AS category_name
FROM products
LEFT JOIN categories
ON categories.id = products.category_id
''');

    debugPrint(data.toString());

    return data;
  }

  // 3. جلب المنتجات التابعة لقسم معين
  Future<List<Map<String, dynamic>>> getProductsByCategory(
      int categoryId,
      ) async {
    final db = await _database;

    return await db.rawQuery('''
SELECT
  products.*,
  categories.name AS category_name
FROM products
LEFT JOIN categories
ON categories.id = products.category_id
WHERE products.category_id = ?
''', [categoryId]);
  }

  // 4. تعديل بيانات منتج (مع تحديث أحجامه)
  Future<int> updateProduct(
      Map<String, dynamic> productMap, {
        List<ProductSize>? sizes,
      }) async {
    final db = await _database;

    return await db.transaction((txn) async {
      final rowsAffected = await txn.update(
        'products',
        productMap,
        where: 'id = ?',
        whereArgs: [productMap['id']],
      );

      // نشيل الأحجام القديمة ونحط الجديدة، أبسط من تحديث دقيق لكل صف
      await txn.delete(
        'product_sizes',
        where: 'product_id = ?',
        whereArgs: [productMap['id']],
      );

      if (sizes != null && sizes.isNotEmpty) {
        for (final size in sizes) {
          await txn.insert(
            'product_sizes',
            {
              'product_id': productMap['id'],
              'size_name': size.sizeName,
              'price': size.price,
            },
          );
        }
      }

      return rowsAffected;
    });
  }

  // 5. حذف منتج نهائياً (الأحجام بتتشال تلقائيًا بفضل ON DELETE CASCADE)
  Future<int> deleteProduct(int id) async {
    final db = await _database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ================= Product Sizes =================

  // جلب أحجام منتج معين
  Future<List<ProductSize>> getSizesForProduct(int productId) async {
    final db = await _database;

    final data = await db.query(
      'product_sizes',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    return data.map((map) => ProductSize.fromMap(map)).toList();
  }

  // جلب أحجام كل المنتجات دفعة واحدة (أسرع من استعلام منفصل لكل منتج)
  Future<Map<int, List<ProductSize>>> getAllProductSizes() async {
    final db = await _database;

    final data = await db.query('product_sizes');

    final Map<int, List<ProductSize>> result = {};

    for (final row in data) {
      final size = ProductSize.fromMap(row);
      final productId = row['product_id'] as int;

      result.putIfAbsent(productId, () => []).add(size);
    }

    return result;
  }
}