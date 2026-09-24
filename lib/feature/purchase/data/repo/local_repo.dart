import '../datasource/local_data_source.dart';
import '../model/purchase_model.dart';
import '../model/purchase_product_model.dart';

abstract class PurchaseRepository {
  Future<List<PurchaseModel>> getPurchases();

  Future<List<PurchaseProductModel>> getPurchaseProducts();

  Future<List<Map<String, dynamic>>> getSuppliers();

  Future<int> createPurchase(PurchaseModel purchase);

  Future<void> deletePurchase(int purchaseId);

  Future<int> createPurchaseProduct(
      PurchaseProductModel product,
      );

  Future<void> updatePurchaseProduct(
      PurchaseProductModel product,
      );

  Future<void> deletePurchaseProduct(int productId);
}

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource localDataSource;

  PurchaseRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<PurchaseModel>> getPurchases() {
    return localDataSource.getPurchases();
  }

  @override
  Future<List<PurchaseProductModel>> getPurchaseProducts() {
    return localDataSource.getPurchaseProducts();
  }

  @override
  Future<List<Map<String, dynamic>>> getSuppliers() {
    return localDataSource.getSuppliers();
  }

  @override
  Future<int> createPurchase(
      PurchaseModel purchase,
      ) {
    return localDataSource.createPurchase(purchase);
  }

  @override
  Future<void> deletePurchase(int purchaseId) {
    return localDataSource.deletePurchase(purchaseId);
  }

  @override
  Future<int> createPurchaseProduct(
      PurchaseProductModel product,
      ) {
    return localDataSource.createPurchaseProduct(product);
  }

  @override
  Future<void> updatePurchaseProduct(
      PurchaseProductModel product,
      ) {
    return localDataSource.updatePurchaseProduct(product);
  }

  @override
  Future<void> deletePurchaseProduct(int productId) {
    return localDataSource.deletePurchaseProduct(productId);
  }
}