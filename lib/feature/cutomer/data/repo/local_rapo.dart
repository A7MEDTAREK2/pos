import '../../../../core/service/audit_log_service.dart';
import '../data_source/address_local_data_source.dart';
import '../data_source/local_data_source.dart';
import '../model/customer_model.dart';

class CustomerAddressRepository {
  final CustomerAddressLocalDataSource localDataSource;

  CustomerAddressRepository(this.localDataSource);

  Future<int> addAddress(CustomerAddressModel address) async {
    final id = await localDataSource.addAddress(address);
    if (id > 0) {
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'CREATE',
        module: 'عناوين العملاء',
        entityType: 'CustomerAddress',
        entityId: id.toString(),
        description: 'تم إضافة عنوان جديد للعميل',
      );
    }
    return id;
  }

  Future<void> updateAddress(CustomerAddressModel address) async {
    await localDataSource.updateAddress(address);
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'UPDATE',
      module: 'عناوين العملاء',
      entityType: 'CustomerAddress',
      entityId: address.id?.toString() ?? '',
      description: 'تم تحديث عنوان العميل',
    );
  }

  Future<void> deleteAddress(int id) async {
    await localDataSource.deleteAddress(id);
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'DELETE',
      module: 'عناوين العملاء',
      entityType: 'CustomerAddress',
      entityId: id.toString(),
      description: 'تم حذف عنوان العميل برقم: $id',
    );
  }

  Future<List<CustomerAddressModel>> getAddresses(int customerId) {
    return localDataSource.getAddresses(customerId);
  }

  Future<CustomerAddressModel?> getDefaultAddress(int customerId) {
    return localDataSource.getDefaultAddress(customerId);
  }

  Future<void> setDefaultAddress(int customerId, int addressId) async {
    await localDataSource.setDefaultAddress(customerId, addressId);
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'UPDATE',
      module: 'عناوين العملاء',
      entityType: 'CustomerAddress',
      entityId: addressId.toString(),
      description: 'تم تعيين العنوان الافتراضي للعميل',
    );
  }
}

class CustomerRepository {
  final CustomerLocalDataSource localDataSource;

  CustomerRepository(this.localDataSource);

  Future<int> addCustomer(CustomerModel customer) async {
    final id = await localDataSource.addCustomer(customer);
    if (id > 0) {
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'CREATE',
        module: 'العملاء',
        entityType: 'Customer',
        entityId: id.toString(),
        description: 'تم إضافة عميل جديد: ${customer.name ?? ""}',
      );
    }
    return id;
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    await localDataSource.updateCustomer(customer);
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'UPDATE',
      module: 'العملاء',
      entityType: 'Customer',
      entityId: customer.id?.toString() ?? '',
      description: 'تم تحديث بيانات العميل: ${customer.name ?? ""}',
    );
  }

  Future<void> deleteCustomer(int id) async {
    await localDataSource.deleteCustomer(id);
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'DELETE',
      module: 'العملاء',
      entityType: 'Customer',
      entityId: id.toString(),
      description: 'تم حذف العميل برقم: $id',
    );
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