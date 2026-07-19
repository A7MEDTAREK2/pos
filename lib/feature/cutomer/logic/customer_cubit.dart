import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/customer_model.dart';
import '../data/repo/address_local_rapo.dart';
import '../data/repo/local_rapo.dart';
import 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepository repository;

  CustomerCubit(this.repository) : super(CustomerInitial());

  List<CustomerModel> customers = [];

  CustomerModel? selectedCustomer;

  // ==========================
  // Load Customers
  // ==========================
  Future<void> loadCustomers() async {
    emit(CustomerLoading());

    try {
      customers = await repository.getCustomers();

      emit(CustomerSuccess(customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  // ==========================
  // Search
  // ==========================
  Future<void> searchCustomers(String keyword) async {
    try {
      if (keyword.trim().isEmpty) {
        await loadCustomers();
        return;
      }

      customers = await repository.searchCustomers(keyword);

      emit(CustomerSuccess(customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  // ==========================
  // Add
  // ==========================
  Future<int?> addCustomer(CustomerModel customer) async {
    try {
      final newCustomer = await repository.addCustomer(customer);

      emit(CustomerOperationSuccess("تم إضافة العميل"));

      await loadCustomers();

      return newCustomer;
    } catch (e) {
      emit(CustomerError(e.toString()));
      return null;
    }
  }

  // ==========================
  // Update
  // ==========================
  Future<void> updateCustomer(CustomerModel customer) async {
    try {
      await repository.updateCustomer(customer);

      emit(CustomerOperationSuccess("تم تعديل العميل"));

      await loadCustomers();
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  // ==========================
  // Delete
  // ==========================
  Future<void> deleteCustomer(int id) async {
    try {
      await repository.deleteCustomer(id);

      emit(CustomerOperationSuccess("تم حذف العميل"));

      await loadCustomers();
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  // ==========================
  // Get By Phone
  // ==========================
  Future<CustomerModel?> getCustomerByPhone(String phone) async {
    try {
      return await repository.getCustomerByPhone(phone);
    } catch (_) {
      return null;
    }
  }

  // ==========================
  // Select Customer
  // ==========================
  void selectCustomer(CustomerModel customer) {
    selectedCustomer = customer;

    emit(CustomerSelected(customer));
  }

  // ==========================
  // Clear Selection
  // ==========================
  void clearSelection() {
    selectedCustomer = null;

    emit(CustomerInitial());
  }
  Future<CustomerModel?> findCustomerByPhone(String phone) async {
    try {
      final customer = await repository.getCustomerByPhone(phone);

      if (customer != null) {
        selectedCustomer = customer;
        emit(CustomerSelected(customer));
      }

      return customer;
    } catch (e) {
      emit(CustomerError(e.toString()));
      return null;
    }
  }
}


class CustomerAddressCubit extends Cubit<CustomerAddressState> {
  final CustomerAddressRepository repository;

  CustomerAddressCubit(this.repository)
      : super(CustomerAddressInitial());

  List<CustomerAddressModel> addresses = [];

  CustomerAddressModel? selectedAddress;

  // ==========================
  // Load Addresses
  // ==========================
  Future<void> loadAddresses(int customerId) async {
    emit(CustomerAddressLoading());

    try {
      addresses = await repository.getAddresses(customerId);

      if (addresses.isNotEmpty) {
        selectedAddress = addresses.firstWhere(
              (e) => e.isDefault,
          orElse: () => addresses.first,
        );
      }

      emit(CustomerAddressLoaded(addresses));
    } catch (e) {
      emit(CustomerAddressError(e.toString()));
    }
  }

  // ==========================
  // Add
  // ==========================
  Future<void> addAddress(CustomerAddressModel address) async {
    try {
      await repository.addAddress(address);
      await loadAddresses(address.customerId);
    } catch (e) {
      emit(CustomerAddressError(e.toString()));
    }
  }

  // ==========================
  // Update
  // ==========================
  Future<void> updateAddress(CustomerAddressModel address) async {
    try {
      await repository.updateAddress(address);

      await loadAddresses(address.customerId);

    } catch (e) {
      emit(CustomerAddressError(e.toString()));
    }
  }

  // ==========================
  // Delete
  // ==========================
  Future<void> deleteAddress(
      int id,
      int customerId,
      ) async {
    try {
      await repository.deleteAddress(id);

      await loadAddresses(customerId);

    } catch (e) {
      emit(CustomerAddressError(e.toString()));
    }
  }

  // ==========================
  // Default
  // ==========================
  Future<void> setDefaultAddress(
      int customerId,
      int addressId,
      ) async {
    try {
      await repository.setDefaultAddress(
        customerId,
        addressId,
      );

      await loadAddresses(customerId);
    } catch (e) {
      emit(CustomerAddressError(e.toString()));
    }
  }

  // ==========================
  // Select
  // ==========================
  void selectAddress(CustomerAddressModel address) {
    selectedAddress = address;

    emit(CustomerAddressLoaded(addresses));
  }
}