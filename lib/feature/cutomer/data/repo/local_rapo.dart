import '../data_source/local_data_source.dart';
import '../model/customer_model.dart';

class CustomerRepository {
  final CustomerLocalDataSource localDataSource;

  CustomerRepository(this.localDataSource);

  Future<int> addCustomer(CustomerModel customer) {
    return localDataSource.addCustomer(customer);
  }

  Future<void> updateCustomer(CustomerModel customer) {
    return localDataSource.updateCustomer(customer);
  }

  Future<void> deleteCustomer(int id) {
    return localDataSource.deleteCustomer(id);
  }

  Future<List<CustomerModel>> getCustomers() {
    return localDataSource.getCustomers();
  }

  Future<List<CustomerModel>> searchCustomers(String keyword) {
    return localDataSource.searchCustomers(keyword);
  }

  Future<CustomerModel?> getCustomerByPhone(String phone) {
    return localDataSource.getCustomerByPhone(phone);
  }

  Future<CustomerModel?> getCustomerById(int id) {
    return localDataSource.getCustomerById(id);
  }
}