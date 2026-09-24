import '../../../../core/service/audit_log_service.dart';
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
    final success = id > 0;

    if (success) {
      // 📝 تسجيل حركة إضافة قسم جديد
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'CREATE',
        module: 'الأقسام',
        entityType: 'Category',
        entityId: id.toString(),
        description: 'تم إضافة قسم جديد: ${category.name ?? ""}',
      );
    }

    return success;
  }

  // 3. حذف قسم عن طريق الـ id
  Future<bool> removeCategory(int id) async {
    final rowsAffected = await _dataSource.deleteCategory(id);
    final success = rowsAffected > 0;

    if (success) {
      // 📝 تسجيل حركة حذف قسم
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'DELETE',
        module: 'الأقسام',
        entityType: 'Category',
        entityId: id.toString(),
        description: 'تم حذف القسم برقم: $id',
      );
    }

    return success;
  }

  // تعديل القسم
  Future<bool> updateCategory(CategoryModel category) async {
    final rowsAffected = await _dataSource.updateCategory(category.toMap());
    final success = rowsAffected > 0;

    if (success) {
      // 📝 تسجيل حركة تعديل قسم
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'UPDATE',
        module: 'الأقسام',
        entityType: 'Category',
        entityId: category.id?.toString() ?? '',
        description: 'تم تحديث بيانات القسم: ${category.name ?? ""}',
      );
    }

    return success;
  }

  // جلب كل الأقسام
  Future<List<CategoryModel>> fetchAllCategories() async {
    final rawCategories = await _dataSource.getAllCategories();
    return rawCategories.map((map) => CategoryModel.fromMap(map)).toList();
  }
}