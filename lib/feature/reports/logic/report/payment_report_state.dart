import '../../data/model/payment_report.dart';

abstract class PaymentReportState {}

class PaymentReportInitial extends PaymentReportState {}

class PaymentReportLoading extends PaymentReportState {}

class PaymentReportLoaded extends PaymentReportState {
  final List<PaymentReportModel> payments;

  PaymentReportLoaded(this.payments);
}

class PaymentReportError extends PaymentReportState {
  final String message;

  PaymentReportError(this.message);
}