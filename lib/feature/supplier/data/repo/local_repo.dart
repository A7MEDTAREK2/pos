// lib/feature/supplier/data/repo/local_repo.dar
import '../datasource/local_data_source.dart';
import '../model/supplier_model.dart';

class SupplierRepository {
  final SupplierLocalDataSource localDataSource;

  SupplierRepository(this.localDataSource);

  Future<List<SupplierModel>> getSuppliers() {
    return localDataSource.getSuppliers();
  }

  Future<List<SupplierModel>> searchSuppliers(
      String keyword,
      ) {
    return localDataSource.searchSuppliers(keyword);
  }

  Future<int> addSupplier(SupplierModel supplier) {
    return localDataSource.insertSupplier(supplier);
  }

  Future<int> updateSupplier(SupplierModel supplier) {
    return localDataSource.updateSupplier(supplier);
  }

  Future<int> deleteSupplier(int id) {
    return localDataSource.deleteSupplier(id);
  }

  Future<int> toggleSupplierStatus(
      int id,
      bool isActive,
      ) {
    return localDataSource.toggleSupplierStatus(
      id,
      isActive,
    );
  }
}