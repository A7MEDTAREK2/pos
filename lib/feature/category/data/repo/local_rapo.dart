import '../data_source/local_data_source.dart';
import '../model/category_model.dart';

class CategoryRepository {
  final CategoryLocalDataSource _dataSource;

  CategoryRepository(this._dataSource);

  // 1. جلب الأقسام وتحويلها إلى Objects (List of CategoryModel)
  Future<List<CategoryModel>> getCategories() async {
    final rawCategories = await _dataSource.getAllCategories();
    return rawCategories.map((map) => CategoryModel.fromMap(map)).toList();
  }

  // 2. إضافة قسم جديد
  Future<bool> addCategory(CategoryModel category) async {
    final id = await _dataSource.insertCategory(category.toMap());
    return id > 0; // لو الـ id أكبر من صفر يبقى الإدخال تم بنجاح
  }

  // 3. حذف قسم عن طريق الـ id
  Future<bool> removeCategory(int id) async {
    final rowsAffected = await _dataSource.deleteCategory(id);
    return rowsAffected > 0; // لو تم حذف صفوف يبقى العملية نجحت
  }

  // تعديل القسم
  Future<bool> updateCategory(CategoryModel category) async {
    final rowsAffected = await _dataSource.updateCategory(category.toMap());
    return rowsAffected > 0;
  }
  // جوه ملف category_repo.dart
  Future<List<CategoryModel>> fetchAllCategories() async {
    final rawCategories = await _dataSource.getAllCategories(); // أو أي اسم للدالة اللي بتجيب الداتا من الـ source
    return rawCategories.map((map) => CategoryModel.fromMap(map)).toList();
  }
}