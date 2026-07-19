import 'package:sqflite/sqflite.dart';

class CategoryLocalDataSource {
  final Future<Database> _database;

  CategoryLocalDataSource(this._database);

  // 1. جلب كل الأقسام
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await _database;
    return await db.query('categories', orderBy: 'id DESC');
  }

  // 2. إضافة قسم جديد
  Future<int> insertCategory(Map<String, dynamic> categoryMap) async {
    final db = await _database;
    return await db.insert('categories', categoryMap);
  }

  // 3. حذف قسم
  Future<int> deleteCategory(int id) async {
    final db = await _database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }


  // تعديل اسم قسم موجود بالفعل
  Future<int> updateCategory(Map<String, dynamic> categoryMap) async {
    final db = await _database;
    return await db.update(
      'categories',
      categoryMap,
      where: 'id = ?',
      whereArgs: [categoryMap['id']],
    );
  }
}