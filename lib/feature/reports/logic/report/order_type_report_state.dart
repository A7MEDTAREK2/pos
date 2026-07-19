import '../../data/model/order_type_report.dart';

abstract class OrderTypeReportState {}

class OrderTypeReportInitial extends OrderTypeReportState {}

class OrderTypeReportLoading extends OrderTypeReportState {}

class OrderTypeReportLoaded extends OrderTypeReportState {
  final List<OrderTypeReportModel> orderTypes;

  OrderTypeReportLoaded(this.orderTypes);
}

class OrderTypeReportError extends OrderTypeReportState {
  final String message;

  OrderTypeReportError(this.message);
}