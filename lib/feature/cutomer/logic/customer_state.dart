import '../data/model/customer_model.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerSuccess extends CustomerState {
  final List<CustomerModel> customers;

  CustomerSuccess(this.customers);
}

class CustomerSelected extends CustomerState {
  final CustomerModel customer;

  CustomerSelected(this.customer);
}

class CustomerOperationSuccess extends CustomerState {
  final String message;

  CustomerOperationSuccess(this.message);
}

class CustomerError extends CustomerState {
  final String error;

  CustomerError(this.error);
}



abstract class CustomerAddressState {}

class CustomerAddressInitial extends CustomerAddressState {}

class CustomerAddressLoading extends CustomerAddressState {}

class CustomerAddressLoaded extends CustomerAddressState {
  final List<CustomerAddressModel> addresses;

  CustomerAddressLoaded(this.addresses);
}

class CustomerAddressOperationSuccess extends CustomerAddressState {
  final String message;

  CustomerAddressOperationSuccess(this.message);
}

class CustomerAddressError extends CustomerAddressState {
  final String error;

  CustomerAddressError(this.error);
}