import '../../data/model/customer.dart';

abstract class CustomerReportState {}

class CustomerReportInitial extends CustomerReportState {}

class CustomerReportLoading extends CustomerReportState {}

class CustomerReportLoaded extends CustomerReportState {
  final List<CustomerReportModel> customers;

  CustomerReportLoaded(this.customers);
}

class CustomerReportError extends CustomerReportState {
  final String message;

  CustomerReportError(this.message);
}