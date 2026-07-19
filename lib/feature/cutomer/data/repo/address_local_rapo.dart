
import '../data_source/address_local_data_source.dart';
import '../model/customer_model.dart';

class CustomerAddressRepository {
  final CustomerAddressLocalDataSource localDataSource;

  CustomerAddressRepository(this.localDataSource);

  Future<int> addAddress(CustomerAddressModel address) {
    return localDataSource.addAddress(address);
  }

  Future<void> updateAddress(CustomerAddressModel address) {
    return localDataSource.updateAddress(address);
  }

  Future<void> deleteAddress(int id) {
    return localDataSource.deleteAddress(id);
  }

  Future<List<CustomerAddressModel>> getAddresses(int customerId) {
    return localDataSource.getAddresses(customerId);
  }

  Future<CustomerAddressModel?> getDefaultAddress(int customerId) {
    return localDataSource.getDefaultAddress(customerId);
  }

  Future<void> setDefaultAddress(int customerId, int addressId) {
    return localDataSource.setDefaultAddress(customerId, addressId);
  }
}