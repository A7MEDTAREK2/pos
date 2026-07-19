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

    return id > 0;
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
    return rowsAffected > 0;
  }

  // حذف منتج
  Future<bool> removeProduct(int id) async {
    final rowsAffected = await _dataSource.deleteProduct(id);
    return rowsAffected > 0;
  }
}