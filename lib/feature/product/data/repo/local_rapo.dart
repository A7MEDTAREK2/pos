import '../../../../core/service/audit_log_service.dart';
import '../data_source/local_data_source.dart';
import '../model/product_model.dart';

class ProductRepository {
  final ProductLocalDataSource _dataSource;

  ProductRepository(this._dataSource);

  // إضافة منتج (مع أحجامه لو عنده)
  Future<bool> addProduct(ProductModel product) async {
    final id = await _dataSource.insertProduct(
      product.toMap(),
      sizes: product.sizes,
    );
    final success = id > 0;

    if (success) {
      // 📝 تسجيل حركة إضافة منتج جديد
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'CREATE',
        module: 'المنتجات',
        entityType: 'Product',
        entityId: id.toString(),
        description: 'تم إضافة منتج جديد: ${product.name ?? ""}',
      );
    }

    return success;
  }

  // جلب كل المنتجات وتحويلها لـ List of Models، مع دمج الأحجام
  Future<List<ProductModel>> fetchAllProducts() async {
    final rawProducts = await _dataSource.getAllProducts();
    final allSizes = await _dataSource.getAllProductSizes();

    return rawProducts.map((map) {
      final productId = map['id'] as int;
      return ProductModel.fromMap(map, sizes: allSizes[productId]);
    }).toList();
  }

  // جلب منتجات قسم معين، مع دمج الأحجام
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    final rawProducts = await _dataSource.getProductsByCategory(categoryId);
    final allSizes = await _dataSource.getAllProductSizes();

    return rawProducts.map((map) {
      final productId = map['id'] as int;
      return ProductModel.fromMap(map, sizes: allSizes[productId]);
    }).toList();
  }

  // تعديل منتج (مع تحديث أحجامه)
  Future<bool> updateProduct(ProductModel product) async {
    final rowsAffected = await _dataSource.updateProduct(
      product.toMap(),
      sizes: product.sizes,
    );
    final success = rowsAffected > 0;

    if (success) {
      // 📝 تسجيل حركة تعديل منتج
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'UPDATE',
        module: 'المنتجات',
        entityType: 'Product',
        entityId: product.id?.toString() ?? '',
        description: 'تم تحديث بيانات المنتج: ${product.name ?? ""}',
      );
    }

    return success;
  }

  // حذف منتج
  Future<bool> removeProduct(int id) async {
    final rowsAffected = await _dataSource.deleteProduct(id);
    final success = rowsAffected > 0;

    if (success) {
      // 📝 تسجيل حركة حذف منتج
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'DELETE',
        module: 'المنتجات',
        entityType: 'Product',
        entityId: id.toString(),
        description: 'تم حذف المنتج برقم: $id',
      );
    }

    return success;
  }
}